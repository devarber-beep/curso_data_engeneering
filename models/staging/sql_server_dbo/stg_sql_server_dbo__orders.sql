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
     {{ dbt_utils.generate_surrogate_key(['SHIPPING_SERVICE']) }} as shipping_service_id,
        address_id,
        {{ dbt_date.convert_timezone('created_at', 'GMT', 'UTC') }} AS created_at_utc,
        {{ dbt_date.convert_timezone('estimated_delivery_at', 'GMT', 'UTC') }} AS estimated_delivery_at_utc,
        user_id, --relationship
        {{ dbt_date.convert_timezone('delivered_at', 'GMT', 'UTC') }} AS delivered_at_utc,
         case
          when tracking_id = '' then null
          else  tracking_id
          end as tracking_id,
        status,
          _fivetran_synced AS date_load
    FROM src_orders
    WHERE _FIVETRAN_DELETED is null
    )

SELECT * FROM renamed_casted