{% snapshot promos_timestamp_snp %}

{{
    config(
      unique_key='promo_id',
      strategy='timestamp',
      updated_at='_fivetran_synced',
      invalidate_hard_deletes=True,
      target_schema='snapshots',
    )
}}

with promos as (
    select
       {{ dbt_utils.generate_surrogate_key(['PROMO_ID']) }} as promo_id,
        promo_id as name,
        status,
        discount_in_eu,
        _fivetran_deleted,
        _fivetran_synced 
        from {{ ref('base_sql_server_dbo__promos') }} where _fivetran_deleted = false or _fivetran_deleted is null
)

select * from promos

{% endsnapshot %}