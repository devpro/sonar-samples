# Simple Node.js application

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=devpro.scannersamples.angularjs.simpleapp&metric=alert_status)](https://sonarcloud.io/dashboard?id=devpro.scannersamples.angularjs.simpleapp)

## Run the application

- Install NPM dependencies: `npm install`
- Open [app/index.html file](app/index.html) in a browser

## Run the scanner

- Run the scan (replace with the correct values):

  ```dos
  sonar-scanner -D"sonar.projectKey=<projetKey>" -D"sonar.projectName=AngularJS Simple App Sample" -D"sonar.organization=<company>" -D"sonar.sources=." -D"sonar.host.url=https://sonarcloud.io" -D"sonar.login=<token>" -D"sonar.exclusions=**/node_modules/**"
  ```
