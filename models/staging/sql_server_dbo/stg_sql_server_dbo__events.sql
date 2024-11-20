{{
  config(
    materialized='view',
    schema="staging"
  )
}}

WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}
    ),

renamed_casted AS (
    SELECT
        event_id,
        {{ dbt_utils.generate_surrogate_key(['PAGE_URL']) }} as page_url, -- Dato sensible
        {{ dbt_utils.generate_surrogate_key(['EVENT_TYPE']) }} as event_type_id, --DatoSensible + RELATIONSHIP
        user_id, --relationship
        product_id, --relationship
        session_id,
        {{ dbt_date.convert_timezone('created_at', 'GMT', 'UTC') }} AS created_at_utc, --Ponerlo en UTC
        order_id, --relationship
          _fivetran_synced AS date_load
    FROM src_events
    WHERE _FIVETRAN_DELETED is null
    )

SELECT * FROM renamed_casted