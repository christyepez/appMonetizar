[CmdletBinding()]
param()

$ErrorActionPreference = 'Continue'
Set-StrictMode -Version Latest

$results = [System.Collections.Generic.List[object]]::new()

function Add-Result([string]$Tool, [bool]$Ok, [string]$Version, [string]$Notes = '') {
    $results.Add([pscustomobject]@{
        Tool = $Tool
        Status = if ($Ok) { 'OK' } else { 'FALTA' }
        Version = $Version
        Notes = $Notes
    })
}

function Invoke-Version([string]$Command, [string[]]$Arguments) {
    try {
        $output = & $Command @Arguments 2>&1 | Select-Object -First 1
        return @{ Ok = ($LASTEXITCODE -eq 0 -or $null -eq $LASTEXITCODE); Output = [string]$output }
    }
    catch {
        return @{ Ok = $false; Output = $_.Exception.Message }
    }
}

$checks = @(
    @{ Tool = 'Git'; Command = 'git'; Args = @('--version') },
    @{ Tool = 'GitHub CLI'; Command = 'gh'; Args = @('--version') },
    @{ Tool = 'PowerShell'; Command = 'pwsh'; Args = @('--version') },
    @{ Tool = 'Node.js'; Command = 'node'; Args = @('--version') },
    @{ Tool = 'npm'; Command = 'npm'; Args = @('--version') },
    @{ Tool = 'FFmpeg'; Command = 'ffmpeg'; Args = @('-version') },
    @{ Tool = 'FFprobe'; Command = 'ffprobe'; Args = @('-version') },
    @{ Tool = 'jq'; Command = 'jq'; Args = @('--version') },
    @{ Tool = 'Docker'; Command = 'docker'; Args = @('--version') },
    @{ Tool = 'Docker Compose'; Command = 'docker'; Args = @('compose', 'version') },
    @{ Tool = 'Codex CLI'; Command = 'codex'; Args = @('--version') }
)

foreach ($check in $checks) {
    $result = Invoke-Version -Command $check.Command -Arguments $check.Args
    Add-Result -Tool $check.Tool -Ok $result.Ok -Version $result.Output
}

try {
    $sdks = & dotnet --list-sdks 2>&1
    $has8 = [bool]($sdks | Where-Object { $_ -match '^8\.' })
    $has10 = [bool]($sdks | Where-Object { $_ -match '^10\.' })
    Add-Result '.NET SDK 8' $has8 (($sdks | Where-Object { $_ -match '^8\.' }) -join ', ') 'Debe coexistir con .NET 10.'
    Add-Result '.NET SDK 10' $has10 (($sdks | Where-Object { $_ -match '^10\.' }) -join ', ') 'SDK principal del proyecto cuando se habilite la migración.'
}
catch {
    Add-Result '.NET SDK 8' $false '' $_.Exception.Message
    Add-Result '.NET SDK 10' $false '' $_.Exception.Message
}

try {
    docker info *> $null
    Add-Result 'Docker Engine activo' ($LASTEXITCODE -eq 0) '' 'Docker Desktop debe estar iniciado.'
}
catch {
    Add-Result 'Docker Engine activo' $false '' 'Abra Docker Desktop y vuelva a verificar.'
}

$results | Format-Table -AutoSize

$failed = $results | Where-Object Status -eq 'FALTA'
if ($failed.Count -gt 0) {
    Write-Host "`nHay herramientas pendientes. Revise la tabla y vuelva a ejecutar scripts/install-local.ps1 como administrador." -ForegroundColor Yellow
    exit 1
}

Write-Host "`nEntorno local verificado correctamente." -ForegroundColor Green
exit 0
