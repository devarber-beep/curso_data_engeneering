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
        {{ dbt_date.convert_timezone('_fivetran_synced', 'GMT', 'UTC') }} AS date_load,
          _fivetran_deleted
    FROM src_products 
    )

SELECT * FROM renamed_casted