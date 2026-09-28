# Python sample

Python 3.12 with Flask and pytest, scanned by the SonarScanner CLI.

- Project key: `sonar-samples-python`
- Coverage: `coverage.py` XML, `coverage.xml`
- Tests: JUnit XML, `test-results.xml`
- Rules raised: [docs/rules.md](../../docs/rules.md)

```bash
task build:python   # venv, pip install, pytest with coverage
task scan:python    # scanner CLI in Docker
```

Without Task, from this directory:

```bash
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
pytest tests/ --cov=src --cov-report=xml:coverage.xml --junitxml=test-results.xml
sonar-scanner -Dsonar.token="$SONAR_TOKEN"
```

## Settings

```ini
sonar.projectKey=sonar-samples-python
sonar.projectName=sonar-samples / python
sonar.sources=src
sonar.tests=tests
sonar.python.coverage.reportPaths=coverage.xml
sonar.exclusions=.venv/**,**/__pycache__/**
sonar.host.url=http://localhost:9000
sonar.python.xunit.reportPath=test-results.xml
```

`setup.cfg`:

```ini
[coverage:run]
source = src
omit = tests/*
relative_files = True
```

## Gotchas

- `relative_files = True` is required: with absolute paths in `coverage.xml`, SonarQube drops every coverage measure and the scan still succeeds.
- `.venv/**` is excluded, otherwise every installed dependency is analysed.
- A bare `pip install` fails on Debian and Ubuntu (PEP 668), hence the virtualenv.
- Pylint reports import with `sonar.python.pylint.reportPaths`, Bandit needs the generic issue format.
