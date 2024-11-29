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
stg_shipping AS (
    SELECT {{ dbt_utils.star(from=ref('stg_sql_server_dbo__shipping_service'), except=['date_load']) }} 
    FROM {{ ref('stg_sql_server_dbo__shipping_service') }}
),
stg_orders AS (
    SELECT 
        {{ dbt_utils.star(from=ref('stg_sql_server_dbo__orders'), except=['_fivetran_deleted', 'shipping_service_id']) }},
        s.name AS shipping_service_name
    FROM {{ ref('stg_sql_server_dbo__orders') }} o
    LEFT JOIN stg_shipping s
    ON o.shipping_service_id = s.shipping_service_id
    WHERE 
        o._fivetran_deleted IS NULL
)

SELECT 
    {{ dbt_utils.star(from=ref('stg_sql_server_dbo__orders'), except=['_fivetran_deleted', 'promo_id', 'status', 'date_load', 'shipping_service_id']) }},
    o.promo_id,
    o.status,
    (o.order_total - p.discount_in_eu) AS discounted_order_total,
    o.date_load
FROM 
    stg_orders o
LEFT JOIN stg_promos p
ON o.promo_id = p.promo_id
