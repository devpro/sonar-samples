# IstarCI

Optional: IstarCI is a private project, and nothing in this repository needs it.
Where it is installed, it runs `.github/workflows/ci.yml` on the machine for each commit, and analyses every sample in a SonarQube of its own, on `localhost:9010`.
It needs neither `task bootstrap` nor the SonarQube of `compose.yaml`.

## Settings

`.istarci.yml` names the quality profile and the project of each sample, and sets `SONAR_ASSERT_ISSUES`, so the issues and the rules are asserted.
A new sample is added to `runner.sonarqube.projects`, otherwise its project gets the default profile.
`gate` stays off, since the samples raise issues on purpose.

## Reading a run

```bash
istarci wait                      # wait for the run of HEAD, with the log of each failed job
istarci status
istarci logs --job dotnet
istarci run --failed              # only the failed jobs again
```

## Reading what SonarQube reported

```bash
istarci quality                   # verdict, measures and new findings of every sample
istarci quality --all             # every finding, with its rule and line
istarci quality --commit <commit> # what the run of a commit reported
istarci quality --all --json
istarci sonarqube report sonar-samples-dotnet --all   # gate, profiles, issues and hotspots of one project
istarci sonarqube open sonar-samples-dotnet           # the dashboard, signed in
```

The samples hold almost no new code, so most findings only show with `--all`.
`istarci quality` and `istarci sonarqube report` exit 1 when a quality gate failed.

## Web interface

`istarci ui` opens it.

Page       | Quality tab
-----------|----------------------------------------------------------------
Repository | the latest analysis of each project, and the commit it is of
Run        | what the analyses said when the run ended, kept after a later run

"Open in SonarQube" opens the dashboard of a project, signed in.

## Gotchas

- The job token cannot read Security Hotspots, which `istarci sonarqube report` lists.
- The results are those of a local run: same SonarQube, same "Sonar way comprehensive" profile for every language, and the Go version set in `Taskfile.yml`.
