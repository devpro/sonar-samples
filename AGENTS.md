# sonar-samples: agent context

Code samples in several languages and a way to analyse them with a SonarQube running in Docker, nothing more.

```txt
compose.yaml                  SonarQube Community and PostgreSQL
Taskfile.yml                  every command: bootstrap, build:<sample>, scan:<sample>, assert, ci
scripts/sonar_bootstrap.sh    starts SonarQube, prints a token on stdout
scripts/assert_analysis.sh    checks an analysis landed with coverage, issues and the expected rules
samples/<name>/               one self-contained sample, with a showcase file of deliberate issues
docs/                         short files, one topic each
```

Linux or WSL2, Docker and `bash`.

## Working rules

- **Every command runs in the foreground, and the agent waits for it.**
  No background commands, no subagents, no forks, no parallel tasks, even for a long `task ci`.
- Headers stay: short documentation still has sections.
- Linters for YAML and Markdown are never run by an agent.
- Commit only when asked, and never push.
  Shell scripts are `snake_case` and committed with the executable bit (`git update-index --chmod=+x`).
- Documentation is as short as possible: `README.md` runs one sample, `CONTRIBUTING.md` changes the repository, `docs/` holds one short file per topic, a sample README gives its commands and gotchas.

## Writing style

Applies to Markdown, code comments, commit messages and prose in scripts.

- **A comment says why, not what, and the why is timeless.**
- **One thought per line.**
  Every sentence starts on its own line, and there is no maximum line length.
- **No em dash, no en dash.**
  A colon, a comma, or a full stop.
- **No second person.**
  "The working tree", not "your working tree"; `<token>`, not `<your-token>`.
- `ini` is the fence language for `.properties` blocks.

## Verifying

A rule is never claimed to fire without seeing it in the issue list or the hotspot list, see `CONTRIBUTING.md`.
`task ci` builds, scans and asserts everything.
`docs/rules.md` and the `assert` floors in `Taskfile.yml` change together.

Without Maven on the `PATH`, the Java sample builds in a container, see `samples/java/README.md`.
