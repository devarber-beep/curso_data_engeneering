{{
  config(
    materialized='view',
    schema="staging"
  )
}}

WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
    ),

renamed_casted AS (
    SELECT
        user_id,
        {{ dbt_date.convert_timezone('updated_at', 'GMT', 'UTC') }} AS updated_at_utc, --indicar y pasarlo a utc
        address_id,
        {{ dbt_utils.generate_surrogate_key(['LAST_NAME']) }}last_name, --dato sensible
        {{ dbt_date.convert_timezone('created_at', 'GMT', 'UTC') }} AS created_at_utc, --UTC
        {{ dbt_utils.generate_surrogate_key(['PHONE_NUMBER']) }}, --dato sensible
        total_orders,
        {{ dbt_utils.generate_surrogate_key(['FIRST_NAME']) }}, --dato sensible
        {{ dbt_utils.generate_surrogate_key(['EMAIL']) }}, --dato sensible
          _fivetran_deleted,
          _fivetran_synced AS date_load
    FROM src_users 
    WHERE _fivetran_deleted is null
    )

SELECT * FROM renamed_casted