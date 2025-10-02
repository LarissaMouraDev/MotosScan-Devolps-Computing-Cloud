MotosScan - Sistema de Gerenciamento de Motos
📋 Sobre o Projeto
MotosScan é uma aplicação web desenvolvida em ASP.NET Core para gerenciamento de frota de motocicletas. O sistema permite realizar operações CRUD (Create, Read, Update, Delete) completas sobre um cadastro de motos, com banco de dados hospedado na nuvem Azure.

## Membros da Equipe
- Larissa de Freitas Moura - RM555136
- Guilherme Francisco Silva - RM557648

🏗️ Arquitetura
Stack Tecnológica

Backend: ASP.NET Core / .NET 8
Banco de Dados: Azure SQL Database
Cloud: Microsoft Azure (App Service + SQL Database)
ORM: Entity Framework Core
API: RESTful API com documentação Swagger

Estrutura da Solução
MotosScan.NET/
├── Controllers/        # Controladores da API
├── Models/            # Modelos de dados (Moto, Manutencao)
├── Data/              # Contexto do Entity Framework
├── Properties/        # Configurações do projeto
└── appsettings.json   # Configurações e connection string

🗄️ Modelo de Dados
Tabela: Moto
CampoTipoDescriçãoIdINT (PK)Identificador únicoMarcaNVARCHAR(100)Marca da motocicletaModeloNVARCHAR(100)Modelo da motocicletaAnoFabricacaoINTAno de fabricaçãoPlacaNVARCHAR(10)Placa (único)CorNVARCHAR(50)Cor da motoImagemUrlNVARCHAR(500)URL da imagem

☁️ Infraestrutura Azure
Recursos Criados

Grupo de Recursos: rg-motoscansql

Organiza todos os recursos do projeto


SQL Server: sql-motosscan-fiap2

Região: Brazil South
Autenticação: SQL Authentication
Administrador: adminmoto


Banco de Dados: motoscanchallenge

Camada: Basic (5 DTUs)
Custo: ~R$ 25/mês
Backup: Localmente redundante


App Service: motoscan20251001213344

Plano: F1 (Free Tier)
Runtime: .NET 8
Sistema Operacional: Windows
Região: Brazil South



Configuração de Rede

Firewall configurado para permitir serviços Azure
IP do cliente adicionado às regras de acesso
Conexões criptografadas (SSL/TLS)


🚀 Funcionalidades
Endpoints da API
Listar todas as motos
GET /api/Motos
Retorna array JSON com todas as motos cadastradas.
Buscar moto por ID
GET /api/Motos/{id}
Retorna os dados de uma moto específica.
Criar nova moto
POST /api/Motos
Content-Type: application/json

{
  "marca": "Honda",
  "modelo": "CG 160",
  "anoFabricacao": 2023,
  "placa": "ABC1234",
  "cor": "Vermelha"
}
Atualizar moto
PUT /api/Motos/{id}
Content-Type: application/json

{
  "id": 1,
  "marca": "Honda",
  "modelo": "CG 160 Fan",
  "anoFabricacao": 2023,
  "placa": "ABC1234",
  "cor": "Azul"
}
Deletar moto
DELETE /api/Motos/{id}
Remove uma moto do banco de dados.

🔧 Configuração Local
Pré-requisitos

.NET 8 SDK
Visual Studio 2022 ou VS Code
Acesso ao Azure Portal

Connection String
No arquivo appsettings.json:
json{
  "ConnectionStrings": {
    "DefaultConnection": "Server=tcp:sql-motosscan-fiap2.database.windows.net,1433;Initial Catalog=motoscanchallenge;Persist Security Info=False;User ID=adminmoto;Password=SUA_SENHA;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}
Executar Localmente
bashdotnet restore
dotnet build
dotnet run
Acesse: https://localhost:5001/swagger

📦 Deploy no Azure
Via Visual Studio

Botão direito no projeto → Publicar
Selecionar Azure → App Service (Windows)
Escolher o App Service criado
Clicar em Publicar

Configuração no App Service
No Portal Azure, adicionar em Configuração:
Nome: ConnectionStrings__DefaultConnection
Valor: Connection string completa com senha
Após salvar, reiniciar o App Service.

🎯 Requisitos Atendidos

✅ Banco de dados na nuvem (Azure SQL Database)
✅ CRUD completo implementado
✅ Aplicação publicada no Azure (App Service)
✅ Código-fonte no GitHub
✅ Documentação técnica completa


🔗 URLs

Repositório GitHub: https://github.com/LarissaMouraDev/MotosScan.NET
Aplicação (Azure): https://motoscan20251001213344.azurewebsites.net
API Swagger: https://motoscan20251001213344.azurewebsites.net/swagger


👥 Equipe
Aluno: Larissa Moura
RM: 555136
Instituição: FIAP - Faculdade de Informática e Administração Paulista
Disciplina: DevOps Tools & Cloud Computing

📄 Licença
Este projeto foi desenvolvido para fins acadêmicos como parte da disciplina de DevOps Tools & Cloud Computing da FIAP.
