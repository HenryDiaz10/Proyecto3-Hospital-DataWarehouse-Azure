{{ config(schema='gold') }}
{{
    config(
        materialized='table'
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
FROM {{ ref('stg_pacientes') }}