{% test relation_values_not_void(model, column_name) %}

   WITH filtered_events AS (
    SELECT
        {{ column_name }}  --order_id
    FROM {{ model }}
    WHERE order_id IS NOT NULL
),
missing_orders AS (
    SELECT
        fe.event_id
    FROM filtered_events fe
    LEFT JOIN ALUMNO6_DEV_BRONZE_DB.SQL_SERVER_DBO.events o
    ON fe.order_id = o.order_id
    WHERE o.order_id IS NULL
)

SELECT COUNT(*) AS error_count
FROM missing_orders;

{% endtest %}