-- esta tabla es interesante para simplificar las consultas despues de la tabla promo
select 
    0 AS status_id,
    'Inactive' AS status_name
UNION ALL
select 
    1 AS status_id,
    'Active' AS status_name