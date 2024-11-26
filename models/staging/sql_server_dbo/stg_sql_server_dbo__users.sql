{{
  config(
    materialized='view',
    schema="staging"
  )
}}

{% set key = var('encryption_key') %}

WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
    ),

renamed_casted AS (
    SELECT
        user_id,
        address_id,
        {{ encrypt_field('first_name', key) }} as encrypted_first_name, --dato sensible
        {{ encrypt_field('last_name', key) }} as encrypted_last_name, --dato sensible
        {{ encrypt_field('email', key) }} as encrypted_email, --dato sensible
        {{ encrypt_field('phone_number', key) }} as encrypted_phone_number, --dato sensible
        {{ dbt_date.convert_timezone('created_at', 'GMT', 'UTC') }} AS created_at_utc, --UTC
        {{ dbt_date.convert_timezone('updated_at', 'GMT', 'UTC') }} AS updated_at_utc, --indicar y pasarlo a utc
        total_orders,
        {{ dbt_date.convert_timezone('_fivetran_synced', 'GMT', 'UTC') }} AS date_load,
          _fivetran_deleted
    FROM src_users 
    )

SELECT * FROM renamed_casted