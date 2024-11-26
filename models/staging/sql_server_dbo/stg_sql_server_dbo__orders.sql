{{
  config(
    materialized='view',
    schema="staging"
  )
}}

{% set key = var('encryption_key') %}

WITH src_orders AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__orders') }}
    ),

renamed_casted AS (
    SELECT
        order_id,
        user_id, --relationship
        address_id,
        order_cost, 
        {{ dbt_utils.generate_surrogate_key(['PROMO_ID']) }} as promo_id,
        order_total, -- es calculado y debe ser comprobado
        shipping_cost,
        {{ encrypt_field('shipping_service', key) }} as encrypted_shipping_service,
        {{ dbt_date.convert_timezone('created_at', 'GMT', 'UTC') }} AS created_at_utc,
        {{ dbt_date.convert_timezone('estimated_delivery_at', 'GMT', 'UTC') }} AS estimated_delivery_at_utc,
        {{ dbt_date.convert_timezone('delivered_at', 'GMT', 'UTC') }} AS delivered_at_utc,
         tracking_id,
        status,
        {{ dbt_date.convert_timezone('_fivetran_synced', 'GMT', 'UTC') }} AS date_load,
          _fivetran_deleted
    FROM src_orders
    )

SELECT * FROM renamed_casted