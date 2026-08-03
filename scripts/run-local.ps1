[CmdletBinding()]
param(
    [ValidateSet('infra', 'app', 'all')]
    [string]$Profile = 'infra',
    [switch]$WithLocalAI,
    [switch]$Pull,
    [switch]$Build
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw 'Docker CLI no está disponible. Ejecute scripts/install-local.ps1.'
}

try {
    docker info *> $null
}
catch {
    throw 'Docker Engine no está activo. Abra Docker Desktop y vuelva a ejecutar.'
}

if (-not (Test-Path '.env')) {
    if (-not (Test-Path '.env.example')) {
        throw 'No existe .env.example.'
    }

    Copy-Item '.env.example' '.env'
    Write-Warning 'Se creó .env desde .env.example. Reemplace todos los valores CHANGE_ME antes de continuar.'
    exit 2
}

$envContent = Get-Content '.env' -Raw
if ($envContent -match 'CHANGE_ME') {
    throw 'El archivo .env todavía contiene valores CHANGE_ME. Configure secretos locales antes de levantar servicios.'
}

Write-Host 'Validando Docker Compose...' -ForegroundColor Cyan
docker compose config --quiet

if ($Pull) {
    Write-Host 'Descargando imágenes...' -ForegroundColor Cyan
    docker compose pull postgres rabbitmq minio n8n
    if ($WithLocalAI) {
        docker compose --profile local-ai pull ollama
    }
}

$arguments = @('compose')

switch ($Profile) {
    'infra' {
        $arguments += @('up', '-d', 'postgres', 'rabbitmq', 'minio', 'n8n')
    }
    'app' {
        $arguments += @('--profile', 'app', 'up', '-d')
        if ($Build) { $arguments += '--build' }
    }
    'all' {
        $arguments += @('--profile', 'app')
        if ($WithLocalAI) { $arguments += @('--profile', 'local-ai') }
        $arguments += @('up', '-d')
        if ($Build) { $arguments += '--build' }
    }
}

if ($WithLocalAI -and $Profile -eq 'infra') {
    & docker compose @('up', '-d', 'postgres', 'rabbitmq', 'minio', 'n8n')
    & docker compose @('--profile', 'local-ai', 'up', '-d', 'ollama')
}
else {
    & docker @arguments
}

if ($LASTEXITCODE -ne 0) {
    throw "Docker Compose falló con código $LASTEXITCODE."
}

Write-Host "`nEstado de servicios:" -ForegroundColor Cyan
docker compose ps

Write-Host @"

Entorno levantado.

n8n:      http://localhost:5679
RabbitMQ: http://localhost:15673
MinIO:    http://localhost:9003
API:      http://localhost:8088   (perfil app)
Web:      http://localhost:4208   (perfil app)
Ollama:   http://localhost:11435  (perfil local-ai)

Logs: docker compose logs -f n8n
Detener: docker compose down
"@ -ForegroundColor Green
