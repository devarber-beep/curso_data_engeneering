{{
  config(
    materialized='view',
    schema="staging"
  )
}}

{% set key = var('encryption_key') %}

WITH src_addresses AS (
    SELECT * 
    FROM {{ ref('base_sql_server_addresses') }}
    ),

renamed_casted AS (
    SELECT
          address_id,
          {{ encrypt_field('zipcode', key) }} as encrypted_zipcode, --DatoSensible
          country,
          {{ encrypt_field('address', key) }} as encrypted_address, --DatoSensible
          state,
          {{ dbt_date.convert_timezone('_fivetran_synced', 'GMT', 'UTC') }} AS date_load,
          _fivetran_deleted
    FROM src_addresses
    )

SELECT * FROM renamed_casted