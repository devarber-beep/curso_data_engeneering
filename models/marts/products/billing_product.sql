{{
  config(
    database='ALUMNO6_DEV_GOLD_DB',
    materialized='table',
    schema='products'
  )
}}

WITH ORDER_TOTALS AS (
    -- Calcular el costo total del pedido ajustado por la promoción
    SELECT
        foc.ORDER_ID,
        foc.ORDER_TOTAL, -- Total original del pedido
        COALESCE(foc.PROMO_ID, 0) AS PROMO_ID,
        COALESCE(dp.DISCOUNT_IN_EU, 0) AS DISCOUNT,
        foc.ORDER_TOTAL - COALESCE(dp.DISCOUNT_IN_EU, 0) AS ADJUSTED_TOTAL -- Total ajustado
    FROM {{ ref("fact_orders_costs") }} foc
    LEFT JOIN {{ ref("dim_promos") }} dp
        ON foc.PROMO_ID = dp.PROMO_ID
),
PRODUCT_SALES AS (
    -- Calcular el ingreso proporcional por producto en base al descuento a nivel de pedido
    SELECT
        foi.PRODUCT_ID,
        foi.ORDER_ID,
        foi.QUANTITY,
        dp.PRICE,
        ot.ADJUSTED_TOTAL,
        ot.ORDER_TOTAL,
        ((foi.QUANTITY * dp.PRICE) / ot.ORDER_TOTAL) * ot.ADJUSTED_TOTAL AS TOTAL_REVENUE
    FROM {{ ref("fact_order_items") }} foi
    JOIN {{ ref("dim_products") }} dp
        ON foi.PRODUCT_ID = dp.PRODUCT_ID
    JOIN ORDER_TOTALS ot        -- Primera Tabla de hechos
        ON foi.ORDER_ID = ot.ORDER_ID
)

SELECT
    PRODUCT_ID,
    SUM(TOTAL_REVENUE) AS TOTAL_REVENUE
FROM PRODUCT_SALES
GROUP BY PRODUCT_ID
ORDER BY TOTAL_REVENUE DESC