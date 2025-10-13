# SimpleApp

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=devpro.scannersamples.angular.simpleapp&metric=alert_status)](https://sonarcloud.io/dashboard?id=devpro.scannersamples.angular.simpleapp)

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 8.3.17.

## Run the application

- Install NPM dependencies: `npm install`
- Run `ng serve --open` for a dev server. Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.

## Run the scanner

- Run the scan (replace with the correct values):

  ```dos
  sonar-scanner -D"sonar.projectKey=<projetKey>" -D"sonar.projectName=Angular Simple App Sample" -D"sonar.organization=<company>" -D"sonar.sources=." -D"sonar.host.url=https://sonarcloud.io" -D"sonar.login=<token>" -D"sonar.exclusions=**/node_modules/**"
  ```
