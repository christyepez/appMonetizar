[CmdletBinding()]
param(
    [switch]$SkipDocker,
    [switch]$SkipVisualStudioCode,
    [switch]$SkipCodex,
    [switch]$IncludePython
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Write-Step([string]$Message) {
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Test-Command([string]$Name) {
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Install-WingetPackage([string]$Id, [string]$Name) {
    Write-Step "Instalando o actualizando $Name"
    $arguments = @(
        'install', '--id', $Id, '--exact',
        '--accept-package-agreements', '--accept-source-agreements',
        '--silent', '--disable-interactivity'
    )

    & winget @arguments
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "winget devolvió código $LASTEXITCODE para $Name. Puede estar instalado o requerir intervención manual."
    }
}

if (-not (Test-Command 'winget')) {
    throw 'WinGet no está disponible. Instale o actualice App Installer desde Microsoft Store y vuelva a ejecutar este script.'
}

Write-Step 'Actualizando fuentes de WinGet'
winget source update | Out-Host

$packages = @(
    @{ Id = 'Git.Git'; Name = 'Git' },
    @{ Id = 'GitHub.cli'; Name = 'GitHub CLI' },
    @{ Id = 'Microsoft.PowerShell'; Name = 'PowerShell 7' },
    @{ Id = 'Microsoft.DotNet.SDK.8'; Name = '.NET SDK 8' },
    @{ Id = 'Microsoft.DotNet.SDK.10'; Name = '.NET SDK 10' },
    @{ Id = 'OpenJS.NodeJS.LTS'; Name = 'Node.js LTS' },
    @{ Id = 'Gyan.FFmpeg'; Name = 'FFmpeg' },
    @{ Id = 'jqlang.jq'; Name = 'jq' },
    @{ Id = '7zip.7zip'; Name = '7-Zip' }
)

if (-not $SkipVisualStudioCode) {
    $packages += @{ Id = 'Microsoft.VisualStudioCode'; Name = 'Visual Studio Code' }
}

if (-not $SkipDocker) {
    $packages += @{ Id = 'Docker.DockerDesktop'; Name = 'Docker Desktop' }
}

if ($IncludePython) {
    $packages += @{ Id = 'Python.Python.3.13'; Name = 'Python 3.13' }
}

foreach ($package in $packages) {
    Install-WingetPackage -Id $package.Id -Name $package.Name
}

Write-Step 'Actualizando PATH de la sesión actual'
$machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$env:Path = "$machinePath;$userPath"

if (Test-Command 'code') {
    Write-Step 'Instalando extensiones recomendadas de Visual Studio Code'
    $extensions = @(
        'ms-dotnettools.csdevkit',
        'ms-azuretools.vscode-docker',
        'dbaeumer.vscode-eslint',
        'esbenp.prettier-vscode',
        'eamodio.gitlens',
        'ms-vscode.powershell'
    )

    foreach ($extension in $extensions) {
        code --install-extension $extension --force | Out-Host
    }
}

if (-not $SkipCodex) {
    if (-not (Test-Command 'npm')) {
        Write-Warning 'npm todavía no está visible. Cierre y abra PowerShell y ejecute: npm install -g @openai/codex'
    }
    else {
        Write-Step 'Instalando OpenAI Codex CLI'
        npm install --global @openai/codex
    }
}

Write-Step 'Comprobando WSL para Docker Desktop'
if (Test-Command 'wsl') {
    try {
        wsl --update | Out-Host
    }
    catch {
        Write-Warning 'No se pudo actualizar WSL automáticamente. Ejecute PowerShell como administrador y use: wsl --update'
    }
}
else {
    Write-Warning 'WSL no está instalado. Docker Desktop puede solicitar habilitar WSL 2 y reiniciar Windows.'
}

Write-Host @"

Instalación solicitada completada.

Acciones manuales posibles:
1. Reinicie Windows si Docker Desktop o WSL lo solicitan.
2. Abra Docker Desktop y acepte sus términos.
3. Cierre y vuelva a abrir PowerShell para refrescar PATH.
4. Ejecute: .\scripts\verify-local.ps1
5. Autentique GitHub: gh auth login
6. Autentique Codex: codex
7. Levante infraestructura: .\scripts\run-local.ps1
"@ -ForegroundColor Green
