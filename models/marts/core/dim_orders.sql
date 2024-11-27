{{
  config(
    database='ALUMNO6_DEV_GOLD_DB',
    materialized='table',
    schema='core'
  )
}}

WITH stg_promos AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__promos') }}
    ),

stg_orders AS (
    SELECT {{ dbt_utils.star(from=ref('stg_sql_server_dbo__orders'), except=['_fivetran_deleted']) }}  
    FROM {{ ref('stg_sql_server_dbo__orders') }}
    WHERE 
    _fivetran_deleted IS NULL
    )


SELECT 
    {{ dbt_utils.star(from=ref('stg_sql_server_dbo__orders'), except=['_fivetran_deleted', 'promo_id', 'status', 'date_load']) }},
    o.promo_id,
    o.status,
    (order_total - discount_in_eu) as discounted_order_total,
    o.date_load
FROM 
    stg_orders o
    join stg_promos p
    on o.promo_id = p.promo_id