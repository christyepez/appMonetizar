# TASK_INDEX

Codex debe ejecutar una sola tarea por sesión. No saltar de sprint salvo que la tarea anterior cumpla criterios de salida.

## Sprint 0 — Fundación y contratos

- `S0-01` Crear solución .NET y proyectos por capas.
- `S0-02` Crear Dockerfiles de API, Worker y Angular.
- `S0-03` Completar `.env.example`, scripts `up/down/reset/logs/health`.
- `S0-04` Crear migración inicial PostgreSQL + pgvector.
- `S0-05` Integrar health, correlationId, Result Pattern y ProblemDetails.
- `S0-06` Crear adaptadores base al PortalCorporativo.
- `S0-07` Registrar permisos, menús y configuraciones del módulo.

## Sprint 1 — Canales y estrategia editorial

- `S1-01` Feature Channels: Controller, DTO, Interfaces, Service, Repository, validators y tests.
- `S1-02` Feature ChannelBrand: identidad, idioma, nicho, audiencia y restricciones.
- `S1-03` Feature ProviderConfiguration sin secretos persistidos en texto plano.
- `S1-04` Feature Budget: presupuesto, consumo, alertas y bloqueo.
- `S1-05` Panel Angular de canales usando shell/componentes reutilizables del portal.

## Sprint 2 — Historias y episodios

- `S2-01` Feature SeriesBible.
- `S2-02` Feature Characters.
- `S2-03` Feature EpisodeIdeas.
- `S2-04` Feature ScriptGeneration con salida JSON versionada.
- `S2-05` Embeddings y control de similitud.
- `S2-06` Continuidad narrativa y registro de elementos usados.

## Sprint 3 — Activos multimedia

- `S3-01` Feature ScenePlan.
- `S3-02` `IImageGenerationProvider` y primer adaptador.
- `S3-03` `IVideoGenerationProvider` y primer adaptador opcional.
- `S3-04` `IVoiceGenerationProvider` y primer adaptador.
- `S3-05` `IMediaStorage` con MinIO.
- `S3-06` Registro de licencia, prompt, hash, costo y proveedor.

## Sprint 4 — Render

- `S4-01` Contrato `RenderPlan` y `TimelineDefinition`.
- `S4-02` Worker FFmpeg horizontal.
- `S4-03` Worker FFmpeg vertical.
- `S4-04` Subtítulos, mezcla de audio y normalización.
- `S4-05` Miniaturas.
- `S4-06` Adaptador Creatomate/Shotstack opcional.

## Sprint 5 — Calidad y aprobación

- `S5-01` Validación técnica con ffprobe.
- `S5-02` Validación semántica y visual.
- `S5-03` Checklist de políticas versionado.
- `S5-04` Workflow de aprobación/rechazo/regeneración.
- `S5-05` Auditoría y notificaciones vía PortalCorporativo.
- `S5-06` Panel de previsualización y aprobación.

## Sprint 6 — Publicación

- `S6-01` Contrato común `ISocialPublishingProvider`.
- `S6-02` YouTube Data API, OAuth, programación e idempotencia.
- `S6-03` TikTok Content Posting API.
- `S6-04` Meta Reels/Instagram Publishing API.
- `S6-05` Reintentos, estados, webhooks y DeadLetter.

## Sprint 7 — Analítica y aprendizaje

- `S7-01` Recopilación de métricas por plataforma.
- `S7-02` Dashboard por canal.
- `S7-03` Costos, ingresos y margen.
- `S7-04` Experimentos A/B controlados.
- `S7-05` Recomendaciones para el próximo episodio.

## Criterio MVP

- 3 canales configurables.
- Cola aprobada de 7 días por canal.
- 1 publicación diaria por canal.
- Aprobación humana obligatoria.
- Costos trazables y límites activos.
- Publicación idempotente.
- Integración PortalCorporativo sin duplicar capacidades.

## Prompt de ejecución corto

```text
Implementa únicamente la tarea <ID> de codex/TASK_INDEX.md.
Lee AGENTS.md, codex/PROJECT_CONTEXT.md, la sección de <ID> y solo los archivos coordinadores del módulo.
Consulta CodexCommonAgents y PortalCorporativo solo para la capacidad transversal afectada.
Aplica arquitectura vertical: Controllers, DTOs, Interfaces, Services, Repositories, Validators y tests.
Actualiza documentación mínima, ejecuta build/tests y entrega el cierre obligatorio de AGENTS.md.
No avances a otra tarea.
```
