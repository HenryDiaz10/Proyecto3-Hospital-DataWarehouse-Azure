#!/bin/bash
# Variables de entorno para el despliegue automatizado
RESOURCE_GROUP="rg-hospital-dw-prod"
LOCATION="eastus"
STORAGE_ACCOUNT="sthospitaldwprod$(date +%s)" # Nombre único basado en timestamp

echo "1. Creando el Grupo de Recursos..."
az group create --name \(RESOURCE_GROUP --location\)LOCATION

echo "2. Creando la Cuenta de Almacenamiento con ADLS Gen2 (Hierarchical Namespace)..."
az storage account create \
    --name $STORAGE_ACCOUNT \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --sku Standard_LRS \
    --kind StorageV2 \
    --hierarchical-namespace true

echo "3. Obteniendo la clave de acceso para los contenedores..."
ACCOUNT_KEY=\((az storage account keys list --resource-group\)RESOURCE_GROUP --account-name $STORAGE_ACCOUNT --query '[0].value' -o tsv)

echo "4. Creando los contenedores de la Arquitectura Medallion (Bronze, Silver, Gold)..."
az storage container create --name bronze --account-name \(STORAGE_ACCOUNT --account-key\)ACCOUNT_KEY
az storage container create --name silver --account-name \(STORAGE_ACCOUNT --account-key\)ACCOUNT_KEY
az storage container create --name gold --account-name \(STORAGE_ACCOUNT --account-key\)ACCOUNT_KEY

echo "¡Infraestructura desplegada exitosamente!"