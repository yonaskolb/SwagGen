import JSONUtilities

{% if description %}
/** {{ description }} */
{% endif %}
public class {{ formattedName }}: {% if parent %}{{ parent.formattedName }}{% else %}JSONDecodable, JSONEncodable{% endif %} {
    {% for enum in enums %}

    {% if enum.description %}
    /** {{ enum.description }}  */
    {% endif %}
    public enum {{ enum.enumName }}: String {
        {% for enumCase in enum.enums %}
        case {{ enumCase.name }} = "{{ enumCase.value }}"
        {% endfor %}
    }
    {% endfor %}
    {% for property in properties %}

    {% if property.description %}
    /** {{ property.description }}  */
    {% endif %}
    public var {{ property.name }}: {{ property.optionalType }}
    {% endfor %}

    public init({% for property in allProperties %}{{ property.name }}: {{ property.optionalType }}{% ifnot property.required %} = nil{% endif %}{% ifnot forloop.last %}, {% endif %}{% endfor %}) {
        {% for property in properties %}
        self.{{ property.name }} = {{ property.name }}
        {% endfor %}
        {% if parent %}
        super.init({% for property in parent.properties %}{{ property.name }}: {{ property.name }}{% ifnot forloop.last %}, {% endif %}{% endfor %})
        {% endif %}
    }

    public required init(jsonDictionary: JSONDictionary) throws {
        {% for property in properties %}
        {{property.name}} = {% if property.required %}try {% endif %}jsonDictionary.json(atKeyPath: "{{property.value}}")
        {% endfor %}
        {% if parent %}
        try super.init(jsonDictionary: jsonDictionary)
        {% endif %}
    }

    public {% if parent %}override {% endif %}func encode() -> JSONDictionary {
        var dictionary: JSONDictionary = [:]
        {% for property in properties %}
        {% if property.optional %}
        if let {{ property.name }} = {{ property.encodedValue }} {
            dictionary["{{ property.value }}"] = {{ property.name }}
        }
        {% else %}
        dictionary["{{ property.value }}"] = {{ property.encodedValue }}
        {% endif %}
        {% endfor %}
        {% if parent %}
        let superDictionary = super.encode()
        for (key, value) in superDictionary {
            dictionary["key"] = value
        }
        {% endif %}
        return dictionary
    }
}
