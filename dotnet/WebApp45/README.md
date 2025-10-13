# Simple Node.js application

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=devpro.scannersamples.dotnet.webappmvc&metric=alert_status)](https://sonarcloud.io/dashboard?id=devpro.scannersamples.dotnet.webappmvc)

## Run the application

- Run in Debug mode from Visual Studio 2019

## Run the scanner

- Run the scan
  - On Windows (replace with the correct values):

  ```dos
  "SonarScanner.MSBuild.exe" begin /k:"<projetKey>" /o:"<company>" /d:sonar.login="<token>" /d:sonar.host.url="https://sonarcloud.io" /d:sonar.exclusions="Scripts/**"
  "MSBuild.exe" WebApp45.sln /t:Rebuild
  "SonarScanner.MSBuild.exe" end /d:sonar.login="<token>"
  ```
