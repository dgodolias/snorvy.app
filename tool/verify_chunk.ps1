$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

function Invoke-Checked {
  param(
    [Parameter(Mandatory = $true)]
    [scriptblock]$Command,
    [Parameter(Mandatory = $true)]
    [string]$Name
  )

  & $Command
  if ($LASTEXITCODE -ne 0) {
    throw "$Name failed with exit code $LASTEXITCODE"
  }
}

Push-Location $repoRoot
try {
  Invoke-Checked { flutter analyze --fatal-infos } "flutter analyze"
  Invoke-Checked { flutter test } "flutter test"
  Invoke-Checked { & (Join-Path $PSScriptRoot "run_web_smoke.ps1") } "browser smoke"
  Invoke-Checked { flutter build appbundle --release } "flutter build appbundle"
}
finally {
  Pop-Location
}
