{% macro encrypt_field(field, key) %}
    ENCRYPT({{ field }}, '{{ key }}', 'AES')
{% endmacro %}