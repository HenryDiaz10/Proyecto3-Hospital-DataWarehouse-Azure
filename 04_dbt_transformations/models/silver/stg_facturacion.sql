{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='IDFacturacion',
        dist='HASH(IDFacturacion)'
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
    Metodopago
FROM {{ source('bronze', 'facturacion') }}

{% if is_incremental() %}
WHERE FechaPago >= (SELECT COALESCE(MAX(FechaPago), '1900-01-01') FROM {{ this }})
{% endif %}