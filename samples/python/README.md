# Python sample

A minimal Python 3.12 application with a pytest test suite, demonstrating Python analysis with coverage reporting in SonarQube.

## What this demonstrates

- Python source analysis (bugs, code smells, security hotspots)
- Test coverage import from `coverage.py` in XML format
- Pylint / Bandit integration notes
- Exclusion of virtual environments and test files from source analysis

## Prerequisites

- [Python 3.12+](https://www.python.org/)
- SonarQube running locally (`docker compose up -d` from the repo root)
- SonarScanner CLI:

```bash
# macOS (Homebrew)
brew install sonar-scanner

# Linux — download from https://docs.sonarsource.com/sonarqube-server/latest/analyzing-source-code/scanners/sonarscanner/
# Or run via Docker (no install needed — see below)
```

## Setup

```bash
python -m venv .venv
source .venv/bin/activate      # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

> `conftest.py` at the project root adds the package to `sys.path` so pytest resolves `from src.app import ...` without installing the package. It is already included — no action needed.

## Run the application

```bash
python src/app.py
# Listening on http://localhost:5000
```

## Run tests with coverage

```bash
pytest tests/ --cov=src --cov-report=xml:coverage.xml --cov-report=term
```

Coverage is written to `coverage.xml` in Cobertura format, which SonarQube imports natively.

## Create the project in SonarQube

1. Open <http://localhost:9000>
2. Log in (`admin` / your password)
3. Click **Create project** → **Manually**
4. Set **Project key**: `sonar-samples-python`
5. Set **Display name**: `sonar-samples / python`
6. Click **Set up** → **Locally**
7. Generate a token and copy it

## Run the scanner

```bash
sonar-scanner -Dsonar.token=<your-token>
```

### Running the scanner via Docker (no install)

If you do not want to install the scanner locally:

```bash
docker run --rm \
  --network host \
  -e SONAR_TOKEN=<your-token> \
  -v "$(pwd)":/usr/src \
  sonarsource/sonar-scanner-cli:latest
```

The `--network host` flag lets the container reach `localhost:9000`.

## View results

Open <http://localhost:9000/dashboard?id=sonar-samples-python>.

## sonar-project.properties

```properties
sonar.projectKey=sonar-samples-python
sonar.projectName=sonar-samples / python
sonar.sources=src
sonar.tests=tests
sonar.python.coverage.reportPaths=coverage.xml
sonar.exclusions=.venv/**,**/__pycache__/**
sonar.host.url=http://localhost:9000
```

The `sonar.token` is not stored here — pass it on the command line or via `SONAR_TOKEN`.

## Note on external linters

SonarQube for Python includes its own rule engine and does not require Pylint or Bandit to be run separately. However, you can import their reports for consolidated results:

```properties
# Optional: import Pylint results
sonar.python.pylint.reportPaths=pylint-report.txt

# Optional: import Bandit results (as a generic issue format)
# See: https://docs.sonarsource.com/sonarqube-server/latest/analyzing-source-code/importing-external-issues/
```
