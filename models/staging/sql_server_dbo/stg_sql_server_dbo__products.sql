{{
  config(
    materialized='view',
    schema="staging"
  )
}}

WITH src_products AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }}
    ),

renamed_casted AS (
    SELECT
        product_id,
        price,
        name, -- dato sensible -> No para esta tabla
        inventory,
          _fivetran_synced AS date_load
    FROM src_products 
    WHERE _FIVETRAN_DELETED IS NULL
    )

SELECT * FROM renamed_casted