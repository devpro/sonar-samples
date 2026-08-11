# Python sample

A minimal Python 3.12 Flask app with a pytest suite, analysed with the SonarScanner CLI.

- Project key: `sonar-samples-python`
- Coverage: `coverage.py` XML (Cobertura), written to `coverage.xml`
- Issues raised: [docs/rules.md#python](../../docs/rules.md#python)

## Prerequisites

Python 3.12+ with `venv`, and a running SonarQube.
See [docs/installation.md](../../docs/installation.md).

## Run it

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

pytest tests/ --cov=src --cov-report=xml:coverage.xml --cov-report=term
python src/app.py   # optional, serves http://localhost:5000
```

A virtualenv is not optional on Debian/Ubuntu: [PEP 668](https://peps.python.org/pep-0668/) marks the system interpreter as externally managed and a bare `pip install` fails.

`conftest.py` at the project root puts the package on `sys.path`, so `from src.app import ...` resolves without installing the package.

## Scan it

```bash
export SONAR_TOKEN=$(task bootstrap)   # see docs/tokens.md
task scan:python
```

Or with a locally installed scanner, from this directory:

```bash
sonar-scanner -Dsonar.token="$SONAR_TOKEN"
```

Results: <http://localhost:9000/dashboard?id=sonar-samples-python>

## sonar-project.properties

```ini
sonar.projectKey=sonar-samples-python
sonar.projectName=sonar-samples / python
sonar.sources=src
sonar.tests=tests
sonar.python.coverage.reportPaths=coverage.xml
sonar.exclusions=.venv/**,**/__pycache__/**
sonar.host.url=http://localhost:9000
```

Excluding `.venv/**` matters: without it the scanner walks every installed dependency, which is slow and floods the dashboard with third-party issues.

## The coverage trap

`setup.cfg` contains:

```ini
[coverage:run]
source = src
omit = tests/*
relative_files = True
```

`relative_files = True` is essential.
Without it `coverage.py` writes **absolute** paths into `coverage.xml`, SonarQube cannot match them to the files it analysed, and it drops every coverage measure while the scanner still exits `0`.
The symptom is a dashboard reading 0% next to a coverage report that looks perfectly fine.

`task build:python` guards against this by grepping the generated XML for `<source>src</source>`.

## External linters

SonarQube has its own Python rule engine and needs neither Pylint nor Bandit.
Their reports can still be imported for consolidated results:

```ini
sonar.python.pylint.reportPaths=pylint-report.txt
```

Bandit needs the [generic issue format](https://docs.sonarsource.com/sonarqube-server/analyzing-source-code/importing-external-issues/).
