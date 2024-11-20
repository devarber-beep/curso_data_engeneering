
{{
  config(
    materialized='view',
    schema="staging"
  )
}}

WITH src_budget AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}
),

renamed_casted AS (
    SELECT
          _row,
          quantity,
          month,
          product_id,
          _fivetran_synced AS date_load
    FROM src_budget
),

aggregated_budget AS (
    SELECT 
        month, -- referencia entidad tiempo
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_id) AS distinct_product, 
        MAX(date_load) AS max_date_load
    FROM renamed_casted
    GROUP BY month
)

SELECT 
    month,
    total_quantity,
    distinct_product,
    max_date_load
FROM aggregated_budget