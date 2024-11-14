
{{
  config(
    materialized='view'
  )
}}

WITH src_budget AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}
    ),

renamed_casted AS (
    SELECT
          _row
        , quantity
        , month
        , product_id
        , _fivetran_synced AS date_load
    FROM src_budget
    )

SELECT * FROM renamed_casted