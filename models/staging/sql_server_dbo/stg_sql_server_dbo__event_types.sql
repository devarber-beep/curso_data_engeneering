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
    SELECT DISTINCT
        {{ dbt_utils.generate_surrogate_key(['EVENT_TYPE']) }} as event_type_id,
        event_type as name,
        CURRENT_TIMESTAMP as date_load
    FROM src_events
    )

SELECT * FROM renamed_casted