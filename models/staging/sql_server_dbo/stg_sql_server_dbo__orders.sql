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
        {{ dbt_date.convert_timezone('GMT', 'UTC', 'created_at') }} AS created_at_utc,
        event_id, -- relationship
        product_id, --relationship
        {{ dbt_date.convert_timezone('GMT', 'UTC', 'estimated_delivery_at') }} AS estimated_delivery_at_utc,
        order_cost, -- es calculado y debe ser comprobado
        user_id, --relationship
        order_total,
        {{ dbt_date.convert_timezone('GMT', 'UTC', 'delivery_at') }} AS delivery_at_utc,
        {{ dbt_utils.generate_surrogate_key('TRACKING_ID') }}, --dato sensible
        status,
          _fivetran_deleted,
          _fivetran_synced AS date_load
    FROM src_orders
    WHERE _FIVETRAN_DELETED = FALSE
    )

SELECT * FROM renamed_casted