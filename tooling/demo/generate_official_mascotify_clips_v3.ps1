param(
  [string]$OutputDir = "assets/videos/clips"
)

$ErrorActionPreference = "Stop"

$clips = @(
  @{ File = "mascotify_qr_seguro_v3.mp4"; Text = "QR seguro"; C1 = "0xDDF6F6"; C2 = "0x66CCCC"; F1 = 523; F2 = 784 },
  @{ File = "mascotify_salud_vacunas_v3.mp4"; Text = "Salud y vacunas"; C1 = "0xEAFBFF"; C2 = "0x259C9C"; F1 = 440; F2 = 660 },
  @{ File = "mascotify_mascotas_perdidas_v3.mp4"; Text = "Mascotas perdidas"; C1 = "0xFFF2C6"; C2 = "0xFFCC33"; F1 = 392; F2 = 587 },
  @{ File = "mascotify_comunidad_pet_v3.mp4"; Text = "Comunidad pet"; C1 = "0xFFE1EA"; C2 = "0xFF3366"; F1 = 494; F2 = 740 },
  @{ File = "mascotify_clips_usuarios_v3.mp4"; Text = "Clips de mascotas"; C1 = "0xE4F5F5"; C2 = "0x66CCCC"; F1 = 587; F2 = 880 },
  @{ File = "mascotify_perfil_mascota_v3.mp4"; Text = "Perfil pet"; C1 = "0xDDF6F6"; C2 = "0x259C9C"; F1 = 330; F2 = 659 },
  @{ File = "mascotify_recordatorios_v3.mp4"; Text = "Recordatorios"; C1 = "0xFFF2C6"; C2 = "0x66CCCC"; F1 = 349; F2 = 698 },
  @{ File = "mascotify_profesionales_v3.mp4"; Text = "Profesionales"; C1 = "0xEAFBFF"; C2 = "0xFFCC33"; F1 = 415; F2 = 622 },
  @{ File = "mascotify_adopcion_responsable_v3.mp4"; Text = "Adopcion responsable"; C1 = "0xFFE1EA"; C2 = "0x259C9C"; F1 = 466; F2 = 699 },
  @{ File = "mascotify_privacidad_seguridad_v3.mp4"; Text = "Privacidad"; C1 = "0xDDF6F6"; C2 = "0xFF3366"; F1 = 554; F2 = 831 }
)

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

$font = "$env:WINDIR\Fonts\arialbd.ttf"
$fontArg = $font.Replace("\", "/").Replace(":", "\:")

foreach ($clip in $clips) {
  $output = Join-Path $OutputDir $clip.File
  $videoFilter = "drawbox=x=0:y=0:w=480:h=854:color=$($clip.C1):t=fill," +
    "drawbox=x=0:y=500:w=480:h=354:color=$($clip.C2)@0.42:t=fill," +
    "drawbox=x=64:y=128:w=72:h=72:color=white@0.22:t=fill," +
    "drawbox=x=340:y=190:w=56:h=56:color=white@0.18:t=fill," +
    "drawbox=x=82:y=650:w=46:h=46:color=white@0.16:t=fill," +
    "drawtext=fontfile='$fontArg':text='$($clip.Text)':fontcolor=0x333333:fontsize=42:x=(w-text_w)/2:y=(h-text_h)/2," +
    "format=yuv420p"
  $audioFilter = "sine=frequency=$($clip.F1):duration=7:sample_rate=48000[a0];" +
    "sine=frequency=$($clip.F2):duration=7:sample_rate=48000[a1];" +
    "[a0][a1]amix=inputs=2:duration=shortest,volume=0.18[a]"

  ffmpeg -y `
    -f lavfi -i "color=c=black:s=480x854:d=7:r=24" `
    -filter_complex "[0:v]$videoFilter[v];$audioFilter" `
    -map "[v]" -map "[a]" `
    -c:v libx264 -profile:v high -level 4.0 -pix_fmt yuv420p -r 24 `
    -c:a aac -b:a 128k -shortest -movflags +faststart $output
}

Write-Host "Generated Mascotify official clips V3 in $OutputDir"
