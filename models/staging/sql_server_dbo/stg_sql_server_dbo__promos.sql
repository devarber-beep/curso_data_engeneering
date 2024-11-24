{{
  config(
    materialized='view',
    schema="staging"
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__promos') }}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['PROMO_ID']) }} as promo_id,
        promo_id as name, --dato sensible
        discount_in_eu,
        status,
          _fivetran_synced AS date_load,
    FROM src_promos
    WHERE _FIVETRAN_DELETED IS NULL 

)
    )

SELECT * FROM renamed_casted