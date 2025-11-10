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
read -p "🔗 To be deleted Azure Entra ID App Registration Display Name: " APP_REG_NAME
if [ -n "$APP_REG_NAME" ]; then
    break
else 
echo "❌ Error! App registration name cannot be empty!"
fi
done

#Validate Azure Entra ID App Registration Display Name

APP_ID=$(az ad app list --display-name "$APP_REG_NAME" --query "[0].appId" -o tsv)

if [ -z "$APP_ID" ]; then
    echo "❌ No App Registration found with name '$APP_REG_NAME'."
    exit 1
fi

echo "⚠️ Found App Registration '$APP_REG_NAME' with App ID: $APP_ID"
while true; do
    read -p "❓ Are you sure you want to delete this App Registration? (yes/no): " CONFIRM
    case "$CONFIRM" in
    yes)
        echo "🗑️ Deleting App Registration..."
        break
        ;;
    no)
        echo "❌ Abort deletion."
        exit 0
        ;;
    *)
        echo "⚠️ Incorrect selection. Please type 'yes' or 'no"
        ;;
    esac
done

#Delete Azure Entra ID App Registration 
az ad app delete --id "$APP_ID"
echo "✅ App Registration '$APP_REG_NAME' successfully deleted!"
