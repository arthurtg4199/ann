FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 5052

ENV ASPNETCORE_URLS=http://+:5052

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["ann.csproj", "./"]
RUN dotnet restore "ann.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ann.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ann.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ann.dll"]
