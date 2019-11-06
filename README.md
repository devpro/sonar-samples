# Sample projects for SonarSource scanner

Samples of projects to use with SonarSource scanner.

## Requirements

This setup is necessary to run Sonar scanner on the different projets.

- [Java RE](https://java.com/en/download/)
- [.NET Core SDK](https://dotnet.microsoft.com/download)
  - [dotnet format global tool](https://github.com/dotnet/format): `dotnet tool install -g dotnet-format`
  - [dotnet sonarscanner global tool](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner-for-msbuild/): `dotnet tool install --global dotnet-sonarscanner`
- [Node.js](https://nodejs.org/)
  - [NPM module to run SonarQube/SonarCloud analyses](https://www.npmjs.com/package/sonarqube-scanner): `npm install -g sonarqube-scanner`
- [SonarScanner for MSBuild](https://sonarcloud.io/documentation/analysis/scan/sonarscanner-for-msbuild)

## Projects

Name | Language | Description
---- | -------- | -----------
[Simple Node.js app](./nodejs/simple-app/README.md) | Node.js | Simple web application (1 file)
[ASP.NET 4.5 MVC app](./dotnet/WebApp45/README.md) | .NET Framework | ASP.NET 4.5 MVC application created from VS 2019 template
[ASP.NET Core Razor app](./dotnetcore/WebAppRazor/README.md) | .NET Core | ASP.NET Core 3.0 Razor application created from VS 2019 template
