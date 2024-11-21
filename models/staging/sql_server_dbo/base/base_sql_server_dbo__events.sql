{{
  config(
    materialized='view',
    schema="base"
  )
}}

WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}
    ),

renamed_casted AS (
    SELECT
        event_id,
        page_url, -- Dato sensible
        event_type, --DatoSensible + RELATIONSHIP
        user_id, --relationship
        case
          when product_id = '' then null
          else  product_id
          end as product_id, --relationship
        session_id,
        created_at, --Ponerlo en UTC
        case
          when order_id = '' then null
          else  order_id
          end as order_id, --relationship
        _fivetran_synced,
        _fivetran_deleted
    FROM src_events
    )

SELECT * FROM renamed_casted