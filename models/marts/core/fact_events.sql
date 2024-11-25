{{
  config(
    database='ALUMNO6_DEV_GOLD_DB',
    materialized='table',
    schema='core'
  )
}}

SELECT 
    {{ dbt_utils.star(from=ref('stg_sql_server_dbo__events'), except=['_fivetran_deleted']) }} 
FROM 
    {{ ref('stg_sql_server_dbo__events') }}
WHERE 
    _fivetran_deleted IS NULL