#!/bin/bash

# Variáveis
RESOURCE_GROUP="MotoScan-RG"
VM_NAME="motoscan-vm"
DOCKER_IMAGE="motoscan-app:latest"

# Obter IP público da VM
IP_ADDRESS=$(az vm show --resource-group $RESOURCE_GROUP --name $VM_NAME --show-details --query publicIps -o tsv)

# Obter nome de usuário
ADMIN_USERNAME="azureuser"

# 1. Construir a imagem Docker localmente
echo "Construindo imagem Docker..."
docker build -t $DOCKER_IMAGE .

# 2. Salvar a imagem como arquivo tar
echo "Salvando imagem Docker..."
docker save -o motoscan-app.tar $DOCKER_IMAGE

# 3. Copiar a imagem para a VM
echo "Copiando imagem para a VM..."
scp motoscan-app.tar $ADMIN_USERNAME@$IP_ADDRESS:~/

# 4. Carregar e executar a imagem na VM
echo "Executando aplicação na VM..."
ssh $ADMIN_USERNAME@$IP_ADDRESS "docker load -i ~/motoscan-app.tar && docker run -d -p 80:80 --name motoscan $DOCKER_IMAGE"

echo "Aplicação implantada com sucesso!"
echo "Acesse a API em: http://$IP_ADDRESS/swagger"