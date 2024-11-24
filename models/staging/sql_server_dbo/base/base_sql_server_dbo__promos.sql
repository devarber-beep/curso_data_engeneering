{{
  config(
    materialized='view',
    schema="base"
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

renamed_casted AS (
    SELECT
        promo_id, --dato sensible
        CASE WHEN discount IS NULL THEN 0
            WHEN discount < 0 THEN 0  
            ELSE discount
        END  AS discount_in_eu,
        LOWER(status),
          _fivetran_synced AS date_load,
        _fivetran_deleted
    FROM src_promos 
    union all
    select  'sin_promo'
            , 0
            , 'undefined'
            , null
            , null
)
    )

SELECT * FROM renamed_casted