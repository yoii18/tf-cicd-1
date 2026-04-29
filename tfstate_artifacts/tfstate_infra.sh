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
        --min-tls-version "TLS_1_2" \
        --hns true
fi

if [ "$(az storage container exists --name staging)" = "false" ]; then
    az storage container create --name staging --acount-name "$STRG_ACCT_NAME"
fi

if [ "$(az storage container exists --name prod)" = "false" ]; then
    az storage container create --name prod --acount-name "$STRG_ACCT_NAME"
fi