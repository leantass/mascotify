param(
  [Parameter(Mandatory = $true)]
  [string]$FfmpegPath,
  [string]$OutputDir = "assets/videos/clips"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $FfmpegPath)) {
  throw "FFmpeg not found: $FfmpegPath"
}

Add-Type -AssemblyName System.Drawing

$width = 480
$height = 854
$fps = 24
$seconds = 7
$frameCount = $fps * $seconds
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$outputRoot = Join-Path $repoRoot $OutputDir
$frameRoot = Join-Path $repoRoot "build\official_clip_frames"
New-Item -ItemType Directory -Force -Path $outputRoot | Out-Null
New-Item -ItemType Directory -Force -Path $frameRoot | Out-Null

$fontTitle = New-Object System.Drawing.Font("Segoe UI", 34, [System.Drawing.FontStyle]::Bold)
$fontBody = New-Object System.Drawing.Font("Segoe UI", 22, [System.Drawing.FontStyle]::Regular)
$fontSmall = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$fontBrand = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)

function New-Color([int]$a, [int]$r, [int]$g, [int]$b) {
  return [System.Drawing.Color]::FromArgb($a, $r, $g, $b)
}

function Lerp([double]$a, [double]$b, [double]$t) {
  return $a + (($b - $a) * $t)
}

function Ease([double]$t) {
  if ($t -lt 0) { return 0 }
  if ($t -gt 1) { return 1 }
  return 1 - [Math]::Pow(1 - $t, 3)
}

function Draw-StringCentered(
  [System.Drawing.Graphics]$g,
  [string]$text,
  [System.Drawing.Font]$font,
  [System.Drawing.Brush]$brush,
  [double]$centerX,
  [double]$y,
  [double]$maxWidth
) {
  $format = New-Object System.Drawing.StringFormat
  $format.Alignment = [System.Drawing.StringAlignment]::Center
  $format.LineAlignment = [System.Drawing.StringAlignment]::Near
  $rect = New-Object System.Drawing.RectangleF(
    [single]($centerX - ($maxWidth / 2)),
    [single]$y,
    [single]$maxWidth,
    [single]220
  )
  $g.DrawString($text, $font, $brush, $rect, $format)
  $format.Dispose()
}

function Draw-Paw(
  [System.Drawing.Graphics]$g,
  [double]$cx,
  [double]$cy,
  [double]$scale,
  [double]$angle,
  [System.Drawing.Brush]$brush
) {
  $state = $g.Save()
  $g.TranslateTransform([single]$cx, [single]$cy)
  $g.RotateTransform([single]$angle)
  $g.FillEllipse($brush, [single](-28 * $scale), [single](-10 * $scale), [single](56 * $scale), [single](46 * $scale))
  $g.FillEllipse($brush, [single](-42 * $scale), [single](-42 * $scale), [single](24 * $scale), [single](28 * $scale))
  $g.FillEllipse($brush, [single](-14 * $scale), [single](-54 * $scale), [single](24 * $scale), [single](30 * $scale))
  $g.FillEllipse($brush, [single](18 * $scale), [single](-42 * $scale), [single](24 * $scale), [single](28 * $scale))
  $g.FillEllipse($brush, [single](-8 * $scale), [single](-76 * $scale), [single](20 * $scale), [single](24 * $scale))
  $g.Restore($state)
}

function Fill-RoundedRectangle(
  [System.Drawing.Graphics]$g,
  [System.Drawing.Brush]$brush,
  [double]$x,
  [double]$y,
  [double]$w,
  [double]$h,
  [double]$radius
) {
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $path.AddArc([single]$x, [single]$y, [single]$radius, [single]$radius, 180, 90)
  $path.AddArc([single]($x + $w - $radius), [single]$y, [single]$radius, [single]$radius, 270, 90)
  $path.AddArc([single]($x + $w - $radius), [single]($y + $h - $radius), [single]$radius, [single]$radius, 0, 90)
  $path.AddArc([single]$x, [single]($y + $h - $radius), [single]$radius, [single]$radius, 90, 90)
  $path.CloseFigure()
  $g.FillPath($brush, $path)
  $path.Dispose()
}

