{{
  config(
    materialized='view',
    schema="staging"
  )
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__orders')}}
    ),

renamed_casted AS (
    SELECT
        order_id,
        shipping_cost,
        order_cost, -- es calculado y debe ser comprobado
        order_total,
        promo_id,
          _fivetran_synced AS date_load
    FROM src_orders
    WHERE _FIVETRAN_DELETED is null
    )

SELECT * FROM renamed_casted