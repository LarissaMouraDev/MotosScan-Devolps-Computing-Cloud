FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
USER app

FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
WORKDIR /src
COPY ["MotoScan.csproj", "."]
RUN dotnet restore "MotoScan.csproj"
COPY . .
RUN dotnet build "MotoScan.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MotoScan.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MotoScan.dll"]