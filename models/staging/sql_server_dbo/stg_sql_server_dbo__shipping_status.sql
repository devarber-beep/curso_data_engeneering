-- AQUI QUIERO enlazar LAS DESCRIPCIONES DE SHIPPING status CON SUS ID. ESTO SERA UNA DIMENSION EN GOLD

with 

base as (

    select * from {{ ref('base_sql_server_dbo__orders_') }}

),

shipping_status_list as (

    select
        DISTINCT(shipping_status),
        shipping_status_id

    from base

)

select * from shipping_status_list