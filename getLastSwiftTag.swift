// GitHubTagElement.swift

import Foundation
import Version  // mrackwitz/Version

extension String : Error, LocalizedError {
  public var errorDescription: String? { get { self } }
}

extension Sequence {
  func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
    return sorted { a, b in
      return a[keyPath: keyPath] < b[keyPath: keyPath]
    }
  }
}

// MARK: - GitHubTagElement
public struct GitHubTagElement: Equatable, Codable {
  public let ref: String?
  public let nodeid: String?
  public let url: String?
  public let object: Commit?
  public var name: String {
    get { ref!.replacingOccurrences(of: "refs/tags/swift-", with: "") }
  }
  public var tagName: String {
    get { ref!.replacingOccurrences(of: "refs/tags/", with: "") }
  }
  public var version: Version {
    get {
      var nName = name.replacingOccurrences(of: "-RELEASE", with: "")
      return Version(nName)!
    }
  }
}

extension GitHubTagElement: Comparable {
  public static func < (lhs: GitHubTagElement, rhs: GitHubTagElement) -> Bool {
    return lhs.version < rhs.version
  }

  public static func > (lhs: GitHubTagElement, rhs: GitHubTagElement) -> Bool {
    return lhs.version > rhs.version
  }
}

// MARK: - Commit
public struct Commit: Equatable, Codable {
  public let sha: String?
  public let type: String?
  public let url: String?

}

func getTags(_ repo: String, _ releaseFilter: String, completion: @escaping (Result<String, Error>) -> ()) throws {
  guard let url = URL(string: "https://api.github.com/repos/\(repo)/git/refs/tags") else {
    throw ("Failed to generated URL")
  }
  let decoder = JSONDecoder()
  decoder.keyDecodingStrategy = .convertFromSnakeCase
  let semaphore = DispatchSemaphore(value: 0)
  let dataTask = URLSession.shared.dataTask(with: url) { (data, resp, err) in
    defer { semaphore.signal() }
    if err != nil { completion(.failure(err!)); return }
    guard let unwrapData = data else { completion(.failure("Data is invalid")); return }
    do {
      let tagElements = try decoder.decode([GitHubTagElement].self, from: unwrapData)
      let releases = tagElements.filter { $0.name.contains(releaseFilter) ?? false }
      let sortedReleases = releases.sorted(by: \.version)
      guard let name = sortedReleases.last?.tagName else { completion(.failure("No release found")); return }
      completion(.success(name))
    }
    catch {
      completion(.failure(error));
      return
    }
  }
  dataTask.resume()
  _ = semaphore.wait(timeout: .distantFuture)
}

func main(_ args: [String]) {
  if args.count != 3 {
    print("Bad number of argument. $>./getLastSwiftTag.swift \"apple/swift\" \"-RELEASE\"");
    exit(EXIT_FAILURE)
  }
  do {
    try getTags(args[1], args[2]) { result in
      switch result {
      case .success(let version):
        print(version)
      case .failure(let err):
        print(err)
        exit(EXIT_FAILURE)
      }
    }
  }
  catch {
    print(error.localizedDescription);
    exit(EXIT_FAILURE)
  }
}

main(CommandLine.arguments)
