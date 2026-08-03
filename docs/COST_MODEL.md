# Modelo de costos operativos

## Objetivo
Controlar costo por canal, episodio, minuto renderizado, proveedor y publicación. Ningún proveedor se consume sin presupuesto y límite configurado.

## Fórmula

```text
Costo mensual = infraestructura fija
              + IA de texto
              + voz
              + imágenes y clips
              + render
              + almacenamiento/transferencia
              + observabilidad/backups
              + contingencia
```

## Escenarios iniciales

Supuesto MVP: 3 canales, 1 publicación diaria por canal, 90 piezas mensuales. Mezcla recomendada: 70% vertical de 60–90 segundos, 30% videos de 3–5 minutos; FFmpeg local; imágenes animadas y solo 10–20% de escenas con video generativo.

### Escenario A — piloto económico

| Concepto | Estimado mensual USD |
|---|---:|
| VPS 4 vCPU / 8 GB RAM | 20–50 |
| Backups, dominio y almacenamiento | 5–20 |
| LLM para guiones, revisión y metadata | 5–25 |
| TTS comercial | 20–60 |
| Imágenes generativas | 20–80 |
| Clips generativos limitados | 50–200 |
| Render FFmpeg local | Incluido en VPS |
| Monitoreo/correo | 0–20 |
| Contingencia 15% | 18–68 |
| **Total aproximado** | **138–523** |

Costo orientativo por pieza: **USD 1,53–5,81**.

### Escenario B — producción balanceada

| Concepto | Estimado mensual USD |
|---|---:|
| Infraestructura y backups | 60–150 |
| LLM y embeddings | 20–80 |
| Voz | 50–150 |
| Imágenes | 60–200 |
| Clips generativos | 250–800 |
| Render SaaS opcional | 54–129+ |
| Observabilidad/transferencia | 20–80 |
| Contingencia 15% | 77–238 |
| **Total aproximado** | **591–1.827+** |

Costo orientativo por pieza: **USD 6,57–20,30**.

### Escenario C — video generativo intensivo

Puede superar **USD 2.000–6.000 mensuales** para tres canales. No se recomienda antes de validar retención, CTR e ingresos.

## Costos conocidos que deben parametrizarse

- Creatomate recomienda comenzar en Essential, actualmente alrededor de USD 54/mes; Growth 10K alrededor de USD 129/mes. Un minuto 720p consume aproximadamente 14 créditos.
- ElevenLabs dispone de planes con licencia comercial y cobro adicional por créditos; el costo depende del modelo y plan.
- n8n Community self-hosted evita costo por ejecución, pero exige VPS, operación y backups. Funciones empresariales pueden requerir licencia.
- Los modelos LLM deben seleccionarse por tarea: modelo económico para clasificación/metadata y modelo superior solo para biblia, guion final o revisión compleja.

## Estrategias de ahorro

1. Renderizar con FFmpeg local y mantener SaaS como adaptador opcional.
2. Generar una imagen maestra por escena y aplicar paneo, zoom, parallax y overlays.
3. Limitar clips generativos a gancho, giro y clímax.
4. Cachear biblia, personajes, prompts base y embeddings.
5. Usar salida JSON estricta para evitar regeneraciones.
6. Generar lotes de voz por personaje.
7. Reutilizar escenarios dentro del mismo canal, no el mismo episodio entre canales.
8. Mantener una cola aprobada de siete días para evitar generación urgente costosa.
9. Implementar `BudgetGuardService` antes de conectar proveedores pagos.
10. Registrar costo real devuelto por cada proveedor.

## Límites iniciales por canal

```text
Presupuesto mensual: USD 150
Alerta 1: 60%
Alerta 2: 80%
Bloqueo automático: 100%
Máximo por episodio vertical: USD 4
Máximo por episodio largo: USD 10
Máximo de regeneraciones por activo: 2
```

## Métricas financieras

- Costo por episodio.
- Costo por minuto terminado.
- Costo por mil vistas.
- Ingreso por mil vistas.
- Margen por canal.
- Recuperación de costo por episodio.
- Proveedor más costoso por etapa.
- Costo de regeneración.
- Costo de contenido descartado.

Los valores son presupuestos de planificación y deben actualizarse desde las páginas oficiales de cada proveedor antes de contratar.
