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
        {{ dbt_date.convert_timezone('_fivetran_synced', 'GMT', 'UTC') }} AS date_load,
          _fivetran_deleted
    FROM src_orders
    )

SELECT * FROM renamed_casted