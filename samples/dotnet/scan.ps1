<#
.SYNOPSIS
    Runs the full SonarScanner for .NET analysis sequence.
.PARAMETER Token
    SonarQube token generated at http://localhost:9000 → My Account → Security
.EXAMPLE
    .\scan.ps1 -Token squ_abc123
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Token
)

$ErrorActionPreference = "Stop"

$SonarHost   = "http://localhost:9000"
$ProjectKey  = "sonar-samples-dotnet"
$ProjectName = "sonar-samples / dotnet"

Write-Host "==> SonarScanner for .NET — begin" -ForegroundColor Cyan
dotnet sonarscanner begin `
    /k:"$ProjectKey" `
    /n:"$ProjectName" `
    /d:sonar.host.url="$SonarHost" `
    /d:sonar.token="$Token" `
    /d:sonar.cs.opencover.reportsPaths="**/coverage.opencover.xml"

if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "`n==> dotnet build" -ForegroundColor Cyan
dotnet build --no-restore
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "`n==> dotnet test (with coverage)" -ForegroundColor Cyan
dotnet test --no-build `
    --collect:"XPlat Code Coverage" `
    -- DataCollectionRunSettings.DataCollectors.DataCollector.Configuration.Format=opencover
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "`n==> SonarScanner for .NET — end" -ForegroundColor Cyan
dotnet sonarscanner end /d:sonar.token="$Token"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "`nDone. View results at: $SonarHost/dashboard?id=$ProjectKey" -ForegroundColor Green