$clips = @(
  @{
    File = "mascotify_qr_seguro.mp4"; Title = "QR seguro"; Lines = @("Si alguien la encuentra,", "puede avisarte", "Sin mostrar tus datos privados"); Accent = @(236, 56, 126); Soft = @(184, 235, 242); Icon = "QR"; Category = "Seguridad"
  },
  @{
    File = "mascotify_salud_vacunas.mp4"; Title = "Libreta sanitaria"; Lines = @("Vacunas, controles", "y recordatorios", "Todo ordenado por mascota"); Accent = @(38, 180, 171); Soft = @(255, 229, 239); Icon = "+"; Category = "Salud"
  },
  @{
    File = "mascotify_mascotas_perdidas.mp4"; Title = "Avisos solidarios"; Lines = @("Sin cobros ni rescates", "Ayudemos a volver", "a casa"); Accent = @(255, 98, 90); Soft = @(185, 237, 244); Icon = "!"; Category = "Perdidas"
  },
  @{
    File = "mascotify_comunidad_pet.mp4"; Title = "Comunidad pet"; Lines = @("Comparti momentos", "Conoce otras mascotas", "Una comunidad para tutores"); Accent = @(222, 63, 157); Soft = @(207, 244, 232); Icon = "LOVE"; Category = "Social"
  },
  @{
    File = "mascotify_clips_usuarios.mp4"; Title = "Clips de mascotas"; Lines = @("Subi tus mejores momentos", "Bloopers, juegos y paseos", "Tu mascota tambien tiene historia"); Accent = @(101, 99, 255); Soft = @(255, 226, 240); Icon = "PLAY"; Category = "Clips"
  },
  @{
    File = "mascotify_perfil_mascota.mp4"; Title = "Perfil de mascota"; Lines = @("Nombre, edad,", "datos y rutina", "Todo en un solo lugar"); Accent = @(247, 83, 132); Soft = @(185, 237, 244); Icon = "ID"; Category = "Perfil"
  },
  @{
    File = "mascotify_recordatorios.mp4"; Title = "Recordatorios"; Lines = @("No te olvides", "controles importantes", "Mascotify te ayuda a organizarte"); Accent = @(38, 153, 196); Soft = @(255, 232, 238); Icon = "OK"; Category = "Agenda"
  },
  @{
    File = "mascotify_profesionales.mp4"; Title = "Profesionales pet"; Lines = @("Veterinarias, paseadores", "y servicios", "Conecta con quienes cuidan"); Accent = @(142, 82, 210); Soft = @(198, 239, 244); Icon = "PRO"; Category = "Servicios"
  },
  @{
    File = "mascotify_adopcion_responsable.mp4"; Title = "Adopcion responsable"; Lines = @("Adoptar es compromiso", "Prepara tu hogar", "Dale tiempo y amor"); Accent = @(239, 94, 75); Soft = @(219, 247, 237); Icon = "LOVE"; Category = "Adopcion"
  },
  @{
    File = "mascotify_privacidad_seguridad.mp4"; Title = "Privacidad y seguridad"; Lines = @("Tus datos privados protegidos", "QR sin exponer telefono", "o direccion"); Accent = @(52, 65, 86); Soft = @(185, 237, 244); Icon = "SAFE"; Category = "Privacidad"
  }
)

