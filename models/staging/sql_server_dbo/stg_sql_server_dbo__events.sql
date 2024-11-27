{{
  config(
    materialized='view',
    schema="staging"
  )
}}

WITH src_events AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__events') }}
    ),

renamed_casted AS (
    SELECT
        event_id,
        page_url, -- Dato sensible
        {{ dbt_utils.generate_surrogate_key(['EVENT_TYPE']) }} as event_type_id, --DatoSensible + RELATIONSHIP
        user_id, --relationship
        product_id, --relationship
        session_id,
        {{ dbt_date.convert_timezone('created_at', 'GMT', 'UTC') }} AS created_at_utc, --Ponerlo en UTC
        order_id, --relationship
        {{ dbt_date.convert_timezone('_fivetran_synced', 'GMT', 'UTC') }} AS date_load,
          _fivetran_deleted
    FROM src_events
    )

SELECT * FROM renamed_casted