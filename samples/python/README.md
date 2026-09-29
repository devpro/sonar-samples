# Python sample

Scan a Python 3.12 sample with Flask and pytest with the SonarScanner CLI.

## How to run

```bash
task build:python   # create the virtual environment, install, run the tests with coverage
task scan:python    # run the scanner CLI in Docker
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

Coverage is configured in `setup.cfg`:

```ini
[coverage:run]
source = src
omit = tests/*
relative_files = True
```

## Gotchas

- `relative_files = True` is required.
  With absolute paths in `coverage.xml`, SonarQube drops every coverage measure and the scan still succeeds.
- `.venv/**` is excluded, otherwise every installed dependency would be analysed.
- On Debian and Ubuntu, `pip install` refuses to install outside a virtual environment (PEP 668), which is why the build creates one.
- Pylint reports can be imported with `sonar.python.pylint.reportPaths`, while Bandit reports must first be converted to the generic issue format.
