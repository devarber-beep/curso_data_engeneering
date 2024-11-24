{{
  config(
    materialized='view',
    schema="staging"
  )
}}

WITH src_order_items AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'order_items') }}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['ORDER_ID', 'PRODUCT_ID']) }} as order_item_id,
        order_id, --relationship
        product_id, --relationship
        quantity,
        {{ dbt_date.convert_timezone('_fivetran_synced', 'GMT', 'UTC') }} AS date_load,
          _fivetran_deleted
    FROM src_order_items 
    )

SELECT * FROM renamed_casted