# Quickstart

This page runs the Node.js sample from start to finish.
Docker, Task and Node.js 22 must be installed.

## Start SonarQube

SonarQube needs a higher kernel limit, which has to be set again after each reboot:

```bash
sudo sysctl -w vm.max_map_count=524288
```

The following command starts SonarQube and stores a new token in `SONAR_TOKEN`:

```bash
export SONAR_TOKEN=$(task bootstrap)
```

## Scan the sample

Build and test the sample, then scan it:

```bash
task build:nodejs
task scan:nodejs
```

The results are on [http://localhost:9000](http://localhost:9000/dashboard?id=sonar-samples-nodejs), with the login `admin` and the password `SonarSamples2026!`.

## Check the analysis

This command checks that the analysis contains coverage, tests and the expected rules:

```bash
task assert
```

## Stop

`task down` stops SonarQube and keeps its data, while `task reset` also deletes the data.
`task status` shows whether the containers are running, and `task logs` shows their output.

## Other samples

Every other sample follows the same steps with `task build:<sample>` and `task scan:<sample>`.
`task --list-all` lists all the available commands.
