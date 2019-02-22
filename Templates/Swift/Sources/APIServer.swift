{% include "Includes/Header.stencil" %}

import Foundation

{% if servers %}
enum APIServer {
    {% for server in servers %}
    {% if server.description %}
    /** {{ server.description }} **/
    {% endif %}
    {% if server.variables %}
    static func {{ server.name }}({% for variable in server.variables %}{{ variable.name }}: String = "{{ variable.defaultValue}}"{% ifnot forloop.last %}, {% endif %}{% endfor %}) -> String {
        var url = "{{ server.url }}"
        {% for variable in server.variables %}
        url = url.replacingOccurrences(of: "{\({{variable.name}})}", with: {{variable.name}})
        {% endfor %}
        return url
    }
    {% else %}
    static let {{ server.name }} = "{{ server.url }}"
    {% endif %}
    {% endfor %}
}
{% else %}
// No servers defined in swagger. Documentation for adding them: https://swagger.io/specification/#schema
{% endif %}
