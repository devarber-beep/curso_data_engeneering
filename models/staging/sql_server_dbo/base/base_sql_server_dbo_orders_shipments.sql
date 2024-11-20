WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

base_renamed_casted_orders_shippments AS (
    SELECT
          ORDER_ID
        , {{ dbt_utils.generate_surrogate_key(['USER_ID']) }} AS user_id 
        , ADDRESS_ID        
        , CONVERT_TIMEZONE('UTC',created_at) AS created_at_utc
        , STATUS AS delivery_status
        , case
          when tracking_id = '' then null
          else  tracking_id
          end as tracking_id
        ,  {{ dbt_utils.generate_surrogate_key(['SHIPPING_SERVICE']) }} AS shipping_service_id
        , CONVERT_TIMEZONE('UTC', estimated_delivery_at) AS estimated_delivery_at
        , CONVERT_TIMEZONE('UTC', delivered_at) AS delivered_at_utc
        , CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load
        , _FIVETRAN_DELETED AS is_deleted
    FROM src_orders
    )

SELECT * FROM base_renamed_casted_orders_shippments