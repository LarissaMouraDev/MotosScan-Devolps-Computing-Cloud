#!/bin/bash

# Script para remoção dos recursos da MotosScan API no Azure
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
echo "║              Script de Limpeza de Recursos v1.0               ║"
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

# Avisos
echo -e "${RED}ATENÇÃO: Este script irá remover TODOS os recursos no grupo de recursos '$RESOURCE_GROUP'${NC}"
echo -e "${RED}Isso inclui a máquina virtual e todos os dados associados.${NC}"
echo -e "${RED}Esta ação NÃO PODE ser desfeita.${NC}"
echo ""

# Verificar se o grupo de recursos existe
echo -e "${YELLOW}Verificando se o grupo de recursos '$RESOURCE_GROUP' existe...${NC}"
if ! az group show --name $RESOURCE_GROUP &> /dev/null; then
    echo -e "${RED}O grupo de recursos '$RESOURCE_GROUP' não existe. Nada a remover.${NC}"
    exit 0
fi

# Tirar um screenshot dos recursos antes da remoção (opcional)
echo -e "${YELLOW}Salvando informações dos recursos antes da remoção...${NC}"

# Listar VMs no grupo de recursos
echo -e "${YELLOW}Máquinas virtuais no grupo '$RESOURCE_GROUP':${NC}"
az vm list --resource-group $RESOURCE_GROUP --output table

# Confirmação
echo ""
read -p "Você tem certeza que deseja remover TODOS os recursos? (digite 'sim' para confirmar): " confirmation
if [[ "$confirmation" != "sim" ]]; then
    echo -e "${GREEN}Operação cancelada. Nenhum recurso foi removido.${NC}"
    exit 0
fi

# Remoção dos recursos
echo -e "${YELLOW}Iniciando a remoção do grupo de recursos '$RESOURCE_GROUP'...${NC}"
echo -e "${YELLOW}Isso pode levar alguns minutos...${NC}"

# Capturar data e hora atuais para o nome do arquivo de screenshot
timestamp=$(date +"%Y%m%d_%H%M%S")
screenshot_file="azure_resource_removal_${timestamp}.txt"

# Salvar informações em um arquivo como "screenshot"
echo "Screenshot de remoção de recursos - MotosScan API" > $screenshot_file
echo "Data e hora: $(date)" >> $screenshot_file
echo "" >> $screenshot_file
echo "Lista de recursos no grupo '$RESOURCE_GROUP' antes da remoção:" >> $screenshot_file
az resource list --resource-group $RESOURCE_GROUP --output table >> $screenshot_file

# Remover o grupo de recursos
az group delete --name $RESOURCE_GROUP --yes --no-wait

echo -e "${GREEN}Comando de remoção enviado com sucesso.${NC}"
echo -e "${YELLOW}A remoção dos recursos pode levar alguns minutos para ser concluída.${NC}"
echo -e "${GREEN}Um 'screenshot' das informações dos recursos foi salvo em '$screenshot_file'${NC}"

# Aguardar a remoção (opcional, pode ser removido se não quiser esperar)
echo -e "${YELLOW}Aguardando a remoção dos recursos...${NC}"
echo -e "${YELLOW}(Isso pode levar alguns minutos. Pressione Ctrl+C para interromper a espera, mas a remoção continuará em segundo plano.)${NC}"

while az group show --name $RESOURCE_GROUP &> /dev/null; do
    echo -e "${YELLOW}Recursos ainda estão sendo removidos. Aguardando...${NC}"
    sleep 10
done

echo -e "${GREEN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║             RECURSOS REMOVIDOS COM SUCESSO!                ║"
echo "║                                                            ║"
echo "║  Todos os recursos no grupo '$RESOURCE_GROUP' foram      ║"
echo "║  removidos com sucesso.                                   ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${YELLOW}Um 'screenshot' das informações dos recursos foi salvo em '$screenshot_file'${NC}"
echo -e "${YELLOW}Você pode usar este arquivo como evidência da remoção dos recursos para o trabalho.${NC}"