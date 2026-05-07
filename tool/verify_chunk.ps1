$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

Push-Location $repoRoot
try {
  flutter analyze --fatal-infos
  flutter test
  & (Join-Path $PSScriptRoot "run_web_smoke.ps1")
  flutter build appbundle --release
}
finally {
  Pop-Location
}
