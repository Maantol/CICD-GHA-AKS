#!/bin/sh

set -euo pipefail

# Verify that Azure CLI is installed
if ! command -v az >/dev/null 2>&1; then
    echo "❌ Azure CLI not installed!"
    exit 1
fi

# Verify that user is logged in to Azure
if ! az account show >/dev/null 2>&1; then
    echo "❌ Azure login not performed. Please login using 'az login'"
    exit 1
fi

# Request Azure Entra ID App Registration Display Name
while true; do
read -p "🔗 New Azure Entra ID App Registration Display Name: " APP_REG_NAME
if [ -n "$APP_REG_NAME" ]; then
    break
else
echo "❌ Error! App registration name cannot be empty!"
fi
done

# Request Azure Federated Credential Name
while true; do
read -p "🔗 New Azure Federated Credential Name: " FEDERATED_NAME
if [ -n "$FEDERATED_NAME" ]; then
    break
else
    echo "❌ Error! Federated Credential Name cannot be empty!"
fi
done

# Request GitHub Repo
while true; do
read -p "📦 Your GitHub Repo (username/repository): " GITHUB_REPO
if [ -z "$GITHUB_REPO" ] || ! echo "$GITHUB_REPO" | grep -Eq '^[^/]+/[^/]+$'; then
    echo "❌ Invalid format. Please use 'username/repository'"
else
    break
fi
done

# Request Github Repo Branch to follow
while true; do
read -p "📦 Your GitHub Repo Branch to follow (for eg. main): " GITHUB_BRANCH
if [ -n "$GITHUB_BRANCH" ]; then
    break
else
    echo "❌ Error! You must give a branch!"
fi
done

# Validate Entra ID App Registration Display Name
echo "🔍 Validating your Entra ID App Registration Display Name..."
VALIDATE_APP=$(az ad app list --display-name "$APP_REG_NAME" --query "[].displayName" -o tsv)
if [ "$VALIDATE_APP" = "$APP_REG_NAME" ]; then
    echo "❌ Error! Entra ID App Registration Display Name already exists!"
    exit 1
fi

# Create Entra ID App
echo "⏳ Creating Entra ID App..."
APP_ID=$(az ad app create --display-name "$APP_REG_NAME" --query appId -o tsv)
if [ -z "$APP_ID" ]; then
    echo "❌ Failed to create Entra ID App Registration!"
    exit 1
fi
echo "✅ Entra ID App Registration Display Name '$APP_REG_NAME' created successfully!"

# Create Service Principal
echo "⏳ Creating Service Principal..."
SP_ID=$(az ad sp create --id "$APP_ID" --query id -o tsv)
if [ -z "$SP_ID" ]; then
    echo "❌ Failed to create Service Principal!"
    exit 1
fi
echo "✅ Service Principal for App ID created successfully!"

# Acquire Subscription ID
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
if [ -z "$SUBSCRIPTION_ID" ]; then
    echo "❌ Failed to retrieve Subscription ID"
    exit 1
fi
SUBSCRIPTION_SCOPE="/subscriptions/$SUBSCRIPTION_ID"

# Assign Contributor role
echo "⏳ Assigning 'Contributor' role to Service Principal..."
az role assignment create --assignee "$APP_ID" --role "Contributor" --scope "$SUBSCRIPTION_SCOPE" -o none || {
    echo "❌ Failed to assign 'Contributor' role!"
    exit 1
}

# Validate role assignment
ROLE_CHECK=$(az role assignment list --assignee "$APP_ID" --role "Contributor" --scope "$SUBSCRIPTION_SCOPE" --query "[].roleDefinitionName" -o tsv)
if [ "$ROLE_CHECK" = "Contributor" ]; then
    echo "✅ 'Contributor' role successfully assigned"
else
    echo "❌ Role assignment verification failed!"
    exit 1
fi

# Create Federated Credentials
echo "⏳ Creating Federated Credentials..."
VALIDATE_FC=$(az ad app federated-credential list --id "$APP_ID" --query "[?name=='$FEDERATED_NAME'].name" -o tsv)
if [ "$VALIDATE_FC" = "$FEDERATED_NAME" ]; then
    echo "❌ Federated Credential Name already exists."
    exit 1
fi

az ad app federated-credential create \
    --id "$APP_ID" \
    --parameters "{
        \"name\": \"$FEDERATED_NAME\",
        \"issuer\": \"https://token.actions.githubusercontent.com\",
        \"subject\": \"repo:$GITHUB_REPO:ref:refs/heads/$GITHUB_BRANCH\",
        \"description\": \"Github Actions OIDC Federated Credentials for $GITHUB_REPO following $GITHUB_BRANCH branch\",
        \"audiences\": [\"api://AzureADTokenExchange\"]
    }" -o none || {
        echo "❌ Failed to create Federated Credential!"
        exit 1
    }

# Validate Federated Credential creation
VALIDATE_FC_CREATION=$(az ad app federated-credential list --id "$APP_ID" --query "[?name=='$FEDERATED_NAME'].name" -o tsv)
if [ "$VALIDATE_FC_CREATION" = "$FEDERATED_NAME" ]; then
    echo "✅ Federated Credential '$FEDERATED_NAME' created successfully!"
else
    echo "❌ Federated Credential verification failed!"
    exit 1
fi

echo "🎉 All steps completed successfully! Now copy this values as GitHub Secrets"
echo "-----------------------------------------------------------"
echo "AZURE_CLIENT_ID: $APP_ID"
echo "AZURE_TENANT_ID: $(az account show --query tenantId -o tsv)"
echo "AZURE_SUBSCRIPTION_ID: $SUBSCRIPTION_ID"
echo ""
