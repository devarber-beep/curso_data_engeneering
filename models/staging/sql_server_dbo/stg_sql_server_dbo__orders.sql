{{
  config(
    materialized='view',
    schema="staging"
  )
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

renamed_casted AS (
    SELECT
        order_id,
        case
          when shipping_service = '' then null
          else  shipping_service
        end as shipping_service,
        shipping_cost,
        address_id,
        {{ dbt_date.convert_timezone('created_at', 'GMT', 'UTC') }} AS created_at_utc,
        case
          when tracking_id = '' then null
          else  {{ dbt_utils.generate_surrogate_key(['PROMO_ID']) }} --dato sensible
          end as promo_id, -- relationship
        {{ dbt_date.convert_timezone('estimated_delivery_at', 'GMT', 'UTC') }} AS estimated_delivery_at_utc,
        order_cost, -- es calculado y debe ser comprobado
        user_id, --relationship
        order_total,
        {{ dbt_date.convert_timezone('delivered_at', 'GMT', 'UTC') }} AS delivered_at_utc,
         case
          when tracking_id = '' then null
          else  tracking_id
          end as tracking_id,
        status,
          _fivetran_deleted,
          _fivetran_synced AS date_load
    FROM src_orders
    WHERE _FIVETRAN_DELETED is null
    )

SELECT * FROM renamed_casted


/*
WITH base_orders_costs AS (
    SELECT * 
    FROM {{ ref('BASE_SQL_SREVER_DBO__ORDERS_COSTS') }}
    ),

base_orders_shipments AS (
    SELECT * 
    FROM {{ ref('BASE_SQL_SREVER_DBO__ORDERS_SHIPMENTS') }}
    ),

renamed_casted_orders AS (
    SELECT
          A.ORDER_ID
        , A.USER_ID 
        , A.CREATED_AT_UTC
        , ORDER_COST
        , ORDER_TOTAL
        , PROMO_ID     
        , ADDRESS_ID
        , TRACKING_ID
        , SHIPPING_SERVICE_ID
        , SHIPPING_COST
        , ESTIMATED_DELIVERY_AT_UTC
        , DELIVERY_STATUS
        , DELIVERED_AT_UTC
        , A.DATE_LOAD_UTC
        , A.is_deleted
    FROM base_orders_costs A
    JOIN base_orders_shipments B
        ON A.ORDER_ID=B.ORDER_ID
    )

SELECT * FROM renamed_casted_orders
*/