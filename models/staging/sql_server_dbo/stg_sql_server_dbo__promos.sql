{{
  config(
    materialized='view'
  )
}}
    /*schema="staging"*/

WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key('PROMO_ID') }}, --dato sensible
        discount AS discount_in_eu,
        status,
          _fivetran_deleted,
          _fivetran_synced AS date_load
        ,
    FROM src_promos 
    WHERE _FIVETRAN_DELETED = FALSE
    )

SELECT * FROM renamed_casted