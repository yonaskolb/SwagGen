import Foundation

func writeError(_ string: String) {
    writeMessage(string, to: .standardError)
}

func writeMessage(_ string: String, to fileHandle: FileHandle = .standardOutput) {
    if let data = "\(string)\n".data(using: String.Encoding.utf8) {
        fileHandle.write(data)
    }
}
