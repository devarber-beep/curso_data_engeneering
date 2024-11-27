{% macro decrypt_field(field, key) %}
    TO_CHAR(
        DECRYPT({{ field }}, '{{ key }}', 'AES'),
        'UTF-8'
    )
{% endmacro %}
