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
        {{ dbt_date.convert_timezone('_fivetran_synced', 'GMT', 'UTC') }} AS date_load,
          _fivetran_deleted
    FROM src_promos

)
    )

SELECT * FROM renamed_casted