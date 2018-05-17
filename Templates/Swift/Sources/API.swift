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

    /// The date formatter used for Date's with format "date-time". See DateDay.dateFormat for "date" format
    /// This is used in the APIClient.jsonDecoder.dateDecodingStrategy. You can edit the strategy after APIClient initialization.
    /// This is also used when encoding parameters
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.Z"
        return formatter
    }()

    {% if info.version %}
    public static let version = "{{ info.version }}"
    {% endif %}
    {% if tags %}

    {% for tag in tags %}
    public enum {{ options.tagPrefix }}{{ tag|upperCamelCase }}{{ options.tagSuffix }} {}
    {% endfor %}

    {% endif %}
}
