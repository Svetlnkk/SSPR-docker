FROM mcr.microsoft.com/dotnet/sdk:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY *.sln .
COPY ["./", "MainService/"]
RUN dotnet restore "MainService/MainService.Main/MainService.Main.csproj"
RUN dotnet restore "MainService/TestService/TestService.csproj"

WORKDIR "/src/MainService"
RUN dotnet build "MainService.Main/MainService.Main.csproj" -c Release -o /app/build
RUN dotnet build "TestService/TestService.csproj" -c Release -o /app/build


FROM build AS publish
RUN dotnet publish "MainService.Main/MainService.Main.csproj" -c Release -o /app/publish	--no-restore
RUN dotnet publish "TestService/TestService.csproj" -c Release -o /app/publish	--no-restore
COPY ["TestService/TestService.csproj", "/app/publish"] 


FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
RUN dotnet restore
ENTRYPOINT ["dotnet", "MainService.Main.dll"]