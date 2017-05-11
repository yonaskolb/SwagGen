import Foundation
import Rainbow

public func writeError(_ string: String) {
    writeMessage(string.red, to: .standardError)
}

public func writeMessage(_ string: String, to fileHandle: FileHandle = .standardOutput) {
    if let data = "\(string)\n".data(using: String.Encoding.utf8) {
        fileHandle.write(data)
    }
}
