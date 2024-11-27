{{
  config(
    database='ALUMNO6_DEV_GOLD_DB',
    materialized='table',
    schema='products'
  )
}}

{% set key = var('encryption_key') %}

WITH events AS (
    SELECT 
        *
    FROM {{ ref('fact_events') }}
),
user_info AS (
    SELECT *
    FROM {{ ref('dim_users') }}
),
session_metrics AS (
    SELECT 
        e.SESSION_ID,
        e.USER_ID,
        MIN(e.CREATED_AT_utc) AS FIRST_EVENT_TIME_UTC,
        MAX(e.CREATED_AT_utc) AS LAST_EVENT_TIME_UTC,
        DATEDIFF(MINUTE, MIN(e.CREATED_AT_utc), MAX(e.CREATED_AT_utc)) AS SESSION_DURATION_MINUTES,
        
        COUNT(DISTINCT CASE WHEN e.EVENT_TYPE = 'add_to_cart' THEN e.EVENT_ID ELSE NULL END) AS ADD_TO_CART_EVENTS,
        COUNT(DISTINCT CASE WHEN e.EVENT_TYPE = 'checkout' THEN e.EVENT_ID ELSE NULL END) AS CHECKOUT_EVENTS,
        COUNT(DISTINCT CASE WHEN e.EVENT_TYPE = 'package_shipped' THEN e.EVENT_ID ELSE NULL END) AS PACKAGE_SHIPPED_EVENTS,
        COUNT(DISTINCT CASE WHEN e.EVENT_TYPE = 'page_view' THEN e.EVENT_ID ELSE NULL END) AS PAGE_VIEW_EVENTS
    FROM events e
    GROUP BY e.SESSION_ID, e.USER_ID
)

SELECT
    sm.SESSION_ID,
    sm.USER_ID,
    {{ decrypt_field('ui.encrypted_first_name', key) }} AS FIRST_NAME,
    {{ decrypt_field('ui.encrypted_last_name', key) }} AS LAST_NAME,
    {{ decrypt_field('ui.encrypted_email', key) }} AS EMAIL,
    
    sm.FIRST_EVENT_TIME_UTC AS SESSION_FIRST_EVENT_TIME_UTC,
    sm.LAST_EVENT_TIME_UTC AS SESSION_LAST_EVENT_TIME_UTC,
    sm.SESSION_DURATION_MINUTES AS SESSION_DURATION_MINUTES,
    
    sm.PAGE_VIEW_EVENTS,
    sm.ADD_TO_CART_EVENTS,
    sm.CHECKOUT_EVENTS,
    sm.PACKAGE_SHIPPED_EVENTS

FROM session_metrics sm
JOIN user_info ui
    ON sm.USER_ID = ui.USER_ID