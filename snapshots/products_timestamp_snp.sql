{% snapshot products_check_snp %}

{{
    config(
        strategy='check',
        unique_key='product_id',
        check_cols=['product_name', 'product_price'],
        invalidate_hard_deletes=True,
        target_schema='snapshots'
    )
}}

with products as (
    select 
        product_id,
        name,
        price,
        date_load

    
    from {{ ref('stg_sql_server_dbo__products') }}
)

select * from products

{% endsnapshot %}