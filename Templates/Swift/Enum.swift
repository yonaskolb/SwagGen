
{% if description %}
/** {{ description }}  */
{% endif %}
public enum {{enumName}}: String {
    {% for enumCase in enums %}
    case {{enumCase.name}} = "{{enumCase.value}}"
    {% endfor %}
}
