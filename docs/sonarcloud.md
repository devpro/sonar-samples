# SonarCloud

On GitHub, `.github/workflows/ci.yml` analyses every sample on [SonarCloud](https://sonarcloud.io/organizations/devpro-github/projects), as an example.
Findings are expected: the pipeline neither waits for the quality gate nor asserts the results.

## Settings

Where      | Kind                        | Name                     | Value
-----------|-----------------------------|--------------------------|------------------------------------------------
GitHub     | Actions repository secret   | `SONAR_TOKEN`            | a token that can analyse the projects
GitHub     | Actions repository variable | `SONAR_ORG`              | `devpro-github`
SonarCloud | Projects                    | `sonar-samples-<sample>` | one for each sample, with `main` as main branch

`SONAR_HOST_URL` is not set on GitHub: its presence tells the workflow that the runner brings a SonarQube, as IstarCI does.

## Results

The numbers differ from those of [results](results.md), which are measured locally, since the analysers are not the same.
For example, SonarCloud raises `go:S4790` on the MD5 hash of the Go sample, where the local SonarQube raises nothing.

It also analyses files next to the ones of `sonar.sources`, such as settings and scripts, which adds lines to the .NET sample.

## Gotchas

- Each project is created before its first analysis, otherwise the scan can create it with an empty `master` as main branch.
- Automatic analysis is turned off in each project, since it conflicts with the one of the pipeline.
- A project bound to the repository can add a SonarCloud check to pull requests, red when its quality gate fails.
  It only blocks when the branch rules require it, so it is left out of the required checks.
