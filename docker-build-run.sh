#!/bin/bash

# Script para automatizar o processo de build e execução do Docker para a MotosScan API
# Autor: Equipe MotosScan
# Data: Maio 2025

# Cores para melhor visualização
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                    MotosScan API - Docker                     ║"
echo "║              Script de Build e Execução v1.0                  ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Verificar se o Docker está instalado
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker não encontrado. Por favor, instale o Docker antes de continuar.${NC}"
    exit 1
fi

# Verificar se existe um container anterior com o mesmo nome
echo -e "${YELLOW}Verificando containers existentes...${NC}"
if [ "$(docker ps -a -q -f name=motosscan-container)" ]; then
    echo -e "${YELLOW}Container 'motosscan-container' encontrado. Parando e removendo...${NC}"
    docker stop motosscan-container
    docker rm motosscan-container
    echo -e "${GREEN}Container removido com sucesso.${NC}"
else
    echo -e "${GREEN}Nenhum container 'motosscan-container' existente encontrado.${NC}"
fi

# Verificar se existe uma imagem anterior
echo -e "${YELLOW}Verificando imagens existentes...${NC}"
if [[ "$(docker images -q motosscan-api 2> /dev/null)" != "" ]]; then
    echo -e "${YELLOW}Imagem 'motosscan-api' encontrada.${NC}"
    read -p "Deseja reconstruir a imagem? (s/n): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        echo -e "${YELLOW}Construindo a imagem Docker...${NC}"
        docker build -t motosscan-api .
    else
        echo -e "${GREEN}Usando a imagem existente.${NC}"
    fi
else
    echo -e "${YELLOW}Nenhuma imagem 'motosscan-api' encontrada. Construindo...${NC}"
    docker build -t motosscan-api .
fi

# Executando o container
echo -e "${YELLOW}Iniciando o container...${NC}"
docker run -d -p 8080:80 -p 8443:443 --name motosscan-container motosscan-api

# Verificando se o container está rodando
if [ "$(docker ps -q -f name=motosscan-container)" ]; then
    echo -e "${GREEN}Container iniciado com sucesso!${NC}"
    echo -e "${GREEN}Detalhes do container:${NC}"
    docker ps -f name=motosscan-container
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                MotosScan API está rodando!                 ║${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    echo -e "${GREEN}║  API disponível em:      ${CYAN}http://localhost:8080${GREEN}            ║${NC}"
    echo -e "${GREEN}║  Swagger UI disponível em: ${CYAN}http://localhost:8080/swagger${GREEN}  ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    
    echo ""
    echo -e "${YELLOW}Para ver os logs do container:${NC}"
    echo -e "  docker logs motosscan-container"
    
    echo ""
    echo -e "${YELLOW}Para parar o container:${NC}"
    echo -e "  docker stop motosscan-container"
    
    echo ""
    echo -e "${YELLOW}Para remover o container:${NC}"
    echo -e "  docker rm motosscan-container"
else
    echo -e "${YELLOW}Erro ao iniciar o container. Verifique os logs:${NC}"
    docker logs motosscan-container
fi