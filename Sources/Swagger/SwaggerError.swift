import JSONUtilities

public enum SwaggerError: Error {

    case incorrectVersion(String)
    case incorrectArrayDataType(DataType)
    case incorrectArraySchema([String: Any])
}
