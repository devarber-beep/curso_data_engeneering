{{
  config(
    database='ALUMNO6_DEV_GOLD_DB',
    materialized='table',
    schema='marketing'
  )
}}

WITH 
orders AS (
    SELECT *
    FROM {{ ref('dim_orders') }}
),
users AS (
    SELECT 
        *
    FROM {{ ref('dim_users') }}
),
promos AS (
    SELECT *
    FROM {{ ref('dim_promos') }}
),
addresses AS (
    SELECT *
    FROM {{ ref("dim_addresses") }}
)

{% set key = var('encryption_key') %}

SELECT 
    u.user_id,
    {{ decrypt_field('u.encrypted_first_name', key) }} AS FIRST_NAME,
    {{ decrypt_field('u.encrypted_last_name', key) }} AS LAST_NAME,
    {{ decrypt_field('u.encrypted_email', key) }} AS EMAIL,
    {{ decrypt_field('u.encrypted_phone_number', key) }} AS PHONE_NUMBER,
    u.CREATED_AT_UTC,
    u.UPDATED_AT_UTC,
    a.ADDRESS_ID,
    a.STATE,
    {{ decrypt_field('a.encrypted_zipcode', key) }} AS ZIPCODE,
    a.COUNTRY,
    COUNT(DISTINCT o.order_id) AS TOTAL_NUMBER_ORDERS, -- Aquí se usa o.order_id
    SUM(o.order_total) AS TOTAL_ORDER_COST_USD,       -- Aquí se usa o.order_total
    SUM(o.shipping_cost) AS TOTAL_SHIPPING_COST_EU,   -- Aquí se usa o.shipping_cost
    SUM(p.discount_in_eu) AS TOTAL_DISCOUNT_EU,       -- Aquí se usa o.discount_in_eu
    COUNT(o.order_id) AS TOTAL_DIFF_PRODUCTS          -- Aquí se usa o.order_id
FROM users u
LEFT JOIN addresses a
ON u.address_id = a.address_id
LEFT JOIN orders o
ON u.user_id = o.user_id
LEFT JOIN promos p
on o.promo_id = p.promo_id
GROUP BY 
    u.user_id, 
    FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
    u.CREATED_AT_UTC, u.UPDATED_AT_UTC,
    a.ADDRESS_ID, a.STATE, 
    ZIPCODE, 
    a.COUNTRY
ORDER BY u.user_id