foreach ($clip in $clips) {
  $framesDir = Join-Path $frameRoot ([System.IO.Path]::GetFileNameWithoutExtension($clip.File))
  if (Test-Path -LiteralPath $framesDir) {
    Remove-Item -LiteralPath $framesDir -Recurse -Force
  }
  New-Item -ItemType Directory -Force -Path $framesDir | Out-Null

  $accent = $clip.Accent
  $soft = $clip.Soft
  $dark = @(31, 42, 48)

  for ($i = 0; $i -lt $frameCount; $i++) {
    $t = $i / ($frameCount - 1)
    $pulse = ([Math]::Sin($t * [Math]::PI * 2) + 1) / 2
    $bitmap = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bitmap)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $top = New-Color 255 `
      ([int](Lerp $soft[0] $accent[0] ($pulse * 0.24))) `
      ([int](Lerp $soft[1] $accent[1] ($pulse * 0.24))) `
      ([int](Lerp $soft[2] $accent[2] ($pulse * 0.24)))
    $bottom = New-Color 255 `
      ([int](Lerp 255 $dark[0] (0.18 + $pulse * 0.08))) `
      ([int](Lerp 255 $dark[1] (0.18 + $pulse * 0.08))) `
      ([int](Lerp 255 $dark[2] (0.18 + $pulse * 0.08)))
    $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
      (New-Object System.Drawing.Point(0, [int](Lerp -120 80 $pulse))),
      (New-Object System.Drawing.Point($width, $height)),
      $top,
      $bottom
    )
    $g.FillRectangle($grad, 0, 0, $width, $height)
    $grad.Dispose()

    $accentBrush = New-Object System.Drawing.SolidBrush (New-Color 230 $accent[0] $accent[1] $accent[2])
    $softBrush = New-Object System.Drawing.SolidBrush (New-Color 64 255 255 255)
    $whiteBrush = New-Object System.Drawing.SolidBrush (New-Color 245 255 255 255)
    $mutedBrush = New-Object System.Drawing.SolidBrush (New-Color 218 255 255 255)
    $darkBrush = New-Object System.Drawing.SolidBrush (New-Color 218 35 43 48)

    for ($d = 0; $d -lt 7; $d++) {
      $x = (($d * 93) + ($t * 180)) % ($width + 120) - 60
      $y = 70 + (($d * 109) % 650) + ([Math]::Sin(($t * 5) + $d) * 18)
      $size = 18 + (($d * 7) % 36)
      $g.FillEllipse($softBrush, [single]$x, [single]$y, [single]$size, [single]$size)
    }

    $cardY = 170 + [Math]::Sin($t * [Math]::PI * 2) * 6
    $cardRect = New-Object System.Drawing.RectangleF(36, [single]$cardY, 408, 500)
    $cardPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $radius = 34
    $cardPath.AddArc($cardRect.X, $cardRect.Y, $radius, $radius, 180, 90)
    $cardPath.AddArc($cardRect.Right - $radius, $cardRect.Y, $radius, $radius, 270, 90)
    $cardPath.AddArc($cardRect.Right - $radius, $cardRect.Bottom - $radius, $radius, $radius, 0, 90)
    $cardPath.AddArc($cardRect.X, $cardRect.Bottom - $radius, $radius, $radius, 90, 90)
    $cardPath.CloseFigure()
    $cardBrush = New-Object System.Drawing.SolidBrush (New-Color 118 255 255 255)
    $g.FillPath($cardBrush, $cardPath)
    $cardPen = New-Object System.Drawing.Pen (New-Color 90 255 255 255), 2
    $g.DrawPath($cardPen, $cardPath)

    Draw-Paw $g 240 (118 + [Math]::Sin($t * [Math]::PI * 4) * 8) (1.02 + $pulse * 0.1) ($t * 32) $whiteBrush

    $pillBrush = New-Object System.Drawing.SolidBrush (New-Color 225 255 255 255)
    Fill-RoundedRectangle $g $pillBrush 136 40 208 44 44
    Draw-StringCentered $g "Mascotify" $fontBrand $darkBrush 240 49 180

    $iconY = $cardY + 54
    $g.FillEllipse($accentBrush, 176, [single]$iconY, 128, 128)
    Draw-Paw $g 240 ($iconY + 72) 0.48 ($t * 120) $whiteBrush
    Draw-StringCentered $g $clip.Icon $fontSmall $whiteBrush 240 ($iconY + 44) 100

    $titleProgress = Ease (($t - 0.08) / 0.22)
    $titleX = Lerp 600 240 $titleProgress
    Draw-StringCentered $g $clip.Title $fontTitle $darkBrush $titleX ($cardY + 210) 360

    for ($lineIndex = 0; $lineIndex -lt $clip.Lines.Count; $lineIndex++) {
      $line = $clip.Lines[$lineIndex]
      $p = Ease (($t - (0.24 + ($lineIndex * 0.12))) / 0.24)
      $lineX = Lerp -280 240 $p
      $lineY = $cardY + 295 + ($lineIndex * 52)
      Draw-StringCentered $g $line $fontBody $darkBrush $lineX $lineY 360
    }

    $bottomPillY = 714 + [Math]::Sin($t * [Math]::PI * 2) * 3
    Fill-RoundedRectangle $g $accentBrush 80 $bottomPillY 320 52 52
    Draw-StringCentered $g ("Contenido oficial - " + $clip.Category) $fontSmall $whiteBrush 240 ($bottomPillY + 13) 285

    $accentBrush.Dispose()
    $softBrush.Dispose()
    $whiteBrush.Dispose()
    $mutedBrush.Dispose()
    $darkBrush.Dispose()
    $pillBrush.Dispose()
    $cardBrush.Dispose()
    $cardPen.Dispose()
    $cardPath.Dispose()

    $framePath = Join-Path $framesDir ("frame_{0:D4}.png" -f $i)
    $bitmap.Save($framePath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bitmap.Dispose()
  }

  $outputPath = Join-Path $outputRoot $clip.File
  & $FfmpegPath -y -hide_banner -loglevel warning -framerate $fps -i (Join-Path $framesDir "frame_%04d.png") -c:v libx264 -profile:v main -level 3.1 -pix_fmt yuv420p -movflags +faststart -preset slow -crf 30 -an $outputPath
  if ($LASTEXITCODE -ne 0) {
    throw "FFmpeg failed for $($clip.File)"
  }
  Remove-Item -LiteralPath $framesDir -Recurse -Force
}

$fontTitle.Dispose()
$fontBody.Dispose()
$fontSmall.Dispose()
$fontBrand.Dispose()

Write-Host "Generated official Mascotify clips in $outputRoot"
