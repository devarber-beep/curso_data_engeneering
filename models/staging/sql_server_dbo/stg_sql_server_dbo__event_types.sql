{{
  config(
    materialized='view',
    schema="staging"
  )
}}

WITH src_events AS (
    SELECT DISTINCT event_type,  
    FROM {{ ref('base_sql_server_dbo__events') }}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['EVENT_TYPE']) }} as event_type_id, --DatoSensible + RELATIONSHIP
        event_type as name
    FROM src_events
    )

SELECT * FROM renamed_casted