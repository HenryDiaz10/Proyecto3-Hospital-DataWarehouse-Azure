{{
    config(
        materialized='incremental',
        unique_key='IDPaciente'
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
FROM {{ source('bronze', 'Pacientes') }}

{% if is_incremental() %}
  WHERE IDPaciente  (SELECT COALESCE(MAX(IDPaciente), 0) FROM {{ this }})
{% endif %}