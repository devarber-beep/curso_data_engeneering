{{
  config(
    materialized='table'.,
    schema='mart'
  )
}}

SELECT * 
FROM {{ ref('stg_google_sheets__bugdet') }}