{{
  config(
    materialized='view'
  )
}}
    /*schema="staging"*/

WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

renamed_casted AS (
    SELECT
        order_id,
        shipping_service,
        shipping_cost,
        address_id,
        created_at,
        event_id, -- relationship
        product_id, --relationship
        estimated_delivery_at,
        order_cost,
        user_id, --relationship
        order_total,
        delivery_at,
        {{ dbt_utils.generate_surrogate_key('TRACKING_ID') }}, --dato sensible
        status,
          _fivetran_deleted,
          _fivetran_synced AS date_load
        ,
    FROM src_orders
    WHERE _FIVETRAN_DELETED = FALSE
    )

SELECT * FROM renamed_casted