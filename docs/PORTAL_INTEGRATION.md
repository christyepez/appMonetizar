# Integración con PortalCorporativo

## Principio
`appMonetizar` es un dominio consumidor del portal. No duplica capacidades transversales ni accede directamente a bases de datos del portal.

## Matriz de reutilización

| Capacidad | Decisión | Aplicación en appMonetizar |
|---|---|---|
| API Gateway YARP | REUSE | Exponer `/monetizar/*` y enrutar hacia la API del dominio. |
| Security API | REUSE/EXTEND | Registrar recursos, permisos y políticas del módulo. |
| Menu API | EXTEND | Registrar menús dinámicos: Canales, Calendario, Producción, Aprobaciones, Publicaciones, Métricas, Costos y Configuración. |
| Configuration API | EXTEND | Guardar parámetros por tenant, módulo, canal y usuario cuando corresponda. |
| Audit API | ADAPT | Auditar aprobaciones, regeneraciones, cambios de presupuesto y publicaciones. |
| Notification API | ADAPT | Alertar aprobación pendiente, error de render, publicación fallida, límite presupuestario y reclamación. |
| SQL Outbox/Inbox | EXTEND | Mantener Outbox/Inbox en la base de appMonetizar. |
| Workers | EXTEND | Worker de dominio para generación, render y publicación; no duplicar worker transversal. |
| Health/logging/correlationId | REUSE | Propagar `correlationId` desde Gateway a API, worker, n8n y proveedores. |
| Content/File API | BLOCKED/ADAPT | Mientras esté pendiente, usar almacenamiento de dominio detrás de `IMediaStorage`; migrar/adaptar cuando esté disponible. |
| Reporting API | BLOCKED/EXTEND | Métricas iniciales en dominio; integrar cuando el portal publique el contrato. |
| Angular Shell | BLOCKED/REUSE | Crear frontend modular compatible; integrar al shell cuando esté disponible. |
| IdP/OIDC productivo | BLOCKED | Desarrollo con mecanismo foundation; no declarar login productivo hasta disponer del IdP. |

## Recursos y permisos propuestos

```text
monetizar.channels.read
monetizar.channels.manage
monetizar.content.read
monetizar.content.generate
monetizar.content.approve
monetizar.content.reject
monetizar.render.execute
monetizar.publications.schedule
monetizar.publications.publish
monetizar.publications.retry
monetizar.analytics.read
monetizar.costs.read
monetizar.costs.manage
monetizar.providers.manage
monetizar.settings.manage
```

## Eventos del dominio

```text
monetizar.channel.created.v1
monetizar.episode.generated.v1
monetizar.render.completed.v1
monetizar.approval.requested.v1
monetizar.episode.approved.v1
monetizar.publication.scheduled.v1
monetizar.publication.completed.v1
monetizar.publication.failed.v1
monetizar.budget.threshold-reached.v1
```

## Docker Compose local

No se duplicarán contenedores del Portal cuando ambos repositorios se ejecuten juntos. El modo integrado usará una red Docker externa compartida:

```yaml
networks:
  portal-network:
    external: true
```

`appMonetizar` mantendrá PostgreSQL, pgvector, RabbitMQ, MinIO, n8n, API y worker propios. Consumirá Gateway, Security, Menu, Configuration, Audit y Notification por URL/configuración.

## Regla de implementación
Antes de crear una funcionalidad transversal, Codex debe consultar:

1. `CodexCommonAgents/registry/reusable-portal-apis.md`.
2. `PortalCorporativo/codex/REUSABLE_CAPABILITIES.md`.
3. `PortalCorporativo/docs/coordination/consumer-onboarding-guide.md`.

Si una capacidad está pendiente, usar un puerto de dominio y un adaptador temporal, nunca acoplarse a una implementación provisional.
