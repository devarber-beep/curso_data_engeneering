{{
  config(
    database='ALUMNO6_DEV_GOLD_DB',
    materialized='table',
    schema='analytics'
  )
}}


SELECT
    foi.ORDER_ID,
    SUM(foi.QUANTITY * dp.PRICE - p.DISCOUNT_IN_EU) AS ITEM_TOTAL_REVENUE,
    foc.ORDER_TOTAL AS ORDER_REVENUE,
    foc.SHIPPING_COST,
    foc.ORDER_COST,
FROM {{ ref('fact_order_items') }} foi
JOIN {{ ref('dim_products') }} dp ON foi.PRODUCT_ID = dp.PRODUCT_ID
LEFT JOIN {{ ref('fact_orders_costs') }} foc ON foi.ORDER_ID = foc.ORDER_ID
LEFT JOIN {{ ref('dim_promos') }} p ON foc.PROMO_ID = p.PROMO_ID
GROUP BY foi.ORDER_ID, foc.ORDER_TOTAL, foc.SHIPPING_COST, foc.ORDER_COST
