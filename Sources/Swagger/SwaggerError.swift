import JSONUtilities

public enum SwaggerError: Error {

    case incorrectVersion(String)
    case incorrectItemType(JSONDictionary)
    case incorrectSchemaType(JSONDictionary)
    case incorrectArraySchema([String: Any])
}
