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
        {{ dbt_utils.generate_surrogate_key(['ORDER_ID', 'PRODUCT_ID']) }},
        order_id, --relationship
        product_id, --relationship
        quantity,
          _fivetran_synced AS date_load
    FROM src_order_items 
    WHERE _FIVETRAN_DELETED is null
    )

SELECT * FROM renamed_casted