import JSONUtilities

extension {{ options.name }}{% if tag %}.{{ options.tagPrefix }}{{ tag|upperCamelCase }}{{ options.tagSuffix }}{% endif %} {

    {% if description %}
    /** {{ description }} */
    {% endif %}
    public class {{ operationId|upperCamelCase }}: APIRequest<{{successType|default:"Void"}}> {

        public static let service = APIService<{{successType|default:"Void"}}>(id: "{{ operationId }}", tag: "{{ tag }}", method: "{{ method|uppercase }}", path: "{{ path }}", hasBody: {% if hasBody %}true{% else %}false{% endif %}{% if security %}, authorization: Authorization(type: "{{ security.name }}", scope: "{{ security.scope }}"){% endif %}) { {% if successType %}json{% else %}_{% endif %} in
            {% if successType %}
            try JSONDecoder.decode(json: json)
            {% endif %}
        }
        {% for enum in enums %}

        public enum {{enum.enumName}}: String {
            {% for enumCase in enum.enums %}
            case {{enumCase.name}} = "{{enumCase.value}}"
            {% endfor %}
        }
        {% endfor %}
        {% if nonBodyParams %}

        public struct Params {
            {% for param in nonBodyParams %}
            public var {{ param.formattedName }}: {{ param.optionalType }}
            {% endfor %}
        }

        public var params: Params

        {% endif %}
        {% if bodyParam %}

        public var body: {{bodyParam.optionalType}}
        {% endif %}

        public init({% if bodyParam %}_ {{ bodyParam.formattedName}}: {{ bodyParam.optionalType }}{% if nonBodyParams %}, {% endif %}{% endif %}{% if nonBodyParams %}_ params: Params{% endif %}) {
            {% if bodyParam %}
            self.body = {{ bodyParam.formattedName}}
            {% endif %}
            {% if nonBodyParams %}
            self.params = params
            {% endif %}
            super.init(service: {{ operationId|upperCamelCase }}.service)
        }
        {% if nonBodyParams %}

        public convenience init({% for param in params %}{{ param.formattedName }}: {{ param.optionalType }}{% ifnot param.required %} = nil{% endif %}{% ifnot forloop.last %}, {% endif %}{% endfor %}) {
            {% if nonBodyParams %}
            let params = Params({% for param in nonBodyParams %}{{param.formattedName}}: {{param.formattedName}}{% ifnot forloop.last %}, {% endif %}{% endfor %})
            {% endif %}
            self.init({% if bodyParam %}{{ bodyParam.formattedName}}{% if nonBodyParams %}, {% endif %}{% endif %}{% if nonBodyParams %}params{% endif %})
        }
        {% endif %}
        {% if pathParams %}

        public override var path: String {
            return super.path{% for param in pathParams %}.replacingOccurrences(of: "{{ param.name }}", with: "\(self.params.{{ param.encodedValue }})"){% endfor %}
        }
        {% endif %}

        public override var parameters: [String: Any] {
            {% if bodyParam %}
            return {{ bodyParam.encodedValue }}
            {% endif %}
            {% if nonBodyParams %}
            var params: JSONDictionary = [:]
            {% for param in nonBodyParams %}
            {% if param.optional %}
            if let {{ param.formattedName }} = self.params.{{ param.encodedValue }} {
              params["{{ param.value }}"] = {{ param.formattedName }}
            }
            {% else %}
            params["{{ param.value }}"] = self.params.{{ param.encodedValue }}
            {% endif %}
            {% endfor %}
            return params
            {% endif %}
            {% if not bodyParam and not nonBodyParams  %}
            return [:]
            {% endif %}
        }
    }
}
