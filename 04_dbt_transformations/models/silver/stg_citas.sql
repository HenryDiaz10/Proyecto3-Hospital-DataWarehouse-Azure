{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='IDCita',
        dist='HASH(IDCita)'
    )
}}

SELECT 
    IDCita,
    IDPaciente,
    IDMedico,
    IDSala,
    FechaHoraCita,
    EstadoCita
FROM {{ source('bronze', 'citas') }}

{% if is_incremental() %}
WHERE FechaHoraCita >= (SELECT COALESCE(MAX(FechaHoraCita), '1900-01-01') FROM {{ this }})
{% endif %}