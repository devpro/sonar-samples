# ASP.NET Core Razor web application

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=devpro.scannersamples.dotnetcore.webapprazor&metric=alert_status)](https://sonarcloud.io/dashboard?id=devpro.scannersamples.dotnetcore.webapprazor)

## Run the application

- Run: `dotnet run --project WebAppRazor\WebAppRazor.csproj`

## Run the scanner

- Run the scan (replace with the correct values):

  ```dos
  dotnet sonarscanner begin /k:"<projetKey>" /o:"<company>" /d:sonar.login="<token>" /d:sonar.host.url="https://sonarcloud.io" /d:sonar.exclusions="wwwroot/lib/**"
  dotnet build
  dotnet sonarscanner end /d:sonar.login="<token>"
  ```
