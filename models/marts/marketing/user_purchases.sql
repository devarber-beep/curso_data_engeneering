{{
  config(
    database='ALUMNO6_DEV_GOLD_DB',
    materialized='table',
    schema='marketing'
  )
}}

WITH orders_costs AS (
    SELECT 
        *
    FROM {{ ref('fact_orders_costs') }}
),
orders_delivery AS (
    SELECT *
    FROM {{ ref('dim_orders_delivery') }}
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
),
dim_orders AS (
    SELECT *
    FROM orders_costs oc
    JOIN orders_delivery od
    ON oc.order_id = od.order_id
)
SELECT 
    u.user_id,
    u.FIRST_NAME,
    u.EMAIL,
    u.PHONE_NUMBER,
    u.CREATED_AT_UTC,
    u.UPDATED_AT_UTC,
    a.ADDRESS_ID,
    a.STATE_ID,
    a.ZIPCODE,
    a.COUNTRY,
    COUNT(DISTINCT o.order_id) AS TOTAL_NUMBER_ORDERS, -- Aquí se usa o.order_id
    SUM(o.order_total) AS TOTAL_ORDER_COST_USD,       -- Aquí se usa o.order_total
    SUM(o.shipping_cost) AS TOTAL_SHIPPING_COST_EU,   -- Aquí se usa o.shipping_cost
    SUM(o.discount_in_eu) AS TOTAL_DISCOUNT_EU,       -- Aquí se usa o.discount_in_eu
    COUNT(o.order_id) AS TOTAL_DIFF_PRODUCTS          -- Aquí se usa o.order_id
FROM users u
LEFT JOIN addresses a
ON u.address_id = a.address_id
LEFT JOIN dim_orders o
ON u.user_id = o.user_id
GROUP BY 
    u.user_id, u.FIRST_NAME, u.EMAIL, u.PHONE_NUMBER, 
    u.CREATED_AT_UTC, u.UPDATED_AT_UTC,
    a.ADDRESS_ID, a.STATE_ID, a.ZIPCODE, a.COUNTRY
ORDER BY u.FIRST_NAME
