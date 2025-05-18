#!/bin/bash

# Script para implantação da MotosScan API no Azure
# Autor: Equipe MotosScan
# Data: Maio 2025

# Cores para melhor visualização
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Banner
echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                   MotosScan API - Azure                       ║"
echo "║              Script de Implantação v1.0                       ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Verificar se o Azure CLI está instalado
if ! command -v az &> /dev/null; then
    echo -e "${RED}Azure CLI não encontrado. Por favor, instale o Azure CLI antes de continuar.${NC}"
    echo -e "Instruções de instalação: https://docs.microsoft.com/pt-br/cli/azure/install-azure-cli"
    exit 1
fi

# Verificar se o usuário está logado no Azure
echo -e "${YELLOW}Verificando login no Azure...${NC}"
az account show &> /dev/null
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Você não está logado no Azure. Iniciando o processo de login...${NC}"
    az login
    if [ $? -ne 0 ]; then
        echo -e "${RED}Falha no login. Abortando.${NC}"
        exit 1
    fi
fi

# Variáveis
RESOURCE_GROUP="MotosScan-RG"
LOCATION="eastus"
VM_NAME="motosscan-vm"
VM_SIZE="Standard_B1s"
ADMIN_USERNAME="azureuser"
REPO_URL="https://github.com/SeuUsuario/MotosScan-API.git"

# Função para mostrar o progresso
progress() {
    echo -e "${YELLOW}[$1] $2${NC}"
}

# 1. Criar grupo de recursos
progress "1/5" "Criando grupo de recursos..."
az group create --name $RESOURCE_GROUP --location $LOCATION
if [ $? -ne 0 ]; then
    echo -e "${RED}Falha ao criar o grupo de recursos. Abortando.${NC}"
    exit 1
fi

# 2. Criar VM Linux
progress "2/5" "Criando máquina virtual..."
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --image Ubuntu2204 \
  --size $VM_SIZE \
  --admin-username $ADMIN_USERNAME \
  --generate-ssh-keys \
  --public-ip-sku Standard

if [ $? -ne 0 ]; then
    echo -e "${RED}Falha ao criar a máquina virtual. Abortando.${NC}"
    exit 1
fi

# 3. Abrir portas
progress "3/5" "Abrindo portas necessárias..."
az vm open-port \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --port 80,443,22 \
  --priority 1000

if [ $? -ne 0 ]; then
    echo -e "${RED}Falha ao abrir as portas. Abortando.${NC}"
    exit 1
fi

# 4. Instalar Docker na VM
progress "4/5" "Instalando Docker..."
az vm run-command invoke \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --command-id RunShellScript \
  --scripts "sudo apt-get update && \
            sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common && \
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
            sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable\" && \
            sudo apt-get update && \
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io && \
            sudo usermod -aG docker $ADMIN_USERNAME"

if [ $? -ne 0 ]; then
    echo -e "${RED}Falha ao instalar o Docker. Abortando.${NC}"
    exit 1
fi

# 5. Implantar a aplicação
progress "5/5" "Implantando a aplicação MotosScan..."
az vm run-command invoke \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --command-id RunShellScript \
  --scripts "cd /home/$ADMIN_USERNAME && \
            git clone $REPO_URL MotosScan-API && \
            cd MotosScan-API && \
            sudo docker build -t motosscan-api . && \
            sudo docker run -d -p 80:80 -p 443:443 --name motosscan-container motosscan-api"

if [ $? -ne 0 ]; then
    echo -e "${RED}Falha ao implantar a aplicação. Abortando.${NC}"
    exit 1
fi

# Obter IP público da VM
IP_ADDRESS=$(az vm show --resource-group $RESOURCE_GROUP --name $VM_NAME --show-details --query publicIps -o tsv)

echo -e "${GREEN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║              IMPLANTAÇÃO CONCLUÍDA COM SUCESSO!            ║"
echo "║                                                            ║"
echo -e "║  IP da Máquina Virtual: ${CYAN}$IP_ADDRESS${GREEN}                        ║"
echo -e "║  Aplicação disponível em: ${CYAN}http://$IP_ADDRESS${GREEN}               ║"
echo -e "║  Swagger UI disponível em: ${CYAN}http://$IP_ADDRESS/swagger${GREEN}      ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${YELLOW}Para se conectar à VM via SSH:${NC}"
echo -e "  ssh $ADMIN_USERNAME@$IP_ADDRESS"

echo -e "${YELLOW}Para verificar o status do container Docker:${NC}"
echo -e "  ssh $ADMIN_USERNAME@$IP_ADDRESS 'docker ps'"

echo -e "${YELLOW}Para visualizar os logs da aplicação:${NC}"
echo -e "  ssh $ADMIN_USERNAME@$IP_ADDRESS 'docker logs motosscan-container'"

echo -e "${YELLOW}Para remover os recursos quando terminar (IMPORTANTE):${NC}"
echo -e "  ./cleanup-azure.sh"

# Salvar o IP em um arquivo para uso posterior
echo $IP_ADDRESS > motosscan_ip.txt
echo -e "${GREEN}O endereço IP foi salvo no arquivo 'motosscan_ip.txt'${NC}"