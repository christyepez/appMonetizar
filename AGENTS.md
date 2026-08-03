# AGENTS.md - appMonetizar

## Propósito
Contrato operativo para Codex en la plataforma multicanal `appMonetizar`.

## Lectura mínima obligatoria
Leer en este orden y detenerse cuando exista contexto suficiente:
1. `AGENTS.md`.
2. `codex/PROJECT_CONTEXT.md`.
3. `codex/TASK_INDEX.md`.
4. El archivo coordinador del módulo afectado.
5. Solo contratos y archivos directamente relacionados.
6. `../CodexCommonAgents/AGENTS.md` y el playbook específico requerido.

No leer todo el repositorio ni todos los agentes.

## Arquitectura obligatoria
- .NET 8/9 con arquitectura vertical por funcionalidad.
- API REST separada en Controllers, DTOs, Interfaces, Services y Repositories.
- Domain sin dependencias de infraestructura.
- Integraciones externas mediante interfaces y adaptadores.
- n8n orquesta; la lógica crítica permanece en .NET.
- PostgreSQL + pgvector para persistencia y similitud.
- RabbitMQ para trabajos asíncronos.
- FFmpeg para composición y validación local.

## Regla de reutilización
Antes de crear componentes clasificar la decisión:
- `REUSE`: reutilizar componente existente.
- `EXTEND`: ampliar configuración o contrato existente.
- `ADAPT`: crear adaptador para proveedor o API.
- `CREATE`: capacidad propia del dominio.
- `BLOCKED`: detener por dependencia o contrato no resuelto.

## Regla multicanal
Cada canal es un tenant editorial independiente con nicho, identidad, personajes, calendario, presupuesto, plantillas, proveedores, políticas y métricas propios. No publicar el mismo activo en varios canales cambiando solo título, voz o color.

## Bajo consumo de tokens
- Ejecutar una tarea por vez.
- Leer primero índices y contratos.
- No volver a leer archivos sin cambios.
- Usar `codex/TASK_INDEX.md` para elegir el siguiente trabajo.
- Cambios pequeños: máximo un módulo o una historia por ejecución.
- No generar código fuera del alcance solicitado.
- Reportar rutas leídas y modificadas.

## Calidad mínima
- Build exitoso.
- Pruebas del módulo afectado.
- Sin secretos versionados.
- Idempotencia en publicación.
- CorrelationId y auditoría en flujos críticos.
- ADR para decisiones que cambien arquitectura.

## Cierre obligatorio
```text
Agent:
Task:
Files Read:
Files Created:
Files Modified:
Reuse Classification:
Tests Added:
Commands Executed:
Security Impact:
Cost Impact:
Risks:
Next Step:
```
