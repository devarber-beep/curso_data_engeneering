{{
  config(
    materialized='view',
    schema="staging"
  )
}}

WITH src_addresses AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }}
    ),

renamed_casted AS (
    SELECT
          address_id,
          {{ dbt_utils.generate_surrogate_key('ZIPCODE') }}, --DatoSensible
          country,
          {{ dbt_utils.generate_surrogate_key('ADDRESS') }}, --DatoSensible
          state,
          _fivetran_deleted,
          _fivetran_synced
    FROM src_addresses
    )

SELECT * FROM renamed_casted