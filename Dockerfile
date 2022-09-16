# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

ENV ASPNETCORE_ENVIRONMENT=Development
#ENV ASPNETCORE_URLS=http://*:80
#UN ["apt-get", "update"]
#RUN ["apt-get", "install", "net-tools"]
#RUN ["apt-get", "install", "curl"]
#RUN ["apt-get", "install", "nano"]
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY src/*.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY src/* ./
RUN dotnet publish -f net6.0 -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "apig-integracion.dll"]