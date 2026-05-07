param(
  [int]$Port = 7357,
  [switch]$Headed,
  [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$smokeScript = Join-Path $repoRoot "tool\web_smoke_test.py"
$baseUrl = "http://127.0.0.1:$Port"

Push-Location $repoRoot
try {
  if (-not $SkipBuild) {
    flutter build web --target tool/web_smoke_main.dart
  }

  $logDirectory = Join-Path $repoRoot "build\web-smoke"
  New-Item -ItemType Directory -Force -Path $logDirectory | Out-Null
  $serverOut = Join-Path $logDirectory "server.out.log"
  $serverErr = Join-Path $logDirectory "server.err.log"
  $buildWebDirectory = Join-Path $repoRoot "build\web"

  try {
    Get-CimInstance Win32_Process -Filter "name = 'python.exe'" |
      Where-Object { $_.CommandLine -like "*http.server $Port*" } |
      ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
  }
  catch {
    Write-Host "Skipping stale web smoke server cleanup: $($_.Exception.Message)"
  }

  $serverProcess = Start-Process `
    -FilePath "python" `
    -ArgumentList @(
      "-m",
      "http.server",
      "$Port",
      "--bind",
      "127.0.0.1",
      "--directory",
      $buildWebDirectory
    ) `
    -PassThru `
    -WindowStyle Hidden `
    -WorkingDirectory $repoRoot `
    -RedirectStandardOutput $serverOut `
    -RedirectStandardError $serverErr

  $deadline = (Get-Date).AddSeconds(60)
  while ((Get-Date) -lt $deadline) {
    if ($serverProcess.HasExited) {
      throw "Web smoke server exited early. See $serverErr"
    }

    $client = [System.Net.Sockets.TcpClient]::new()
    try {
      $connected = $client.ConnectAsync("127.0.0.1", $Port).Wait(250)
      if ($connected) {
        break
      }
      Start-Sleep -Milliseconds 250
    }
    catch {
      Start-Sleep -Milliseconds 250
    }
    finally {
      $client.Dispose()
    }
  }

  if ((Get-Date) -ge $deadline) {
    throw "Timed out waiting for web smoke server on $baseUrl"
  }

  $smokeArgs = @($smokeScript, "--base-url", $baseUrl)
  if ($Headed) {
    $smokeArgs += "--headed"
  }

  & python @smokeArgs
  if ($LASTEXITCODE -ne 0) {
    throw "Browser smoke failed with exit code $LASTEXITCODE"
  }
}
finally {
  if ($serverProcess -and -not $serverProcess.HasExited) {
    Stop-Process -Id $serverProcess.Id -Force -ErrorAction SilentlyContinue
    $serverProcess.WaitForExit(5000) | Out-Null
  }
  try {
    Get-CimInstance Win32_Process -Filter "name = 'python.exe'" |
      Where-Object { $_.CommandLine -like "*http.server $Port*" } |
      ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
  }
  catch {
    Write-Host "Skipping stale web smoke server cleanup: $($_.Exception.Message)"
  }
  Pop-Location
}
