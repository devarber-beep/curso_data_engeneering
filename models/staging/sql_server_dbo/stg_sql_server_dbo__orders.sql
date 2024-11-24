{{
  config(
    materialized='view',
    schema="staging"
  )
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__orders') }}
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
         tracking_id,
        status,
        {{ dbt_date.convert_timezone('_fivetran_synced', 'GMT', 'UTC') }} AS date_load,
          _fivetran_deleted
    FROM src_orders
    )

SELECT * FROM renamed_casted