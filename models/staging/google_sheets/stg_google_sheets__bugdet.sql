{{
  config(
    materialized='incremental'
  )
}}

WITH source AS (
    SELECT * FROM {{ ref('base_google_sheets__bugdet') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['PRODUCT_ID', 'MONTH']) }} as budget_id
    PRODUCT_ID,
    QUANTITY,
    MONTH,
    YEAR,
    CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
FROM source