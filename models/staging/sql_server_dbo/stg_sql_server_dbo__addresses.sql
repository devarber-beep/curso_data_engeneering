{{
  config(
    materialized='view'
  )
}}
    /*schema="staging"*/

WITH src_addresses AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }}
    ),

renamed_casted AS (
    SELECT
          address_id,
          zipcode, --DatoSensible
          country,
          address, --DatoSensible
          state,
          _fivetran_deleted,
          _fivetran_synced AS date_load
        ,
    FROM src_addresses
    WHERE _FIVETRAN_DELETED = FALSE
    )

SELECT * FROM renamed_casted