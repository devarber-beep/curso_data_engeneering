{% test relation_values_not_void(base_model, base_column, reference_model, reference_column) %}

WITH filtered_values AS (
    SELECT
        {{ base_column }}
    FROM {{ base_model }}
    WHERE {{ base_column }} IS NOT NULL
),
missing_values AS (
    SELECT
        fv.{{ base_column }}
    FROM filtered_values fv
    LEFT JOIN {{ reference_model }} rm
    ON fv.{{ base_column }} = rm.{{ reference_column }}
    WHERE rm.{{ reference_column }} IS NULL
)

SELECT COUNT(*) AS error_count
FROM missing_values;

{% endtest %}