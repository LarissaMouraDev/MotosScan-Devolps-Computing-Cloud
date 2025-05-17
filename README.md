# API de Check-in/Check-out de Motos (MotoScan)

## Descrição do Projeto
API RESTful para gerenciamento de check-in e check-out de motos utilizando visão computacional. O sistema permite registrar entrada e saída de motos através de fotos ou QR codes, com reconhecimento automático do modelo, estado e localização.

## Tecnologias Utilizadas
- ASP.NET Core 8.0
- Entity Framework Core
- Oracle Database
- Docker
- Azure Cloud

## Rotas da API
- `GET /api/Motos` - Lista todas as motos
- `GET /api/Motos/{id}` - Obtém detalhes de uma moto específica
- `GET /api/Motos/placa/{placa}` - Busca moto pela placa
- `POST /api/Motos` - Registra uma nova moto
- `PUT /api/Motos/{id}` - Atualiza informações de uma moto
- `DELETE /api/Motos/{id}` - Remove uma moto do sistema
- `POST /api/Motos/checkin` - Realiza check-in de uma moto via imagem
- `POST /api/Motos/checkout` - Realiza check-out de uma moto via imagem

## Instruções de Instalação

### Execução Local
1. Clone este repositório
2. Execute `dotnet restore` para restaurar as dependências
3. Configure a string de conexão do Oracle no arquivo `appsettings.json`
4. Execute `dotnet ef database update` para criar o banco de dados
5. Execute `dotnet run` para iniciar a aplicação

### Execução com Docker
1. Construa a imagem Docker: