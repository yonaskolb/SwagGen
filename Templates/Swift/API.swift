{% include "Includes/Header.stencil" %}

import Foundation

{% if info.description %}
/** {{ info.description }} */
{% endif %}
public struct {{ options.name }} {

    /// change this if your api has a different date encoding format
    public static var dateEncodingFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    {% if info.version %}
    public static let version = "{{ info.version }}"
    {% endif %}
    {% if tags %}

    {% for tag in tags %}
    public enum {{ options.tagPrefix }}{{ tag|upperCamelCase }}{{ options.tagSuffix }} {}
    {% endfor %}

    {% endif %}
}
