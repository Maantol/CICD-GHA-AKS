# Terraform Remote Backend Azure Bootstrap

This repository contains a ready **Terraform configuration** for creating a **Remote Backend** in **Microsoft Azure**.  
The configuration provisions the necessary Azure resources to securely store Terraform state files when deploying infrastructure.

## Prerequisites

**Valid Azure Subscription**

**Azure CLI** – [Download](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

**Terraform/OpenTofu** - [Terraform Download](https://developer.hashicorp.com/terraform/install), [OpenTofu Download](https://opentofu.org/docs/intro/install/)


## Login to your Azure Subscription

Authenticated to your Azure Subscription:
```bash
az login
```
Proceed with instructions. Obtain your Subscription ID.

## Remote Backend Setup with Terraform

- You need to pass your Subscription ID to your Terraform configuration.
- You must give desired Resource Group name and desired Region


#### Option 1 (Create terraform.tfvars file)

You need to write values to terraform.tf.vars file. You can use example **terraform.example.tfvars** file. Copy it as terraform.tfvars and edit: 

```hcl
azure_subscription_id = "<YOUR SUBSCRIPTION_ID>"
azure_resource_group  = "<RESOURCE_GROUP_NAME>"
azure_location        = "<REGION>"
```

#### Option 2 (Pass variables on the CLI)

You can pass variables while applying configuration.

```bash
terraform apply \
  -var="azure_subscription_id=<YOUR_SUBSCRIPTION_ID>" \
  -var="azure_resource_group=<RESOURCE_GROUP_NAME>" \
  -var="azure_location=<REGION>" \
  -auto-approve
```

#### Option 3 (Environment variables)

Terraform also accepts variables from environment variables by prefixing the variable name with `TF_VAR_`.

```bash
export TF_VAR_azure_subscription_id="<YOUR_SUBSCRIPTION_ID>"
export TF_VAR_azure_resource_group="<RESOURCE_GROUP_NAME>"
export TF_VAR_azure_location="<REGION>"
```

## Initialize the configuration

Initialize your configuration. Terraform downloads required providers and creates own required files.

```bash
terraform init
```

## Validate the configuration

Validate your configuration.

```bash
terraform validate
```

## Check the configuration planning

You can check your configuration plan.

```bash
terraform plan
```

## Apply the configuration

```bash
terraform apply -auto-approve
```

# Acquire Storage Account Name and Container Name

After applying the configuration, take the **Storage Account Name** and **Container Name** from the configuration result. You will need them when you start creating your infrastructure and provide these values to the Terraform backend configuration.

Now your Azure subscription has a resource group that contains a storage account and a storage container, where you can store your Terraform tfstate file as a remote backend configuration.


