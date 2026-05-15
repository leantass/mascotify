$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $scriptDir '..\..')
$flutter = 'C:\src\flutter\bin\flutter.bat'
$packageName = 'mascotify-functional-review-web'
$artifactRoot = [System.IO.Path]::GetFullPath((Join-Path $repoRoot '..\mascotify_functional_builds'))
$packageDir = Join-Path $artifactRoot $packageName
$zipPath = Join-Path $artifactRoot 'mascotify-web-functional-review-launcher.zip'

function Write-Step($message) {
  Write-Host "[package_web_functional_review] $message"
}

function Write-TextFile($path, $content) {
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
}

if (-not (Test-Path $flutter)) {
  throw "No existe Flutter en $flutter"
}

Push-Location $repoRoot
try {
  Write-Step 'Generando build web release de Mascotify...'
  & $flutter build web --release
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }

  $buildWeb = Join-Path $repoRoot 'build\web'
  $indexPath = Join-Path $buildWeb 'index.html'
  if (-not (Test-Path $indexPath)) {
    throw "No existe $indexPath"
  }

  if (Test-Path $packageDir) {
    Remove-Item -LiteralPath $packageDir -Recurse -Force
  }
  New-Item -ItemType Directory -Force -Path $packageDir | Out-Null

  Write-Step "Copiando build web a $packageDir..."
  Copy-Item -Path (Join-Path $buildWeb '*') -Destination $packageDir -Recurse -Force

  $launcher = @'
@echo off
setlocal
title Mascotify - Demo funcional

cd /d "%~dp0"

echo Mascotify - Demo funcional
echo.
echo Se va a abrir el navegador automaticamente.
echo No cierres esta ventana mientras uses la demo.
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0mascotify-local-server.ps1"

echo.
echo La demo se cerro. Ya podes cerrar esta ventana.
pause >nul
'@

  $server = @'
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$port = 53177
$url = "http://127.0.0.1:$port/"

Add-Type -AssemblyName System.Web

function Get-MimeType([string] $path) {
  switch ([System.IO.Path]::GetExtension($path).ToLowerInvariant()) {
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
    '.wasm' { 'application/wasm'; break }
    '.map' { 'application/json; charset=utf-8'; break }
    '.ttf' { 'font/ttf'; break }
    '.otf' { 'font/otf'; break }
    '.woff' { 'font/woff'; break }
    '.woff2' { 'font/woff2'; break }
    default { 'application/octet-stream' }
  }
}

function Send-Response($stream, [int] $status, [string] $statusText, [string] $contentType, [byte[]] $body) {
  $header = "HTTP/1.1 $status $statusText`r`nContent-Type: $contentType`r`nContent-Length: $($body.Length)`r`nCache-Control: no-cache`r`nConnection: close`r`n`r`n"
  $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
  $stream.Write($headerBytes, 0, $headerBytes.Length)
  if ($body.Length -gt 0) {
    $stream.Write($body, 0, $body.Length)
  }
}

function Resolve-RequestPath([string] $target) {
  $pathOnly = ($target -split '\?')[0]
  if ([string]::IsNullOrWhiteSpace($pathOnly) -or $pathOnly -eq '/') {
    $pathOnly = '/index.html'
  }

  $decoded = [System.Web.HttpUtility]::UrlDecode($pathOnly).Replace('/', [System.IO.Path]::DirectorySeparatorChar)
  $decoded = $decoded.TrimStart([System.IO.Path]::DirectorySeparatorChar)
  $candidate = [System.IO.Path]::GetFullPath((Join-Path $root $decoded))
  $rootFull = [System.IO.Path]::GetFullPath($root)

  if (-not $candidate.StartsWith($rootFull, [System.StringComparison]::OrdinalIgnoreCase)) {
    return Join-Path $root 'index.html'
  }

  if (Test-Path -LiteralPath $candidate -PathType Leaf) {
    return $candidate
  }

  return Join-Path $root 'index.html'
}

$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Parse('127.0.0.1'), $port)

try {
  $listener.Start()
} catch {
  Write-Host "No se pudo iniciar Mascotify en $url"
  Write-Host "Es posible que el puerto $port ya este en uso. Cerrar otras demos abiertas e intentar de nuevo."
  throw
}

Write-Host ''
Write-Host "Mascotify esta corriendo en $url"
Write-Host 'No cierres esta ventana mientras uses la demo.'
Write-Host 'Para cerrar la demo, cerra esta ventana.'
Write-Host ''

if ($env:MASCOTIFY_DEMO_NO_BROWSER -ne '1') {
  Start-Process $url
}

try {
  while ($true) {
    $client = $listener.AcceptTcpClient()
    try {
      $stream = $client.GetStream()
      $buffer = New-Object byte[] 8192
      $read = $stream.Read($buffer, 0, $buffer.Length)
      if ($read -le 0) {
        continue
      }

      $request = [System.Text.Encoding]::ASCII.GetString($buffer, 0, $read)
      $requestLine = ($request -split "`r?`n")[0]
      $parts = $requestLine -split ' '
      $target = if ($parts.Length -ge 2) { $parts[1] } else { '/' }
      $filePath = Resolve-RequestPath $target

      if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
        $body = [System.Text.Encoding]::UTF8.GetBytes('Mascotify demo: archivo no encontrado.')
        Send-Response $stream 404 'Not Found' 'text/plain; charset=utf-8' $body
        continue
      }

      $bodyBytes = [System.IO.File]::ReadAllBytes($filePath)
      Send-Response $stream 200 'OK' (Get-MimeType $filePath) $bodyBytes
    } catch {
      try {
        $body = [System.Text.Encoding]::UTF8.GetBytes('Mascotify demo: error interno del servidor local.')
        Send-Response $stream 500 'Internal Server Error' 'text/plain; charset=utf-8' $body
      } catch {
      }
    } finally {
      $client.Close()
    }
  }
} finally {
  $listener.Stop()
}
'@

  $instructions = @'
Mascotify - Demo web para revision funcional

1. Descomprimir el ZIP completo.
2. Entrar a la carpeta descomprimida.
3. Hacer doble click en INICIAR_MASCOTIFY.bat.
4. Se abrira el navegador automaticamente.
5. No mover archivos sueltos fuera de la carpeta.
6. No cerrar la ventana negra mientras uses la demo.
7. Algunas funciones usan datos demo/locales hasta que el backend publico este desplegado.
8. Si Windows SmartScreen avisa algo, elegir "Mas informacion" y "Ejecutar de todos modos" solo si el ZIP vino del equipo interno.
9. No abrir index.html directo salvo que se indique expresamente, porque puede fallar segun navegador/configuracion.

Esta build es para demo/revision funcional local. No requiere Flutter, Visual Studio, Node ni Python.
'@

  Write-TextFile (Join-Path $packageDir 'INICIAR_MASCOTIFY.bat') $launcher
  Write-TextFile (Join-Path $packageDir 'mascotify-local-server.ps1') $server
  Write-TextFile (Join-Path $packageDir 'INSTRUCCIONES-LECTURA-FUNCIONAL.txt') $instructions

  if (Test-Path $zipPath) {
    Remove-Item -LiteralPath $zipPath -Force
  }

  Write-Step "Comprimiendo paquete en $zipPath..."
  Compress-Archive -Path (Join-Path $packageDir '*') -DestinationPath $zipPath -Force

  if (-not (Test-Path $zipPath)) {
    throw "No se genero $zipPath"
  }

  Write-Step "Paquete generado: $zipPath"
} finally {
  Pop-Location
}
