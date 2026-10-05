# Fase 4: Azure Data Factory (adf-hospital-dw-prod) - Orquestación e Integración

Este directorio almacena la documentación, configuraciones y el diseño técnico de los pipelines implementados en Azure Data Factory para el proyecto de Data Warehouse Hospitalario.

## 1. Especificaciones del Recurso
- **Nombre de la Factoría:** `adf-hospital-dw-prod`
- **Grupo de Recursos:** `rg-hospital-dw-prod`
- **Región:** `brazilsouth` (Brasil Sur)
- **Versión:** V2
- **Suscripción:** Azure for Students

## 2. Servicios Vinculados (*Linked Services*) Configurados
Para establecer la conectividad segura dentro de la arquitectura, se configuraron y validaron los siguientes servicios vinculados:
- **`LS_AzureSQL_Hospital_OLTP`**: Enlace hacia la base de datos transaccional en Azure SQL Database (`Hospital_OLTP`), utilizando autenticación por credenciales SQL de administración (`sqladminuser`).
- **`ls_adls_hospital_prod`**: Enlace hacia la cuenta de almacenamiento analítico en Azure Data Lake Storage Gen2 (`sthospital1790631198`), utilizando autenticación por clave de cuenta (*Account Key*).

## 3. Estructura de Conjuntos de Datos (*Datasets*)
Se estructuraron las abstracciones lógicas para la ingesta y almacenamiento intermedio en formato columnar optimizado (**Parquet**):
- **Origen CDC (`.sql`):** 
  - `ds_sql_pacientes_cdc` (`dbo.Pacientes`)
  - `ds_sql_citas_cdc` (`dbo.Citas`)
  - `ds_sql_facturacion_cdc` (`dbo.Facturacion`)
- **Destino Capa Bronze (`.parquet`):**
  - `ds_bronze_pacientes` (`bronze/hospital/pacientes/`)
  - `ds_bronze_citas` (`bronze/hospital/citas/`)
  - `ds_bronze_facturacion` (`bronze/hospital/facturacion/`)

## 4. Pipeline de Orquestación e Ingesta Incremental
- **Nombre del Pipeline:** `PL_Ingesta_Incremental_CDC`
- **Mecanismo:** Actividades de copia de datos (*Copy Data*) configuradas para extraer de forma incremental los cambios capturados por el registro de transacciones (*CDC / LSN*) de la base de datos transaccional hacia las rutas estructuradas de la Capa Bronze, optimizando el rendimiento y evitando cargas completas (*full load*).