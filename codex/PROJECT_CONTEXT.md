# PROJECT_CONTEXT

## Visión
Construir una fábrica multicanal de contenido audiovisual original asistido por IA para operar varios canales monetizables sin duplicar contenido ni depender de un único proveedor.

## Modelo operativo
- Una plataforma central.
- Múltiples canales como tenants editoriales.
- Cada canal tiene nicho, audiencia, identidad, biblia narrativa, personajes, idioma, calendario, presupuesto, proveedores y métricas independientes.
- Los activos comunes son técnicos: autenticación, almacenamiento, publicación, auditoría, colas, observabilidad y costos.
- Los activos creativos no se reutilizan entre canales salvo transformación editorial sustancial y documentada.

## Stack objetivo
- Backend: .NET con arquitectura vertical.
- API REST: Controllers, DTOs, Interfaces, Services y Repositories.
- Frontend: Angular para administración y aprobación.
- Orquestación: n8n self-hosted.
- Persistencia: PostgreSQL + pgvector.
- Mensajería: RabbitMQ.
- Render: FFmpeg como motor base; adaptadores opcionales a Creatomate/Shotstack.
- IA: proveedores intercambiables mediante interfaces.
- Storage: MinIO en local y adaptador Azure Blob/S3 en producción.
- Observabilidad: OpenTelemetry, Serilog y Grafana.

## Bounded contexts
1. Channel Management.
2. Editorial Strategy.
3. Story & Script Generation.
4. Media Asset Generation.
5. Rendering.
6. Quality & Policy Control.
7. Approval.
8. Publishing.
9. Analytics & Learning.
10. Cost & Budget Control.

## Reglas críticas
- Idempotencia para evitar publicaciones duplicadas.
- Aprobación humana obligatoria durante el piloto.
- Control de similitud semántica y visual.
- Registro de licencia, proveedor, prompt, hash y costo por activo.
- Presupuesto mensual y límite diario por canal.
- Publicación por APIs oficiales; nunca automatización basada en cookies o sesiones no autorizadas.
- No garantizar monetización; registrar elegibilidad y revisión humana.

## Objetivo MVP
Operar 3 canales, producir una cola de 7 días por canal, publicar 1 pieza diaria por canal y recopilar métricas básicas, manteniendo aprobación humana y costos trazables.
