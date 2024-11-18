{{
  config(
    materialized='view'
  )
}}
    /*schema="staging"*/

WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}
    ),

renamed_casted AS (
    SELECT
        event_id,
        page_url,
        event_type, --DatoSensible
        user_id, --relationship
        product_id, --relationship
        session_id, --relationship
        created_at,
        order_id, --relationship
          _fivetran_deleted,
          _fivetran_synced AS date_load
        ,
    FROM src_events
    WHERE _FIVETRAN_DELETED = FALSE
    )

SELECT * FROM renamed_casted