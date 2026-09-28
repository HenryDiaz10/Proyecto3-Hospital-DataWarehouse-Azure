# Fase 4: Azure Data Factory (ADF) - Orquestación e Integración

Este directorio almacena la documentación, configuraciones y plantillas JSON de los pipelines implementados en Azure Data Factory para el proyecto de Data Warehouse Hospitalario.

## Especificaciones del Recurso
- **Nombre de la Factoría:** `adf-hospital-dw-prod`
- **Grupo de Recursos:** `rg-hospital-dw-prod`
- **Región:** `brazilsouth` (Brasil Sur)
- **Versión:** V2
- **Suscripción:** Azure for Students

## Propósito
Orquestar la extracción incremental de datos desde las fuentes locales utilizando Change Data Capture (CDC) y gestionar la carga estructurada a través de las capas de la Arquitectura Medallion (Bronze, Silver, Gold) alojadas en Azure Data Lake Storage Gen2.