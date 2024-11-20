WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

renamed_casted_orders_costs AS (
    SELECT
          ORDER_ID
        , {{ dbt_utils.generate_surrogate_key(['user_id']) }} AS user_id 
        , CONVERT_TIMEZONE('UTC',created_at) AS created_at_utc
        , ORDER_COST
        , SHIPPING_COST
        , ORDER_TOTAL
        , {{ dbt_utils.generate_surrogate_key(['promo_id']) }} AS promo_id  
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS DATE_LOAD_UTC
        , _FIVETRAN_DELETED AS is_deleted
    FROM src_orders
    )

SELECT * FROM renamed_casted_orders_costs