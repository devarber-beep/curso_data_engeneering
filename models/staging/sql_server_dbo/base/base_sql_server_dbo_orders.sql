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
        end as shipping_service_id,
        shipping_cost,
        address_id,
        created_at,
        promo_id
        estimated_delivery_at,
        order_cost,
        user_id, --relationship
        delivered_at,
        case
          when tracking_id = '' then null
          else  tracking_id
          end as tracking_id,
        status,
        _fivetran_deleted,
          _fivetran_synced AS date_load
    FROM src_orders
    )

SELECT * FROM renamed_casted