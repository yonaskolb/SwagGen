{% include "Includes/Header.stencil" %}

import Foundation

public class APIRequest<ResponseType: APIResponseValue> {

    public let service: APIService<ResponseType>
    public private(set) var queryParameters: [String: Any]
    public private(set) var formParameters: [String: Any]
    public let encodeBody: ((RequestEncoder) throws -> Data)?
    private(set) var headerParameters: [String: String]
    public var customHeaders: [String: String] = [:]

    public var headers: [String: String] {
        return headerParameters.merging(customHeaders) { param, custom in return custom }
    }

    public var path: String {
        return service.path
    }

    public init(service: APIService<ResponseType>, 
                queryParameters: [String: Any] = [:], 
                formParameters: [String: Any] = [:],
                headers: [String: String] = [:], 
                encodeBody: ((RequestEncoder) throws -> Data)? = nil) {
        self.service = service
        self.queryParameters = queryParameters
        self.formParameters = formParameters
        self.headerParameters = headers
        self.encodeBody = encodeBody
    }
}

extension APIRequest: CustomStringConvertible {

    public var description: String {
        var string = "\(service.name): \(service.method) \(path)"
        if !queryParameters.isEmpty {
            string += "?" + queryParameters.map {"\($0)=\($1)"}.joined(separator: "&")
        }
        return string
    }
}

extension APIRequest: CustomDebugStringConvertible {

    public var debugDescription: String {
        var string = description
        if let encodeBody = encodeBody,
            let data = try? encodeBody(JSONEncoder()),
            let bodyString = String(data: data, encoding: .utf8) {
            string += "\nbody: \(bodyString)"
        }
        return string
    }
}

/// A file upload
public struct UploadFile: Equatable {

    public let type: FileType
    public let fileName: String?
    public let mimeType: String?

    public init(type: FileType) {
        self.type = type
        self.fileName = nil
        self.mimeType = nil
    }

    public init(type: FileType, fileName: String, mimeType: String) {
        self.type = type
        self.fileName = fileName
        self.mimeType = mimeType
    }

    public enum FileType: Equatable {
        case data(Data)
        case url(URL)
    }

    func encode() -> Any {
        return self
    }
}
