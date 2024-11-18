{{
  config(
    materialized='view'
  )
}}
    /*schema="staging"*/

WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
    ),

renamed_casted AS (
    SELECT
        user_id,
        updated_at,
        address_id,
        last_name, --dato sensible
        created_at,
        phone_numbre, --dato sensible
        total_orders,
        first_name, --dato sensible
        email, --dato sensible
          _fivetran_deleted,
          _fivetran_synced AS date_load
        ,
    FROM src_users 
    WHERE _FIVETRAN_DELETED = FALSE
    )

SELECT * FROM renamed_casted