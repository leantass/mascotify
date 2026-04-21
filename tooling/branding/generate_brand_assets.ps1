param(
    [Parameter(Mandatory = $true)]
    [string]$SourcePng
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

function New-ResizedPng {
    param(
        [Parameter(Mandatory = $true)]
        [System.Drawing.Bitmap]$SourceBitmap,

        [Parameter(Mandatory = $true)]
        [int]$Size,

        [Parameter(Mandatory = $true)]
        [string]$OutputPath
    )

    $outputDirectory = Split-Path -Parent $OutputPath
    if (-not [string]::IsNullOrWhiteSpace($outputDirectory)) {
        New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
    }

    $canvas = New-Object System.Drawing.Bitmap $Size, $Size
    $graphics = [System.Drawing.Graphics]::FromImage($canvas)

    try {
        $graphics.Clear([System.Drawing.Color]::Transparent)
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
        $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $graphics.DrawImage($SourceBitmap, 0, 0, $Size, $Size)
        $canvas.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    }
    finally {
        $graphics.Dispose()
        $canvas.Dispose()
    }
}

$resolvedSource = Resolve-Path $SourcePng
$sourcePath = $resolvedSource.Path

if (-not (Test-Path $sourcePath)) {
    throw "No se encontro el archivo fuente: $SourcePng"
}

$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$sourceBitmap = [System.Drawing.Bitmap]::new($sourcePath)

try {
    if ($sourceBitmap.Width -ne $sourceBitmap.Height) {
        throw "El asset fuente debe ser cuadrado. Tamano detectado: $($sourceBitmap.Width)x$($sourceBitmap.Height)"
    }

    if ($sourceBitmap.Width -lt 1024) {
        Write-Warning "El asset fuente mide menos de 1024px. Se recomienda usar al menos 1024x1024."
    }

    $androidTargets = @(
        @{ Size = 48; Path = "android/app/src/main/res/mipmap-mdpi/ic_launcher.png" },
        @{ Size = 72; Path = "android/app/src/main/res/mipmap-hdpi/ic_launcher.png" },
        @{ Size = 96; Path = "android/app/src/main/res/mipmap-xhdpi/ic_launcher.png" },
        @{ Size = 144; Path = "android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png" },
        @{ Size = 192; Path = "android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" }
    )

    $iosTargets = @(
        @{ Size = 20; Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png" },
        @{ Size = 40; Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png" },
        @{ Size = 60; Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png" },
        @{ Size = 29; Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png" },
        @{ Size = 58; Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png" },
        @{ Size = 87; Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png" },
        @{ Size = 40; Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png" },
        @{ Size = 80; Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png" },
        @{ Size = 120; Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png" },
        @{ Size = 120; Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png" },
        @{ Size = 180; Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png" },
        @{ Size = 76; Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png" },
        @{ Size = 152; Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png" },
        @{ Size = 167; Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png" },
        @{ Size = 1024; Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png" }
    )

    $webTargets = @(
        @{ Size = 32; Path = "web/favicon.png" },
        @{ Size = 192; Path = "web/icons/Icon-192.png" },
        @{ Size = 512; Path = "web/icons/Icon-512.png" },
        @{ Size = 192; Path = "web/icons/Icon-maskable-192.png" },
        @{ Size = 512; Path = "web/icons/Icon-maskable-512.png" }
    )

    $allTargets = @($androidTargets + $iosTargets + $webTargets)

    foreach ($target in $allTargets) {
        $absolutePath = Join-Path $repoRoot $target.Path
        New-ResizedPng -SourceBitmap $sourceBitmap -Size $target.Size -OutputPath $absolutePath
        Write-Output "Generado: $($target.Path) ($($target.Size)x$($target.Size))"
    }
}
finally {
    $sourceBitmap.Dispose()
}
