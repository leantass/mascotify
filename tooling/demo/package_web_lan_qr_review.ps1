$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $scriptDir '..\..')
$flutter = 'C:\src\flutter\bin\flutter.bat'
$port = 53177
$packageName = 'mascotify-lan-qr-review-web'
$artifactRoot = [System.IO.Path]::GetFullPath((Join-Path $repoRoot '..\mascotify_functional_builds'))
$packageDir = Join-Path $artifactRoot $packageName
$zipPath = Join-Path $artifactRoot 'mascotify-web-lan-qr-review-launcher.zip'

function Write-Step($message) {
  Write-Host "[package_web_lan_qr_review] $message"
}

function Write-TextFile($path, $content) {
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
}

function Get-LanIpAddress {
  $candidate = Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object {
      $_.IPAddress -notlike '127.*' -and
      $_.PrefixOrigin -ne 'WellKnown' -and
      $_.InterfaceOperationalStatus -eq 'Up'
    } |
    Sort-Object InterfaceMetric |
    Select-Object -First 1

  if ($null -eq $candidate) {
    throw 'No se pudo detectar una IP LAN activa. Conectarse a Wi-Fi/Ethernet e intentar de nuevo.'
  }

  return $candidate.IPAddress
}

if (-not (Test-Path $flutter)) {
  throw "No existe Flutter en $flutter"
}

$lanIp = Get-LanIpAddress
$publicQrBaseUrl = "http://$lanIp`:$port"
$qrApiBaseUrl = "http://$lanIp`:4000/api/v1"

Push-Location $repoRoot
try {
  Write-Step "Generando build web con QR_PUBLIC_BASE_URL=$publicQrBaseUrl ..."
  & $flutter build web --release `
    --dart-define="QR_PUBLIC_BASE_URL=$publicQrBaseUrl" `
    --dart-define="MASCOTIFY_QR_API_BASE_URL=$qrApiBaseUrl"
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }

  $buildWeb = Join-Path $repoRoot 'build\web'
  if (Test-Path $packageDir) {
    Remove-Item -LiteralPath $packageDir -Recurse -Force
  }
  New-Item -ItemType Directory -Force -Path $packageDir | Out-Null
  Copy-Item -Path (Join-Path $buildWeb '*') -Destination $packageDir -Recurse -Force

  $launcher = @"
@echo off
setlocal
title Mascotify - QR LAN Review

cd /d "%~dp0"

echo Mascotify - QR LAN Review
echo.
echo URL para esta PC y telefonos en la misma Wi-Fi:
echo $publicQrBaseUrl
echo.
echo No cierres esta ventana mientras uses la demo.
echo Si Windows Firewall pide permiso, aceptar solo en red privada/confiable.
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0mascotify-lan-server.ps1"

echo.
echo La demo se cerro. Ya podes cerrar esta ventana.
pause >nul
"@

  $server = @"
