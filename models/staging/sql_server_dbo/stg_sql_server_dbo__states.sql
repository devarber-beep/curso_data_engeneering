{{
  config(
    materialized='view',
    schema="staging"
  )
}}

WITH src_states AS (
    SELECT DISTINCT state, _fivetran_deleted
    FROM {{ ref('base_sql_server_addresses') }}
    ),

renamed_casted AS (
    SELECT
          {{ dbt_utils.generate_surrogate_key(['STATE']) }} as state_id, --DatoSensible
          state as name
    FROM src_states
    WHERE _fivetran_deleted is null
    )

SELECT * FROM renamed_casted