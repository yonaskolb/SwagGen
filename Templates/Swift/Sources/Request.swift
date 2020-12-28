{% include "Includes/Header.stencil" %}

import Foundation

extension {{ options.name }}{% if tag %}.{{ options.tagPrefix }}{{ tag|upperCamelCase }}{{ options.tagSuffix }}{% endif %} {

    {% if description and summary %}
    {% if description == summary %}
    /** {{ description }} */
    {% else %}
    /**
    {{ summary }}

    {{ description }}
    */
    {% endif %}
    {% else %}
    {% if description %}
    /** {{ description }} */
    {% endif %}
    {% if summary %}
    /** {{ summary }} */
    {% endif %}
    {% endif %}
    public enum {{ type }} {

        public static let service = APIService<Response>(id: "{{ operationId }}", tag: "{{ tag }}", method: "{{ method|uppercase }}", path: "{{ path }}", hasBody: {% if hasBody %}true{% else %}false{% endif %}{% if isUpload %}, isUpload: true{% endif %}, securityRequirements: [{% for securityRequirement in securityRequirements %}SecurityRequirement(type: "{{ securityRequirement.name }}", scopes: [{% for scope in securityRequirement.scopes %}"{{ scope }}"{% ifnot forloop.last %}, {% endif %}{% endfor %}]){% ifnot forloop.last %}, {% endif %}{% endfor %}])
        {% for enum in requestEnums %}
        {% if not enum.isGlobal %}

        {% filter indent:8 %}{% include "Includes/Enum.stencil" enum %}{% endfilter %}
        {% endif %}
        {% endfor %}

        public final class Request: APIRequest<Response> {
            {% for schema in requestSchemas %}

            {% filter indent:12 %}{% include "Includes/Model.stencil" schema %}{% endfilter %}
            {% endfor %}
            {% if nonBodyParams %}

            public struct Options {
                {% for param in nonBodyParams %}

                {% if param.description %}
                /** {{ param.description }} */
                {% endif %}
                public var {{ param.name }}: {{ param.optionalType }}
                {% endfor %}

                public init({% for param in nonBodyParams %}{{param.name}}: {{param.optionalType}}{% ifnot param.required %} = nil{% endif %}{% ifnot forloop.last %}, {% endif %}{% endfor %}) {
                    {% for param in nonBodyParams %}
                    self.{{param.name}} = {{param.name}}
                    {% endfor %}
                }
            }

            public var options: Options
            {% endif %}
            {% if body %}

            public var {{ body.name}}: {{body.optionalType}}
            {% endif %}

            public init({% if body %}{{ body.name}}: {{ body.optionalType }}{% if nonBodyParams %}, {% endif %}{% endif %}{% if nonBodyParams %}options: Options{% endif %}{% if body %}, encoder: RequestEncoder? = nil{% endif %}) {
                {% if body %}
                self.{{ body.name}} = {{ body.name}}
                {% endif %}
                {% if nonBodyParams %}
                self.options = options
                {% endif %}
                super.init(service: {{ type }}.service){% if body %} { defaultEncoder in
                    return try (encoder ?? defaultEncoder).encode({% if body.isAnyType %}AnyCodable({{ body.name }}).value{% else %}{{ body.name }}{% endif %})
                }{% endif %}
            }
            {% if nonBodyParams %}

            /// convenience initialiser so an Option doesn't have to be created
            public convenience init({% for param in nonBodyParams %}{{ param.name }}: {{ param.optionalType }}{% ifnot param.required %} = nil{% endif %}{% ifnot forloop.last %}, {% endif %}{% endfor %}{% if nonBodyParams and body %}, {% endif %}{% if body %}{{ body.name}}: {{ body.optionalType}}{% ifnot body.required %} = nil{% endif %}{% endif %}) {
                {% if nonBodyParams %}
                let options = Options({% for param in nonBodyParams %}{{param.name}}: {{param.name}}{% ifnot forloop.last %}, {% endif %}{% endfor %})
                {% endif %}
                self.init({% if body %}{{ body.name}}: {{ body.name}}{% if nonBodyParams %}, {% endif %}{% endif %}{% if nonBodyParams %}options: options{% endif %})
            }
            {% endif %}
            {% if pathParams %}

            public override var path: String {
                return super.path{% for param in pathParams %}.replacingOccurrences(of: "{" + "{{ param.value }}" + "}", with: "\(self.options.{{ param.encodedValue }})"){% endfor %}
            }
            {% endif %}
            {% if queryParams %}

            public override var queryParameters: [String: Any] {
                var params: [String: Any] = [:]
                {% for param in queryParams %}
                {% if param.optional %}
                if let {{ param.name }} = options.{{ param.encodedValue }} {
                  params["{{ param.value }}"] = {{ param.name }}
                }
                {% else %}
                params["{{ param.value }}"] = options.{{ param.encodedValue }}
                {% endif %}
                {% endfor %}
                return params
            }
            {% endif %}
            {% if formProperties %}

