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
        {{ dbt_utils.generate_surrogate_key(['NAME']) }} as hash_name, -- dato sensible
        inventory,
          _fivetran_deleted,
          _fivetran_synced AS date_load
    FROM src_products 
    WHERE _FIVETRAN_DELETED IS NULL
    )

SELECT * FROM renamed_casted