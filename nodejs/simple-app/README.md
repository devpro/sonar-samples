# Simple Node.js application

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=devpro.scannersamples.nodejs.simpleapp&metric=alert_status)](https://sonarcloud.io/dashboard?id=devpro.scannersamples.nodejs.simpleapp)

## Run the application

- Launch the Node.js process: `node app.js`

## Run the scanner

- Run the scan (replace with the correct values):

  ```dos
  sonar-scanner -D"sonar.projectKey=<projetKey>" -D"sonar.organization=<company>" -D"sonar.sources=." -D"sonar.host.url=https://sonarcloud.io" -D"sonar.login=<token>" -D"sonar.exclusions=**/node_modules/**"
  ```
