{{
  config(
    database='ALUMNO6_DEV_GOLD_DB',
    materialized='table',
    schema='core'
  )
}}
SELECT 
    {{ dbt_utils.star(from=ref('stg_sql_server_dbo__products'), except=['_fivetran_deleted']) }} 
FROM 
    {{ ref('stg_sql_server_dbo__products') }}
WHERE 
    _fivetran_deleted IS NULL