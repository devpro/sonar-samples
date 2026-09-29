# Contributing

## Checking a change

Run the whole pipeline, which builds, scans and checks every sample except angular:

```bash
task ci
```

It fails when a sample loses its coverage, its test count, its issues, or one of the rules listed in [docs/results.md](docs/results.md).
The angular sample runs apart, with `task build:angular`, `task scan:angular` and `task assert:angular`.

## Changing the deliberate issues of a sample

Each sample has a `showcase` file with code written to trigger SonarQube rules.
After changing it:

1. Build and scan the sample:

   ```bash
   export SONAR_TOKEN=$(task bootstrap)
   task build:<sample>
   task scan:<sample>
   ```

2. List the rules that really fired, since a rule existing for a language does not mean it fires.
   Security Hotspots are only in the second call:

   ```bash
   curl -s -u "$SONAR_TOKEN:" "http://localhost:9000/api/issues/search?componentKeys=sonar-samples-<sample>&ps=500&resolved=false"
   curl -s -u "$SONAR_TOKEN:" "http://localhost:9000/api/hotspots/search?projectKey=sonar-samples-<sample>&ps=500"
   ```

3. Update the sample's table in [docs/results.md](docs/results.md) with what fired.

4. Update the sample's line under `assert:` in `Taskfile.yml`.
   It reads `assert_analysis.sh <project key> <minimum coverage> <minimum issues> <rules that must fire>`, with minimums just below the measured values.

A rule key goes in a comment on the line that triggers it.
A comment containing the word `TODO` raises `S1135` on its own, so it only goes where that is intended.

## Adding a sample

1. Create `samples/<sample>/` with:
   - a short `README.md`, like the other samples
   - a `sonar-project.properties` pointing at `http://localhost:9000`, with no token
   - tests that write a coverage report and a test execution report
   - a `showcase` file holding the deliberate issues
2. In `Taskfile.yml`, add `build:<sample>` and `scan:<sample>`, and add the sample to `build`, `scan` and `assert`.
3. In `.github/workflows/ci.yml`, add a build job.
4. Add the sample to `README.md` and to [docs/results.md](docs/results.md).
5. Run `task ci`.

## Rules

- No token is ever written to a file.
- Shell scripts are named in `snake_case`, pass `shellcheck`, and are committed executable with `git update-index --chmod=+x <script>`.
