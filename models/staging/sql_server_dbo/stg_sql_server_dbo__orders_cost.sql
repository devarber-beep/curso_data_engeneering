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
        case
          when promo_id = '' then null 
          else  {{ dbt_utils.generate_surrogate_key(['PROMO_ID']) }} --dato sensible
          end as promo_id, -- relationship
          _fivetran_synced AS date_load
    FROM src_orders
    WHERE _FIVETRAN_DELETED is null
    )

SELECT * FROM renamed_casted