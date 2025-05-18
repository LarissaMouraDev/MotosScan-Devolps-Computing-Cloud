# MotosScan API - Projeto DevOps & Cloud Computing

## Descrição do Projeto
MotosScan é uma API RESTful para gerenciamento de uma frota de motocicletas da Mottu, desenvolvida com ASP.NET Core e implantada em ambiente de nuvem Azure. A API permite o controle de entrada e saída de motos, gerenciamento de informações da frota e persistência de dados.

## Membros da Equipe
- Larissa de Freitas Moura - RM555136
- João Victor Rebello - RM555287
- Guilherme Francisco Silva - RM557648

## Tecnologias Utilizadas
- ASP.NET Core 8.0
- Entity Framework Core
- SQLite (banco de dados local para demonstração)
- Docker
- Azure Cloud
- Swagger/OpenAPI
- Git/GitHub

## Modelo de Dados
A entidade principal `Moto` possui os seguintes atributos:
- `Id` (int): Identificador único da moto
- `Modelo` (string): Modelo da moto (ex: Honda CG 160)
- `Placa` (string): Placa da moto (ex: ABC1234)
- `Estado` (string): Estado de conservação (Bom, Regular, Excelente)
- `Localizacao` (string): Localização atual da moto (Pátio A, Saída, etc)
- `UltimoCheckIn` (DateTime?): Data e hora do último check-in
- `UltimoCheckOut` (DateTime?): Data e hora do último check-out
- `ImagemUrl` (string): URL para a imagem da moto (se disponível)

## Endpoints da API

### Operações CRUD Básicas
- `GET /api/Motos`: Lista todas as motos cadastradas
- `GET /api/Motos/{id}`: Busca moto pelo ID numérico
- `GET /api/Motos/placa/{placa}`: Busca moto pela placa (ex: ABC1234)
- `POST /api/Motos`: Adiciona nova moto à frota
- `PUT /api/Motos/{id}`: Atualiza informações de uma moto existente
- `DELETE /api/Motos/{id}`: Remove uma moto do sistema

### Operações de Check-in/Check-out
- `POST /api/Motos/checkin?placa={placa}`: Registra entrada de moto com imagem
- `POST /api/Motos/checkout?placa={placa}`: Registra saída de moto com imagem

## Instruções de Instalação e Execução Local

### Pré-requisitos
- .NET SDK 8.0
- Docker Desktop
- Git
- Visual Studio 2022 ou VS Code

### Clonar o Repositório
```bash
git clone https://github.com/SeuUsuario/MotosScan-API.git
cd MotosScan-API