`$ErrorActionPreference = 'Stop'

`$root = Split-Path -Parent `$MyInvocation.MyCommand.Path
`$port = $port
`$url = "$publicQrBaseUrl/"

Add-Type -AssemblyName System.Web

function Get-MimeType([string] `$path) {
  switch ([System.IO.Path]::GetExtension(`$path).ToLowerInvariant()) {
    '.html' { 'text/html; charset=utf-8'; break }
    '.js' { 'application/javascript; charset=utf-8'; break }
    '.mjs' { 'application/javascript; charset=utf-8'; break }
    '.css' { 'text/css; charset=utf-8'; break }
    '.json' { 'application/json; charset=utf-8'; break }
    '.png' { 'image/png'; break }
    '.jpg' { 'image/jpeg'; break }
    '.jpeg' { 'image/jpeg'; break }
    '.svg' { 'image/svg+xml'; break }
    '.ico' { 'image/x-icon'; break }
    '.mp4' { 'video/mp4'; break }
    '.webm' { 'video/webm'; break }
    '.wasm' { 'application/wasm'; break }
    '.map' { 'application/json; charset=utf-8'; break }
    '.ttf' { 'font/ttf'; break }
    '.otf' { 'font/otf'; break }
    '.woff' { 'font/woff'; break }
    '.woff2' { 'font/woff2'; break }
    default { 'application/octet-stream' }
  }
}

function Send-Response(`$stream, [int] `$status, [string] `$statusText, [string] `$contentType, [byte[]] `$body) {
  `$header = "HTTP/1.1 `$status `$statusText``r``nContent-Type: `$contentType``r``nContent-Length: `$(`$body.Length)``r``nCache-Control: no-cache``r``nConnection: close``r``n``r``n"
  `$headerBytes = [System.Text.Encoding]::ASCII.GetBytes(`$header)
  `$stream.Write(`$headerBytes, 0, `$headerBytes.Length)
  if (`$body.Length -gt 0) {
    `$stream.Write(`$body, 0, `$body.Length)
  }
}

function Resolve-RequestPath([string] `$target) {
  `$pathOnly = (`$target -split '\?')[0]
  if ([string]::IsNullOrWhiteSpace(`$pathOnly) -or `$pathOnly -eq '/') {
    `$pathOnly = '/index.html'
  }

  `$decoded = [System.Web.HttpUtility]::UrlDecode(`$pathOnly).Replace('/', [System.IO.Path]::DirectorySeparatorChar)
  `$decoded = `$decoded.TrimStart([System.IO.Path]::DirectorySeparatorChar)
  `$candidate = [System.IO.Path]::GetFullPath((Join-Path `$root `$decoded))
  `$rootFull = [System.IO.Path]::GetFullPath(`$root)

  if (-not `$candidate.StartsWith(`$rootFull, [System.StringComparison]::OrdinalIgnoreCase)) {
    return Join-Path `$root 'index.html'
  }

  if (Test-Path -LiteralPath `$candidate -PathType Leaf) {
    return `$candidate
  }

  return Join-Path `$root 'index.html'
}

`$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, `$port)
`$listener.Start()

Write-Host ''
Write-Host "Mascotify LAN esta corriendo en `$url"
Write-Host 'Abrir esa URL desde otro telefono conectado a la misma Wi-Fi.'
Write-Host 'No cierres esta ventana mientras uses la demo.'
Write-Host ''

Start-Process `$url

try {
  while (`$true) {
    `$client = `$listener.AcceptTcpClient()
    try {
      `$stream = `$client.GetStream()
      `$buffer = New-Object byte[] 8192
      `$read = `$stream.Read(`$buffer, 0, `$buffer.Length)
      if (`$read -le 0) { continue }
      `$request = [System.Text.Encoding]::ASCII.GetString(`$buffer, 0, `$read)
      `$requestLine = (`$request -split "``r?``n")[0]
      `$parts = `$requestLine -split ' '
      `$target = if (`$parts.Length -ge 2) { `$parts[1] } else { '/' }
      `$filePath = Resolve-RequestPath `$target
      `$bodyBytes = [System.IO.File]::ReadAllBytes(`$filePath)
      Send-Response `$stream 200 'OK' (Get-MimeType `$filePath) `$bodyBytes
    } finally {
      `$client.Close()
    }
  }
} finally {
  `$listener.Stop()
}
"@

  $instructions = @"
Mascotify - QR LAN Review

Esta variante es para probar el QR desde otro telefono en la misma Wi-Fi.

1. Descomprimir el ZIP completo.
2. Ejecutar INICIAR_MASCOTIFY_LAN.bat.
3. Si Windows Firewall pregunta, permitir solo en red privada/confiable.
4. Abrir desde el telefono: $publicQrBaseUrl
5. El QR de cada mascota codifica una URL http://IP_DE_LA_PC:$port/q/:qrId.
6. Esto no reemplaza un dominio publico. Fuera de esta Wi-Fi no va a funcionar.
7. La alerta entre dispositivos requiere backend publico accesible en $qrApiBaseUrl o una URL real configurada.
"@

  Write-TextFile (Join-Path $packageDir 'INICIAR_MASCOTIFY_LAN.bat') $launcher
  Write-TextFile (Join-Path $packageDir 'mascotify-lan-server.ps1') $server
  Write-TextFile (Join-Path $packageDir 'INSTRUCCIONES-QR-LAN.txt') $instructions

  if (Test-Path $zipPath) {
    Remove-Item -LiteralPath $zipPath -Force
  }
  Compress-Archive -Path (Join-Path $packageDir '*') -DestinationPath $zipPath -Force
  Write-Step "Paquete LAN generado: $zipPath"
} finally {
  Pop-Location
}
