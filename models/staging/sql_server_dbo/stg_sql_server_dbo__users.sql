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

src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
),

renamed_casted AS (
    SELECT
        u.user_id,
        u.address_id,
        {{ encrypt_field('u.first_name', key) }} AS encrypted_first_name, -- dato sensible
        {{ encrypt_field('u.last_name', key) }} AS encrypted_last_name, -- dato sensible
        {{ encrypt_field('u.email', key) }} AS encrypted_email, -- dato sensible
        {{ encrypt_field('u.phone_number', key) }} AS encrypted_phone_number, -- dato sensible
        {{ dbt_date.convert_timezone('u.created_at', 'GMT', 'UTC') }} AS created_at_utc, 
        {{ dbt_date.convert_timezone('u.updated_at', 'GMT', 'UTC') }} AS updated_at_utc, 
        COALESCE(COUNT(o.order_id), 0) AS total_orders, -- Total de órdenes por usuario
        {{ dbt_date.convert_timezone('u._fivetran_synced', 'GMT', 'UTC') }} AS date_load,
        u._fivetran_deleted
    FROM src_users u
    LEFT JOIN src_orders o
        ON o.user_id = u.user_id
    GROUP BY 
        u.user_id,
        u.address_id,
        u.first_name,
        u.last_name,
        u.email,
        u.phone_number,
        u.created_at,
        u.updated_at,
        u._fivetran_synced,
        u._fivetran_deleted
)

SELECT * 
FROM renamed_casted
