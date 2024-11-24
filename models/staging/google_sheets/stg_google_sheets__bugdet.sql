{{
  config(
    materialized='view',
    schema="base"
  )
}}

WITH source AS (
    SELECT * FROM {{ ref('base_google_sheets__bugdet') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['PRODUCT_ID', 'MONTH']) }} as budget_id,
    PRODUCT_ID,
    QUANTITY,
    MONTH,
    YEAR,
    {{ dbt_date.convert_timezone('_fivetran_synced', 'GMT', 'UTC') }} AS date_load,
FROM source