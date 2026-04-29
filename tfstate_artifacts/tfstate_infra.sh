#!/bin/bash
set -e

LOCATION="japaneast"
TF_RG_NAME="rg-tfstate"
STRG_ACCT_NAME="strgenvtfstate"

if [ "$(az group exists --name "$TF_RG_NAME")" = "false" ]; then
    az group create \
        --name "$TF_RG_NAME" \
        --location "$LOCATION"
fi

if ! az storage account show --name "$STRG_ACCT_NAME" --resource-group "$TF_RG_NAME" &>/dev/null; then
    az storage account create \
        --name "$STRG_ACCT_NAME" \
        --resource-group "$TF_RG_NAME" \
        --sku "Standard_LRS" \
        --min-tls-version "TLS1_2" \
        --hns true
fi

if [ "$(az storage container exists --name staging --account-name "$STRG_ACCT_NAME" --auth-mode login --query exists -o tsv)" = "false" ]; then
    az storage container create --name staging --account-name "$STRG_ACCT_NAME" --auth-mode login
fi

if [ "$(az storage container exists --name prod --account-name "$STRG_ACCT_NAME" --auth-mode login --query exists -o tsv)" = "false" ]; then
    az storage container create --name prod --account-name "$STRG_ACCT_NAME" --auth-mode login
fi

SUB_ID=$(az account show --query id -o tsv)
TENANT_ID=$(az account show --query tenantId -o tsv)

STAGING_APP=$(az ad app create --display-name "staging-app" --query appId -o tsv)
az ad sp create --id "$STAGING_APP"

PROD_APP=$(az ad app create --display-name "prod-app" --query appId -o tsv)
az ad sp create --id "$PROD_APP"

echo "AZURE_TENANT_ID          = $TENANT_ID"
echo "AZURE_SUBSCRIPTION_ID    = $SUB_ID"
echo "AZURE_CLIENT_ID_STAGING  = $STAGING_APP"
echo "AZURE_CLIENT_ID_PROD  = $PROD_APP"
