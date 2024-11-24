{{
  config(
    materialized='view',
    schema="staging"
  )
}}

WITH src_shipping_service AS (
    SELECT * 
    FROM {{ ref("base_sql_server_dbo__orders") }}
    ),

renamed_casted_shipping_service AS (
    SELECT DISTINCT
          {{ dbt_utils.generate_surrogate_key(['SHIPPING_SERVICE']) }} AS shipping_service_id
        , CASE WHEN 
            SHIPPING_SERVICE ='' THEN 'not_asigned' 
            ELSE SHIPPING_SERVICE 
        END AS SHIPPING_SERVICE_DESC
        , CURRENT_TIMESTAMP AS date_load
    FROM src_shipping_service
    )

SELECT * FROM renamed_casted_shipping_service
