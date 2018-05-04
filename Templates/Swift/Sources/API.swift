{% include "Includes/Header.stencil" %}

import Foundation

{% if info.description %}
/** {{ info.description }} */
{% endif %}
public struct {{ options.name }} {

    /// Whether to discard any errors when decoding optional properties
    public static var safeOptionalDecoding = {% if options.safeOptionalDecoding %}true{% else %}false{% endif %}

     /// Whether to remove invalid elements instead of throwing when decoding arrays
    public static var safeArrayDecoding = {% if options.safeArrayDecoding %}true{% else %}false{% endif %}

    {% if info.version %}
    public static let version = "{{ info.version }}"
    {% endif %}
    {% if tags %}

    {% for tag in tags %}
    public enum {{ options.tagPrefix }}{{ tag|upperCamelCase }}{{ options.tagSuffix }} {}
    {% endfor %}

    {% endif %}
}
