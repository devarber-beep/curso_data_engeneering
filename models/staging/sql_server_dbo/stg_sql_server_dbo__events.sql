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
        {{ dbt_utils.generate_surrogate_key('PAGE_URL') }}, -- Dato sensible
        {{ dbt_utils.generate_surrogate_key('EVENT_TYPE') }}, --DatoSensible + RELATIONSHIP
        user_id, --relationship
        product_id, --relationship
        session_id, --relationship
        created_at, --Ponerlo en UTC
        order_id, --relationship
          _fivetran_deleted,
          _fivetran_synced AS date_load
        ,
    FROM src_events
    WHERE _FIVETRAN_DELETED = FALSE
    )

SELECT * FROM renamed_casted