{{
  config(
    materialized='view'
  )
}}

WITH src_addresses AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }}
    ),

renamed_casted AS (
    SELECT
          address_id,
          zipcode, #DatoSensible
          country,
          address, #DatoSensible
          state,
          _fivetran_deleted,
          _fivetran_synced
        ,
    FROM src_addresses
    )

SELECT * FROM renamed_casted