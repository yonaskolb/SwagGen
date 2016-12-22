
// This is a list of global enums used in requests
{% for enum in enums %}

{% if enum.description %}
/** {{ enum.description }}  */
{% endif %}
public enum {{enum.enumName}}: String {
    {% for enumCase in enum.enums %}
    case {{enumCase.name}} = "{{enumCase.value}}"
    {% endfor %}
}
{% endfor %}
