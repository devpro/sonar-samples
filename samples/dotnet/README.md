# .NET sample

A minimal ASP.NET Core 9 Web API with an xUnit test project, demonstrating how to use the **SonarScanner for .NET** (MSBuild integration).
The generic SonarScanner CLI does not analyse .NET code.

## What this demonstrates

- C# source and Roslyn analyser integration
- Test coverage import from Coverlet (OpenCover format)
- The three-step MSBuild scanner flow (`begin` → `build` → `end`)
- Solution-level analysis with multiple projects

## Prerequisites

- [.NET 9 SDK](https://dotnet.microsoft.com/download/dotnet/9.0)
- SonarQube running locally (`docker compose up -d` from the repo root)
- SonarScanner for .NET as a global tool:

```bash
dotnet tool install --global dotnet-sonarscanner
```

Verify:

```bash
dotnet sonarscanner --version
```

- Coverlet for coverage collection:

```bash
dotnet tool install --global coverlet.console
```

Or use the `coverlet.collector` NuGet package already referenced in the test project.

## Project structure

```txt
├── src/
│   └── SonarSamples.Api/
│       ├── SonarSamples.Api.csproj
│       ├── Program.cs
│       └── MathService.cs
├── tests/
│   └── SonarSamples.Api.Tests/
│       ├── SonarSamples.Api.Tests.csproj
│       └── MathServiceTests.cs
└── SonarSamples.sln
```

## Step 1 — Create the project in SonarQube

1. Open <http://localhost:9000>
2. Log in (`admin` / your password)
3. Click **Create project** → **Manually**
4. Set **Project key**: `sonar-samples-dotnet`
5. Set **Display name**: `sonar-samples / dotnet`
6. Click **Set up** → **Locally**
7. Generate a token and copy it

## Step 2 — Restore dependencies

```bash
dotnet restore
```

## Step 3 — Run the scanner (three-step flow)

The MSBuild scanner wraps your build. The sequence is always `begin` → `dotnet build` → `end`.

### Begin

```bash
dotnet sonarscanner begin \
  /k:"sonar-samples-dotnet" \
  /n:"sonar-samples / dotnet" \
  /d:sonar.host.url="http://localhost:9000" \
  /d:sonar.token="<your-token>" \
  /d:sonar.cs.opencover.reportsPaths="**/coverage.opencover.xml"
```

### Build

```bash
dotnet build --no-restore
```

### Run tests with coverage

```bash
dotnet test --no-build \
  --collect:"XPlat Code Coverage" \
  -- DataCollectionRunSettings.DataCollectors.DataCollector.Configuration.Format=opencover
```

### End

```bash
dotnet sonarscanner end /d:sonar.token="<your-token>"
```

## Step 4 — View results

Open <http://localhost:9000/dashboard?id=sonar-samples-dotnet>.

## Using a script

Convenience scripts are provided for both platforms:

```bash
# Linux / macOS
bash scan.sh <your-token>

# Windows (PowerShell)
.\scan.ps1 -Token <your-token>
```

## Key points about the MSBuild scanner

Point                             | Detail
----------------------------------|---------------------------------------------------------------------------------------------------------
**Token placement**               | Required in both `begin` and `end`: it authenticates both the analysis upload and the quality gate check
**No `sonar-project.properties`** | Configuration is passed as `/d:` parameters to `begin`
**Coverage format**               | Sonar reads OpenCover XML; Coverlet produces it via `Format=opencover`
**`--no-restore` / `--no-build`** | Recommended to keep the three steps clean and fast
**Windows vs Linux**              | The tool works on both; use `/d:` syntax on all platforms

## Adapting for your project

Add the `coverlet.collector` package to your test project if not present:

```bash
dotnet add tests/YourTests/YourTests.csproj package coverlet.collector
```

Then use the same three-step flow. For multi-solution repos, run `begin` once at the repo root and include all solution files in the build step.