            public override var formParameters: [String: Any] {
                var params: [String: Any] = [:]
                {% for param in formProperties %}
                {% if param.optional %}
                if let {{ param.name }} = options.{{ param.encodedValue }} {
                  params["{{ param.value }}"] = {{ param.name }}
                }
                {% else %}
                params["{{ param.value }}"] = options.{{ param.encodedValue }}
                {% endif %}
                {% endfor %}
                return params
            }
            {% endif %}
            {% if headerParams %}

            override var headerParameters: [String: String] {
                var headers: [String: String] = [:]
                {% for param in headerParams %}
                {% if param.optional %}
                if let {{ param.name }} = options.{{ param.encodedValue }} {
                  headers["{{ param.value }}"] = {% if param.type == "String" %}{{ param.name }}{% else %}String(describing: {{ param.name }}){% endif %}
                }
                {% else %}
                headers["{{ param.value }}"] = {% if param.type == "String" %}options.{{ param.encodedValue }}{% else %}String(describing: options.{{ param.encodedValue }}){% endif %}
                {% endif %}
                {% endfor %}
                return headers
            }
            {% endif %}
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            {% for schema in responseSchemas %}

            {% filter indent:12 %}{% include "Includes/Model.stencil" schema %}{% endfilter %}
            {% endfor %}
            {% for enum in responseEnums %}
            {% if not enum.isGlobal %}

            {% filter indent:12 %}{% include "Includes/Enum.stencil" enum %}{% endfilter %}
            {% endif %}
            {% endfor %}
            public typealias SuccessType = {{ successType|default:"Void"}}
            {% for response in responses %}
            {% if response.description %}

            /** {{ response.description }} */
            {% endif %}
            {% if response.statusCode %}
            case {{ response.name }}{% if response.type %}({{ response.type }}){% endif %}
            {% else %}
            case {{ response.name }}(statusCode: Int{% if response.type %}, {{ response.type }}{% endif %})
            {% endif %}
            {% endfor %}

            public var success: {{ successType|default:"Void"}}? {
                switch self {
                {% for response in responses where response.type == successType and response.success %}
                {% if response.type %}
                case .{{ response.name }}({% if not response.statusCode %}_, {% endif %}let response): return response
                {% else %}
                case .{{ response.name }}: return ()
                {% endif %}
                {% endfor %}
                {% if not onlySuccessResponses %}
                default: return nil
                {% endif %}
                }
            }
            {% if singleFailureType %}

            public var failure: {{ singleFailureType }}? {
                switch self {
                {% for response in responses where response.type == singleFailureType and not response.success %}
                case .{{ response.name }}({% if not response.statusCode %}_, {% endif %}let response): return response
                {% endfor %}
                default: return nil
                }
            }

            /// either success or failure value. Success is anything in the 200..<300 status code range
            public var responseResult: APIResponseResult<{{ successType|default:"Void"}}, {{ singleFailureType }}> {
                if let successValue = success {
                    return .success(successValue)
                } else if let failureValue = failure {
                    return .failure(failureValue)
                } else {
                    fatalError("Response does not have success or failure response")
                }
            }
            {% endif %}

            public var response: Any {
                switch self {
                {% for response in responses where response.type %}
                case .{{ response.name }}({% if not response.statusCode %}_, {% endif %}let response): return response
                {% endfor %}
                {% if not alwaysHasResponseType %}
                default: return ()
                {% endif %}
                }
            }

            public var statusCode: Int {
                switch self {
                {% for response in responses %}
                {% if response.statusCode %}
                case .{{ response.name }}: return {{ response.statusCode }}
                {% else %}
                case .{{ response.name }}(let statusCode{% if response.type %}, _{% endif %}): return statusCode
                {% endif %}
                {% endfor %}
                }
            }

            public var successful: Bool {
                switch self {
                {% for response in responses %}
                case .{{ response.name }}: return {{ response.success }}
                {% endfor %}
                }
            }

            public init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws {
                {% if hasResponseModels %}
                {% endif %}
                switch statusCode {
                {% for response in responses where response.statusCode %}
                {% if response.type %}
                {% if response.type == "File" %}
                case {{ response.statusCode }}: self = try .{{ response.name }}(data)
                {% else %}
                case {{ response.statusCode }}: self = try .{{ response.name }}(decoder.decode{% if response.isAnyType %}Any{% endif %}({{ response.type }}.self, from: data))
                {% endif %}
                {% else %}
                case {{ response.statusCode }}: self = .{{ response.name }}
                {% endif %}
                {% endfor %}
                {% if defaultResponse %}
                {% if defaultResponse.type %}
                default: self = try .{{ defaultResponse.name }}(statusCode: statusCode, decoder.decode{% if response.isAnyType %}Any{% endif %}({{ defaultResponse.type }}.self, from: data))
                {% else %}
                default: self = .{{ defaultResponse.name }}(statusCode: statusCode)
                {% endif %}
                {% else %}
                default: throw APIClientError.unexpectedStatusCode(statusCode: statusCode, data: data)
                {% endif %}
                }
            }

            public var description: String {
                return "\(statusCode) \(successful ? "success" : "failure")"
            }

            public var debugDescription: String {
                var string = description
                let responseString = "\(response)"
                if responseString != "()" {
                    string += "\n\(responseString)"
                }
                return string
            }
        }
    }
}
