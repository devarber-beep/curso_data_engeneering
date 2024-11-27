{{
  config(
    database='ALUMNO6_DEV_GOLD_DB',
    materialized='table',
    schema='core'
  )
}}

with stg_event_types as (
    select * from {{ ref('stg_sql_server_dbo__event_types') }}
)

SELECT 
    {{ dbt_utils.star(from=ref('stg_sql_server_dbo__events'), except=['_fivetran_deleted', 'event_type_id']) }},
    et.name
FROM 
    {{ ref('stg_sql_server_dbo__events') }} e
left union stg_event_types et
on e.event_type_id = et.event_type_id
WHERE 
    _fivetran_deleted IS NULL