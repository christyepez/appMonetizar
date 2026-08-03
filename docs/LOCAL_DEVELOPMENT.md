# Entorno local de desarrollo

## Objetivo

Preparar Windows para implementar `appMonetizar` con Codex y ejecutar la infraestructura mediante Docker Compose.

## Herramientas

El script `scripts/install-local.ps1` instala o actualiza:

- Git.
- GitHub CLI.
- PowerShell 7.
- .NET SDK 8.
- .NET SDK 10.
- Node.js LTS y npm.
- Visual Studio Code.
- Extensiones de C#, Docker, PowerShell, ESLint, Prettier y GitLens.
- Docker Desktop.
- FFmpeg y FFprobe.
- jq.
- 7-Zip.
- OpenAI Codex CLI.
- Python 3.13 únicamente cuando se usa `-IncludePython`.

Los SDK de .NET 8 y .NET 10 pueden coexistir. El SDK seleccionado para cada proyecto debe controlarse mediante `TargetFramework` y, cuando sea necesario, `global.json`.

## Requisitos previos

- Windows 10 Enterprise/LTSC compatible o Windows 11.
- Virtualización habilitada.
- PowerShell ejecutado como administrador para instalaciones de sistema.
- WinGet disponible.
- Espacio libre recomendado: 25 GB.
- Memoria recomendada: 16 GB; mínimo práctico: 8 GB.

## Instalación

Abra PowerShell como administrador:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\install-local.ps1
```

Instalación con Python:

```powershell
.\scripts\install-local.ps1 -IncludePython
```

Para omitir componentes existentes:

```powershell
.\scripts\install-local.ps1 -SkipDocker -SkipVisualStudioCode
```

Docker Desktop o WSL pueden solicitar reiniciar Windows. Después del reinicio, abra Docker Desktop y espere hasta que el motor esté activo.

## Verificación

Abra una terminal nueva y ejecute:

```powershell
.\scripts\verify-local.ps1
```

Comprobaciones individuales:

```powershell
dotnet --list-sdks
node --version
npm --version
docker --version
docker compose version
ffmpeg -version
gh --version
codex --version
```

Debe aparecer al menos un SDK `8.x` y uno `10.x`.

## Autenticaciones

GitHub:

```powershell
gh auth login
```

Codex:

```powershell
codex
```

Siga el flujo de inicio de sesión mostrado por Codex. No guarde tokens ni claves en el repositorio.

## Variables locales

Copie el ejemplo:

```powershell
Copy-Item .env.example .env
```

Reemplace todos los valores `CHANGE_ME`. El archivo `.env` no debe versionarse.

## Levantar infraestructura

```powershell
.\scripts\run-local.ps1 -Profile infra -Pull
```

Servicios:

| Servicio | Dirección |
|---|---|
| n8n | http://localhost:5679 |
| RabbitMQ | http://localhost:15673 |
| MinIO | http://localhost:9003 |
| PostgreSQL | localhost:5434 |

## Levantar aplicación

Una vez que Codex haya creado API, Worker y frontend:

```powershell
.\scripts\run-local.ps1 -Profile app -Build
```

Para levantar todos los componentes:

```powershell
.\scripts\run-local.ps1 -Profile all -Build
```

Con modelo local opcional:

```powershell
.\scripts\run-local.ps1 -Profile all -Build -WithLocalAI
```

## Operación

```powershell
docker compose ps
docker compose logs -f n8n
docker compose logs -f postgres
docker compose restart n8n
docker compose down
docker compose down -v # elimina datos; usar únicamente para reinicio total
```

## n8n

n8n utiliza PostgreSQL, volumen persistente, zona horaria `America/Guayaquil` y carpeta compartida para workflows. En el primer acceso se crea el usuario propietario desde la interfaz.

No se deben instalar nodos comunitarios sin una revisión previa de:

- Repositorio y autor.
- Licencia.
- Actividad de mantenimiento.
- Acceso a credenciales.
- Acceso al sistema de archivos.
- Riesgos de ejecución de código.

Las reglas de negocio, idempotencia, presupuestos y publicación permanecen en .NET; n8n actúa como orquestador.

## Uso de .NET 8 y .NET 10

Durante el MVP:

- Usar .NET 10 para proyectos nuevos cuando todas las dependencias sean compatibles.
- Mantener .NET 8 para compatibilidad con servicios o librerías existentes.
- No mezclar frameworks dentro del mismo proyecto.
- Permitir soluciones con proyectos de distintos frameworks solo cuando exista una razón documentada.
- Usar imágenes Docker `mcr.microsoft.com/dotnet/sdk:10.0` y `aspnet:10.0` para proyectos .NET 10.
- Usar imágenes `8.0` para proyectos que deban permanecer en .NET 8.

## Flujo con Codex

Desde la raíz:

```powershell
codex
```

La primera instrucción debe pedirle leer solamente:

1. `AGENTS.md`.
2. `codex/PROJECT_CONTEXT.md`.
3. La tarea activa en `codex/TASK_INDEX.md`.
4. El agente o skill específico de `CodexCommonAgents`.

Codex debe ejecutar al cerrar cada tarea:

```powershell
dotnet restore
dotnet build --no-restore
dotnet test --no-build
docker compose config --quiet
```

Cuando la tarea cambie contenedores:

```powershell
docker compose --profile app up -d --build
docker compose ps
```

## Problemas frecuentes

### `docker` no se reconoce

Cierre y abra la terminal. Si persiste, reinicie Windows después de instalar Docker Desktop.

### Docker Engine no responde

Abra Docker Desktop y espere hasta que indique que el motor está en ejecución.

### WSL no está actualizado

```powershell
wsl --update
wsl --shutdown
```

Después, reinicie Docker Desktop.

### Solo aparece un SDK .NET

```powershell
winget install Microsoft.DotNet.SDK.8 --exact
winget install Microsoft.DotNet.SDK.10 --exact
dotnet --list-sdks
```

### `codex` no se reconoce

```powershell
npm install --global @openai/codex
```

Cierre y abra la terminal.

### n8n no inicia

```powershell
docker compose logs n8n
docker compose logs postgres
docker compose config
```

Compruebe `POSTGRES_PASSWORD`, `N8N_ENCRYPTION_KEY` y `N8N_USER_MANAGEMENT_JWT_SECRET` en `.env`.
