{{
  config(
    materialized='view',
    schema="staging"
  )
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

renamed_casted AS (
    SELECT
        order_id,
        shipping_cost,
        order_cost, -- es calculado y debe ser comprobado
        order_total,
          _fivetran_synced AS date_load
    FROM src_orders
    WHERE _FIVETRAN_DELETED is null
    )

SELECT * FROM renamed_casted