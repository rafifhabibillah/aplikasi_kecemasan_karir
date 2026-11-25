# Build release APK for Arahku (hemat memori Windows)
$ErrorActionPreference = 'Stop'

$env:JAVA_HOME = 'C:\Program Files\Eclipse Adoptium\jdk-17.0.21.10002-hotspot'
if (-not (Test-Path "$env:JAVA_HOME\bin\jlink.exe")) {
  Write-Host "JDK di $env:JAVA_HOME tidak punya jlink.exe. Install Temurin 17 dulu."
  exit 1
}

$env:GRADLE_USER_HOME = Join-Path $env:USERPROFILE '.gradle'
$env:PUB_CACHE = 'D:\pub-cache'
New-Item -ItemType Directory -Force -Path $env:PUB_CACHE | Out-Null

$env:Path = "C:\flutter\bin;$env:JAVA_HOME\bin;C:\Program Files\Git\cmd;C:\Windows\System32;C:\Windows;" + $env:Path
$env:JAVA_TOOL_OPTIONS = '-Djava.net.preferIPv4Stack=true -Djava.net.preferIPv6Addresses=false'
# Batasi juga heap untuk proses Gradle yang di-spawn Flutter
$env:GRADLE_OPTS = '-Xmx768m -Dorg.gradle.daemon=false'

try { ipconfig /flushdns | Out-Null } catch {}

Set-Location $PSScriptRoot
Write-Host "JAVA_HOME=$env:JAVA_HOME"
Write-Host "PUB_CACHE=$env:PUB_CACHE"

$os = Get-CimInstance Win32_OperatingSystem
$freeMb = [math]::Round($os.FreePhysicalMemory / 1024)
$totalMb = [math]::Round($os.TotalVisibleMemorySize / 1024)
Write-Host ("RAM bebas: {0} MB / {1} MB" -f $freeMb, $totalMb)
if ($freeMb -lt 1500) {
  Write-Host ""
  Write-Host "RAM bebas terlalu kecil untuk build Android."
  Write-Host "Tutup Chrome/Discord/emulator/Cursor agent lain, lalu jalankan script ini lagi."
  Write-Host "Atau naikkan Virtual Memory (paging file) Windows."
  exit 1
}

Write-Host "Menghentikan Gradle daemon lama..."
Push-Location android
try {
  & .\gradlew.bat --stop 2>$null | Out-Null
} catch {}
Pop-Location
Get-Process -Name java -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -like '*gradle*' -or $_.CommandLine -like '*GradleDaemon*' } |
  Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

java -version
flutter --version

Write-Host "Cek akses repository..."
$hostsOk = $true
foreach ($url in @(
  'https://plugins.gradle.org/m2/',
  'https://repo.maven.apache.org/maven2/',
  'https://services.gradle.org/distributions/'
)) {
  try {
    $null = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec 20 -UseBasicParsing
    Write-Host "  OK  $url"
  } catch {
    Write-Host "  FAIL $url"
    $hostsOk = $false
  }
}
if (-not $hostsOk) {
  Write-Host "Repository belum bisa diakses. Coba ganti DNS / matikan VPN."
  exit 1
}

Write-Host "Sync dependencies ke PUB_CACHE di drive D:..."
flutter pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Building release APK (heap 768m, no daemon)..."
flutter build apk --release

if ($LASTEXITCODE -eq 0) {
  $apk = Join-Path $PSScriptRoot 'build\app\outputs\flutter-apk\app-release.apk'
  Write-Host ""
  Write-Host "APK siap: $apk"
  if (Test-Path $apk) {
    Get-Item $apk | Format-List FullName, Length, LastWriteTime
  }
} else {
  Write-Host ""
  Write-Host "Build gagal. Jika error paging file / mmap:"
  Write-Host "  1) Tutup aplikasi berat (Chrome tabs, emulator)"
  Write-Host "  2) Settings > System > About > Advanced system settings > Performance > Virtual memory"
  Write-Host "     Set paging file custom: Initial 4096 MB, Maximum 8192 MB"
  Write-Host "  3) Restart laptop, lalu jalankan .\build_apk.ps1 lagi"
}
