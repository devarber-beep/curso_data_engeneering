{{
  config(
    materialized='view',
    schema="staging"
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['PROMO_ID']) }}, --dato sensible
        discount AS discount_in_eu,
        CASE
            WHEN LOWER(status) = 'active' THEN 1
            WHEN LOWER(status) = 'inactive' THEN 0
            ELSE NULL
        END AS status_boolean,
          _fivetran_deleted,
          _fivetran_synced AS date_load
    FROM src_promos 
    WHERE _fivetran_deleted is null
    )

SELECT * FROM renamed_casted