WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
    ),

testing_mail AS (
    SELECT
        email 
        , coalesce (regexp_like(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')= true,false) as is_valid_email_address
    FROM src_users
)

SELECT 
    is_valid_email_address 
FROM testing_mail
WHERE is_valid_email_address='false'