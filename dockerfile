# Użycie obrazu SDK .NET 8.0 jako bazowego
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Etap build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["DocsApp.csproj", "./"]
RUN dotnet restore "./DocsApp.csproj"
COPY . .
RUN dotnet build "DocsApp.csproj" -c Release -o /app/build

# Etap publish
FROM build AS publish
RUN dotnet publish "DocsApp.csproj" -c Release -o /app/publish

# Finalny etap runtime
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DocsApp.dll"]
