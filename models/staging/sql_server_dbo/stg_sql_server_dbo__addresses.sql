{{
  config(
    materialized='view',
    schema="staging"
  )
}}

WITH src_addresses AS (
    SELECT * 
    FROM {{ ref('base_sql_server_addresses') }}
    ),

renamed_casted AS (
    SELECT
          address_id,
          {{ dbt_utils.generate_surrogate_key(['ZIPCODE']) }} as zipcode, --DatoSensible
          country,
          {{ dbt_utils.generate_surrogate_key(['ADDRESS']) }} as address, --DatoSensible
          state,
          _fivetran_deleted,
          _fivetran_synced
    FROM src_addresses
    WHERE _fivetran_deleted is null
    )

SELECT * FROM renamed_casted