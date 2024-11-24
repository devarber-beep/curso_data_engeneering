{{
  config(
    materialized='view',
    schema="base"
  )
}}

WITH source AS (
    SELECT * FROM {{ source('google_sheets', 'budget') }}
)

SELECT
    PRODUCT_ID,
    QUANTITY,
    EXTRACT(YEAR FROM TO_DATE(MONTH)) AS YEAR,  -- Extraer el año
    EXTRACT(MONTH FROM TO_DATE(MONTH)) AS MONTH,
    _FIVETRAN_SYNCED
FROM source