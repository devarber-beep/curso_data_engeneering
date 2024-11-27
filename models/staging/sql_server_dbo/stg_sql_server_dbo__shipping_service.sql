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
    SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['SHIPPING_SERVICE']) }} as shipping_service_id,
    {{ encrypt_field('shipping_service', key) }} as encrypted_name,
    CURRENT_TIMESTAMP AS date_load
    FROM src_orders
    )

SELECT * FROM renamed_casted