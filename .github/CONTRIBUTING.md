# Contributing

Contributions are welcome — new language samples, corrections, and documentation improvements.

## Adding a new sample

1. Create `samples/<language>/` following the existing pattern
2. Include:
   - `README.md` — prerequisites, step-by-step instructions, key properties explained
   - `sonar-project.properties` — targeting `http://localhost:9000`, no token
   - Source files (or a `setup.sh` script for generated projects)
   - A test file that produces a coverage report SonarQube can import
3. Add an entry to the table in the root `README.md`

## Principles

- **Self-contained**: each sample must work with only Docker and the relevant language runtime
- **No secrets committed**: `sonar.token` is never in any file — only in CLI flags or environment variables
- **Modern stacks only**: use current LTS/stable versions; deprecated languages or frameworks are not added
- **Intentional issues**: include at least one code smell or bug that Sonar will detect, so users can see the dashboard populate meaningfully
- **Explain the why**: README comments should explain *why* a property is set, not just *what* it is

## Running locally before submitting

Test your sample end-to-end:

```bash
# Start SonarQube
task up
# or: docker compose up -d

# Run through your sample's README steps manually
# Verify the project appears in http://localhost:9000 with issues detected
```

## Pull requests

- One sample or fix per PR
- Keep PRs small and focused
- Reference the relevant SonarQube documentation if the configuration is non-obvious
