{{
    config(
        materialized='incremental',
        unique_key='IDCita'
    )
}}

SELECT
    IDCita,
    IDPaciente,
    IDMedico,
    IDSala,
    FechaHoraCita,
    EstadoCita
FROM {{ source('bronze', 'Citas') }}

{% if is_incremental() %}
  WHERE FechaHoraCita >= (SELECT COALESCE(MAX(FechaHoraCita), '1900-01-01') FROM {{ this }})
{% endif %}