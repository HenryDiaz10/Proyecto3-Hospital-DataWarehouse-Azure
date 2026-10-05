{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='IDPaciente',
        dist='HASH(IDPaciente)'
    )
}}

SELECT 
    IDPaciente,
    DNI,
    Nombres,
    Apellidos,
    FechaNacimiento,
    Genero,
    Telefono,
    Direccion,
    Distrito
FROM {{ source('bronze', 'pacientes') }}

{% if is_incremental() %}
WHERE IDPaciente >= (SELECT COALESCE(MAX(IDPaciente), 0) FROM {{ this }})
{% endif %}