@echo off
setlocal

set "QA_PROFILE=%TEMP%\mascotify-qa-browser-profile"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference = 'SilentlyContinue';" ^
  "$own = $PID;" ^
  "$parent = (Get-CimInstance Win32_Process -Filter \"ProcessId=$own\").ParentProcessId;" ^
  "$patterns = @('INICIAR_MASCOTIFY.bat','mascotify-functional-review-web','mascotify_functional_builds','Mascotify Demo');" ^
  "$qaProfile = [Environment]::ExpandEnvironmentVariables('%QA_PROFILE%');" ^
  "$candidates = Get-CimInstance Win32_Process | Where-Object { $cmd = $_.CommandLine; $_.ProcessId -ne $own -and $_.ProcessId -ne $parent -and $cmd -and ( (($patterns | Where-Object { $_ -and $_.Length -gt 0 -and $_ -ne 'Mascotify Demo' -and $cmd -like \"*$_*\" }).Count -gt 0) -or ($cmd -like \"*$qaProfile*\")) };" ^
  "$windowMatches = Get-Process | Where-Object { $_.Id -ne $own -and $_.Id -ne $parent -and $_.MainWindowTitle -like '*Mascotify Demo*' } | ForEach-Object { $_.Id };" ^
  "$ids = @($candidates.ProcessId + $windowMatches) | Where-Object { $_ } | Sort-Object -Unique;" ^
  "if (-not $ids -or $ids.Count -eq 0) { Write-Host 'No Mascotify review sessions found.'; exit 0 };" ^
  "foreach ($id in $ids) { try { $p = Get-Process -Id $id -ErrorAction Stop; Stop-Process -Id $id -Force -ErrorAction Stop; Write-Host ('Closed Mascotify review process {0} {1}' -f $id, $p.ProcessName) } catch { Write-Host ('Could not close Mascotify review process {0}: {1}' -f $id, $_.Exception.Message) } }"

endlocal
