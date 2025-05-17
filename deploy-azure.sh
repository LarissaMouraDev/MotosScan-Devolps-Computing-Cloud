#!/bin/bash

# Variáveis
RESOURCE_GROUP="MotoScan-RG"
LOCATION="eastus"
VM_NAME="motoscan-vm"
VM_SIZE="Standard_B1s"
ADMIN_USERNAME="azureuser"

# 1. Criar grupo de recursos
echo "Criando grupo de recursos..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# 2. Criar VM Linux
echo "Criando máquina virtual..."
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --image Ubuntu2204 \
  --size $VM_SIZE \
  --admin-username $ADMIN_USERNAME \
  --generate-ssh-keys \
  --public-ip-sku Standard

# 3. Abrir portas
echo "Abrindo portas necessárias..."
az vm open-port \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --port 80,443,22 \
  --priority 1000

# 4. Instalar Docker na VM
echo "Instalando Docker..."
az vm run-command invoke \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --command-id RunShellScript \
  --scripts "sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable\" && sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io && sudo usermod -aG docker $ADMIN_USERNAME"

# Obter IP público da VM
IP_ADDRESS=$(az vm show --resource-group $RESOURCE_GROUP --name $VM_NAME --show-details --query publicIps -o tsv)
echo "Máquina virtual criada em: $IP_ADDRESS"