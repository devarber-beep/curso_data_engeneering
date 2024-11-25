{{
  config(
    materialized='table'.,
    schema='mart'
  )
}}

SELECT * 
FROM {{ ref('stg_sql_server_dbo__states') }}