# Repositorios de referencia

Estas referencias se usan como guía conceptual. No se copiará código sin verificar licencia, seguridad, mantenimiento y compatibilidad.

## 1. christyepez/CodexCommonAgents
Uso: contrato base de agentes, reglas, playbooks, clasificación REUSE/EXTEND/ADAPT/CREATE/BLOCKED y cierre estándar.
Aplicación: fuente principal de gobernanza para Codex.

## 2. harry0703/MoneyPrinterTurbo
Ideas reutilizables:
- Pipeline tema → guion → recursos → voz → subtítulos → música → video.
- Soporte horizontal y vertical.
- Generación por lotes con selección del mejor resultado.
- Abstracción de varios proveedores de LLM y TTS.
No reutilizar directamente:
- Arquitectura Python/MVC como arquitectura principal.
- Dependencia en stock footage genérico para todos los canales.
- Publicación masiva sin aprobación ni control de originalidad.

## 3. RayVentura/ShortGPT
Ideas reutilizables:
- Motores separados para short, video largo y traducción.
- Definición de edición mediante JSON/markup.
- Pipeline por etapas con artefactos intermedios.
Aplicación: inspirar contratos de `RenderPlan`, `ScenePlan` y `TimelineDefinition`.

## 4. FujiwaraChoki/MoneyPrinter
Ideas reutilizables:
- Composición local con MoviePy/FFmpeg.
- Ejecución local y Docker.
Aplicación: guía para mantener un renderizador local económico; se preferirá FFmpeg invocado desde un worker .NET.
Riesgo: no usar sesiones/cookies de TikTok; solo APIs oficiales.

## 5. n8n-io/self-hosted-ai-starter-kit
Ideas reutilizables:
- Docker Compose para n8n, PostgreSQL, vector store y modelos locales.
- Separación entre orquestación e infraestructura IA.
Aplicación: base conceptual para perfiles `local`, `cloud` y `gpu`.

## 6. n8n-io/n8n-hosting
Ideas reutilizables:
- Configuraciones oficiales con PostgreSQL y workers.
- Queue mode para escalar ejecuciones.
- Despliegue con SSL y alternativas Kubernetes.
Aplicación: endurecimiento de n8n para producción.

## 7. openai/skills
Ideas reutilizables:
- Skills instalables y cargadas bajo demanda.
- Cada skill tiene instrucciones, recursos y licencia propia.
Aplicación: crear skills pequeñas por tarea, no una skill monolítica.

## 8. microsoft/skills
Ideas reutilizables:
- Catálogo por lenguaje y dominio.
- Agentes separados para backend, frontend, infraestructura y planificación.
- Carga selectiva para evitar context rot.
Aplicación: índice de skills y agentes activados por alcance.

## Decisión arquitectónica
- `ADAPT`: conceptos de pipelines de video de MoneyPrinterTurbo y ShortGPT.
- `REUSE`: patrones oficiales de n8n hosting y Agent Skills.
- `CREATE`: dominio multicanal, control de costos, originalidad, políticas, aprobación y publicación segura en .NET vertical.

## Regla de seguridad
Todo repositorio externo debe pasar revisión antes de ejecutar scripts. No se concederán secretos ni permisos de publicación a código de terceros sin inspección, fijación de versión y pruebas aisladas.
