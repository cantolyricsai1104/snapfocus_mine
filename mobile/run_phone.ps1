param(
    [string]$DeviceId
)

$ErrorActionPreference = 'Stop'

$flutter = Join-Path $PSScriptRoot '..\.tools\flutter\bin\flutter.bat'
$supabaseConfig = Join-Path $PSScriptRoot 'supabase.local.json'

if (-not (Test-Path -LiteralPath $supabaseConfig)) {
    throw "Missing Supabase configuration: $supabaseConfig"
}

Write-Host 'Connected Flutter devices:'
& $flutter devices

$arguments = @(
    'run'
    '--dart-define-from-file=' + $supabaseConfig
)

if ($DeviceId) {
    $arguments += @('-d', $DeviceId)
}

& $flutter @arguments
exit $LASTEXITCODE
