{{ config(schema='gold') }}
{{
    config(
        materialized='incremental',
        unique_key='IDFacturacion'
    )
}}

SELECT
    IDFacturacion,
    IDCita,
    IDPlan,
    MontoSubtotal,
    MontoDescuento,
    MontoTotal,
    FechaPago,
    MetodoPago
FROM {{ ref('stg_facturacion') }}

{% if is_incremental() %}
  WHERE FechaPago >= (SELECT COALESCE(MAX(FechaPago), '1900-01-01') FROM {{ this }})
{% endif %}