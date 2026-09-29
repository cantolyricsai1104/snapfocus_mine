$ErrorActionPreference = 'Stop'

$flutter = Join-Path $PSScriptRoot '..\.tools\flutter\bin\flutter.bat'
$supabaseConfig = Join-Path $PSScriptRoot 'supabase.local.json'

if (-not (Test-Path -LiteralPath $supabaseConfig)) {
    throw "Missing Supabase configuration: $supabaseConfig"
}

& $flutter build apk `
    --debug `
    --dart-define-from-file=$supabaseConfig `
    --android-skip-build-dependency-validation

if ($LASTEXITCODE -ne 0) {
    throw "Flutter APK build failed with exit code $LASTEXITCODE"
}

$apk = Join-Path $PSScriptRoot 'build\app\outputs\flutter-apk\app-debug.apk'
Write-Host "APK ready: $apk"
