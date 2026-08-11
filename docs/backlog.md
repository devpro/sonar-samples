# Backlog

Known gaps and planned work, in rough priority order.
Items are removed when done, not marked as done.

## Unverified

These are believed to work but have never been observed end to end.

- **`task build:angular` has never been run.**
  It is the only sample never executed during the rework, because it needs a global Angular CLI and a full `ng new` scaffold.
  The builder detection in `setup.sh` branches on Karma versus Vitest and the Vitest path is entirely untested.
  Until it runs green once, the angular sample should be treated as aspirational.
- **`shellcheck` has never been run against the scripts.**
  The CI lint job invokes it, but it is not installed on the development machine, so only `bash -n` syntax checks have been done.
  Expect findings on first run, particularly around unquoted expansions.
- **The CI workflow has never executed.**
  It was written but not yet triggered on GitHub, so job names, action versions, and the `task bootstrap` token masking are unproven.

## Correctness

- **`scan.ps1` is not covered by CI and is untested.**
  The repository targets Linux and bash, so either drop the PowerShell script or state clearly that it is unmaintained.
- **`docs/rules.md` numbers are tied to one SonarQube version.**
  They were measured against the rolling `community` tag, which moves.
  Consider pinning `compose.yaml` to a full version so the documented counts stay reproducible, at the cost of manual upgrades.
- **`assert_analysis.sh` depends on `python3`.**
  That is an undeclared prerequisite for anyone using only the Java, Go, or .NET sample.
  Either document it in `docs/installation.md` or reimplement the JSON parsing without Python.

## Improvements

- **`sonar_bootstrap.sh` never revokes the tokens it mints.**
  Repeated local runs accumulate tokens under My Account > Security.
  Reuse a named token, or revoke the previous one before generating a new one.
- **The Node.js sample under-reports coverage.**
  Jest only instruments files a test imports, so `src/app.js` counts as uncovered.
  Adding `collectCoverageFrom` would make the number reflect the whole source tree.
- **Angular has no entry in `docs/rules.md` and no assertion.**
  This is deliberate, since the scaffolded app changes between CLI releases, but it means nothing detects the angular sample silently producing an empty dashboard.
  A weaker assertion, such as coverage above zero and at least one issue, would still catch total failure.
- **The `go` sample raises `S1192` from `cmd/server/main.go` rather than from the showcase file.**
  The deliberate issues would be easier to follow if every rule fired from `internal/showcase/`.

## Possible new samples

- Rust, using the community plugin, which would extend the point that rule coverage differs sharply by language
- A monorepo example showing several projects analysed under one project key
- A pull request decoration example, which requires a real server rather than a local instance
