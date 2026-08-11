# Contributing

Contributions are welcome: new language samples, corrections, documentation.

## Scope

This repo targets **Linux with Docker** (including WSL2) and is written for `bash`.

## Repository layout

```txt
├── .github/workflows/ci.yml   # builds every sample, then scans and verifies
├── compose.yaml               # SonarQube Community + PostgreSQL 16
├── Taskfile.yml               # every documented command
├── docs/                      # shared docs, referenced by sample READMEs
├── samples/<language>/        # one self-contained sample each
└── scripts/
    ├── sonar_bootstrap.sh     # boot SonarQube, print a token on stdout
    └── assert_analysis.sh     # verify an analysis actually landed
```

## The task targets

Target                | Does
----------------------|-----------------------------------------------------------
`task up` / `down`    | start / stop SonarQube (`down` keeps data)
`task reset`          | stop and wipe all volumes
`task bootstrap`      | start, set the admin password, print a fresh token
`task build:<sample>` | build and test one sample, assert a coverage report exists
`task scan:<sample>`  | analyse one sample (needs `SONAR_TOKEN`)
`task assert`         | verify every analysis landed, with coverage and rules
`task ci`             | the whole pipeline, which is what CI runs

`task build` and `task scan` run every sample except angular.

## Conventions

Shell scripts are named in `snake_case`, which is the standard for bash.
Scripts must be committed with the executable bit set (`git update-index --chmod=+x`), otherwise the task targets that invoke them fail on a fresh clone.

Markdown and code comments follow one rule: a line break only ever happens at the end of a sentence.
Sentences are never wrapped mid-way, and there is no fixed line length.
The em dash is not used anywhere, and neither is the second person.

## Documentation rules

The root `README.md` is kept as short as possible.
Anything shared between samples lives in `docs/` and is **linked, never copied**.
The same paragraph appearing in two files means it belongs in `docs/`.

Each sample README must be self-sufficient for that sample and exhaustive about what is specific to it: its properties, its coverage format, its scanner quirks.
It links out for anything generic, such as installing a scanner or getting a token.

Explain *why* a property is set, not just *what* it is.
A sample that works but does not teach has missed the point.

## Adding a new sample

1. Create `samples/<language>/` with:
   - `README.md` following the structure of the existing ones
   - `sonar-project.properties` targeting `http://localhost:9000`, with no token (Java and .NET configure the scanner differently, see those samples)
   - source files, or a `setup.sh` for scaffolded projects
   - tests that produce a coverage report SonarQube can import
   - a `showcase` file holding the deliberate issues, kept out of the ordinary sample code so that code still reads as clean
2. Add `build:<name>` and `scan:<name>` targets to `Taskfile.yml`, and wire them into `build`, `scan` and `assert`.
3. Add a job to `.github/workflows/ci.yml`.
4. Add a row to the samples table in `README.md` and a section to `docs/rules.md`.

## Verifying deliberate issues

**Never assume a rule fires because it exists.**
Run the scan and read the issue list.
Two failure modes have already bitten this repo:

- Rules that need the analyser to *prove* a condition, such as division by zero or null dereference, stay silent on simple sample code.
- Rule coverage differs by language.
  Go has no `S2068` and no `S4790`, so identical code that raises a Vulnerability in Java raises nothing in Go.

Get the rules that actually fired, including hotspots, which are a separate API:

```bash
export SONAR_TOKEN=$(task bootstrap)
curl -s -u "$SONAR_TOKEN:" \
  "http://localhost:9000/api/issues/search?componentKeys=<key>&ps=500&resolved=false"
curl -s -u "$SONAR_TOKEN:" \
  "http://localhost:9000/api/hotspots/search?projectKey=<key>&ps=500"
```

Then record the confirmed keys in three places: a comment at the trigger site, the sample's section in `docs/rules.md`, and the `task assert` entry.

Watch for accidental hits.
An explanatory comment containing the word `TODO` raises `S1135` by itself, which once inflated the counts here.
The rule fired, just not for the reason documented.

## Assertions

Every sample must have an `assert` entry with a coverage floor, an issue floor, and the list of rule keys it demonstrates:

```yaml
- >-
  ./scripts/assert_analysis.sh sonar-samples-<name> <minCoverage> <minIssues>
  <lang>:S1135,<lang>:S3776
```

Set the floors just below the measured values.
They exist so that a rule retired in a future SonarQube release fails CI loudly, instead of quietly emptying the dashboard.

## Principles

- **Self-contained**: Docker plus the language runtime, nothing else
- **No secrets**: `sonar.token` never in a file, CLI flag or `SONAR_TOKEN` only
- **Modern stacks**: current LTS/stable, no deprecated frameworks
- **Verified claims**: every rule key in the docs was observed to fire

## Before submitting

```bash
task ci   # build, scan and assert everything
```

Also run `shellcheck` on any modified script, and check that `task --list-all` still parses.

## Pull requests

One sample or fix per PR, kept small and focused.
Reference the SonarQube documentation when a configuration choice is non-obvious.
