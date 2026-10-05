# Fase 5: Transformación de Datos y Modelado Dimensional (dbt + Docker)

Este directorio contiene la arquitectura de transformación de datos implementada con **dbt Core**, ejecutada en contenedores Docker y diseñada bajo la Arquitectura Medallion para el Data Warehouse hospitalario.

## 1. Estructura de Directorios
- **`models/silver/`**: Contiene los modelos de limpieza, estandarización y tipado incremental (`stg_pacientes.sql`, `stg_citas.sql`, `stg_facturacion.sql`).
- **`models/gold/`**: Contiene el modelado dimensional en **Esquema en Estrella (Star Schema)** optimizado para BI:
  - **Dimensión:** `dim_paciente`
  - **Tablas de Hechos:** `fact_citas`, `fact_facturacion`

## 2. Estrategia Técnica y de Rendimiento
- **Procesamiento por Microlotes:** Ejecuciones frecuentes que evitan la carga completa (*full load*).
- **Estrategia Incremental (`is_incremental`):** Filtrado dinámico mediante marcas de tiempo (`timestamp`) para procesar solo registros nuevos.
- **Operaciones `MERGE` (Upsert):** Definición de claves únicas (`unique_key`) para garantizar la idempotencia, actualizando registros modificados e insertando nuevos sin duplicidades.
- **Aislamiento con Docker:** Entorno empaquetado mediante contenedor para estandarizar la ejecución de dbt Core y sus adaptadores.
