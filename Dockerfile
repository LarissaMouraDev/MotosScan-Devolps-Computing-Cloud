FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
USER app

FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
WORKDIR /src
COPY ["MotosScan.csproj", "."]
RUN dotnet restore "MotosScan.csproj"
COPY . .
RUN dotnet build "MotosScan.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MotosScan.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Criar um diretório para o banco de dados SQLite e dar permissões
USER root
RUN mkdir -p /app/data && chown -R app:app /app/data
USER app

ENTRYPOINT ["dotnet", "MotosScan.dll"]