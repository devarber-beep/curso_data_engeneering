WITH BASE_DATE AS(
    SELECT * FROM (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2024-01-01' as date)",
        end_date="cast('2025-12-31' as date)"
    )
    }}
    )
)

SELECT 
    DATE_DAY as date_id                  -- Id de la fecha ¿sirve en formato timestamp?
    , year (DATE_DAY) as year            -- Año
    , month(DATE_DAY) as month_number    -- Mes (número)
    , to_char(DATE_DAY, 'Month') as month_name  -- Mes (nombre)
    , day(DATE_DAY) as day_of_month      -- Día del mes
    , case 
        when dayofweek(DATE_DAY) = 0 then 7
        else dayofweek(DATE_DAY)
    end as weekday_number                -- Día de la semana (1 = Lunes, 7 = Domingo)
    , dayname(DATE_DAY) as weekday_name  -- Día de la semana (nombre)
    , quarter(DATE_DAY) as quarter       -- Trimestre (1-4)
    , case
        when month(DATE_DAY) in (1, 2, 3, 4) then 1  -- Cuatrimestre 1
        when month(DATE_DAY) in (5, 6, 7, 8) then 2  -- Cuatrimestre 2
        when month(DATE_DAY) in (9, 10, 11, 12) then 3  -- Cuatrimestre 3
    end as quatrimester  -- Cuatrimestre (1-3)

    , case
        when month(DATE_DAY) in (1, 2, 3, 4, 5, 6) then 1  -- Semestre 1
        when month(DATE_DAY) in (7, 8, 9, 10, 11, 12) then 2  -- Semestre 2
    end as semester  -- Semestre (1-2)

    , case 
        when dayofweek(DATE_DAY) in (1, 2, 3, 4, 5) then 'Weekday'
        else 'Weekend'
    end as day_type  -- Tipo de día (fin de semana o día de semana)

from BASE_DATE