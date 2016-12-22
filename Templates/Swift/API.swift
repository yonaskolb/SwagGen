
{% if info.description %}
/** {{ info.description }} */
{% endif %}
public struct {{ options.name }} {

    public static var dateEncodingFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    public static var baseURL = "{{ baseURL }}"
    {% if tags %}

    {% for tag in tags %}
    public struct {{ options.tagPrefix }}{{ tag.name|upperCamelCase }}{{ options.tagSuffix }} {}
    {% endfor %}

    {% endif %}
}
