{{
  config(
    materialized='view',
    schema="base"
  )
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

renamed_casted AS (
    SELECT
        order_id,
        case
          when shipping_service = '' then 'not_asigned'
          else  shipping_service
        end as shipping_service,
        shipping_cost,
        address_id,
        created_at,
        case
          when promo_id = '' then 'sin_promo'
          else  promo_id
          end as promo_id,
        estimated_delivery_at,
        order_cost,
        order_total,
        user_id, --relationship
        delivered_at,
        case
          when tracking_id = '' then null
          else  tracking_id
          end as tracking_id,
        status,
        _fivetran_deleted,
          _fivetran_synced
    FROM src_orders
    )

SELECT * FROM renamed_casted