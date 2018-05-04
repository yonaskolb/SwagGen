# Change Log

## [2.0.0](https://github.com/yonaskolb/SwagGen/compare/1.2.0...2.0.0)
### Added
- Swift template: added `Codable` support to models #61
- Swift template: added `Equatable` support to models #63
- Swift template: added `mutableModels` option to template #64
- Bundle templates with installation #65
- New `language` argument which defaults to `swift` for now #65
- Default template for language is now used if no template path is specified #65
- Added support for inline anonymous schemas in definitions, body params, and responses #66
- Added `--silent` flag #68
- Added `--verbose` flag #68
- Added `--version` flag #68

### Changes
- Swift template: move sources out of now unnessary subdirectory #62
- Swift template: reorganise template #69
- Update to Swift 4.1
- Updated CLI #68
- Improved error output #68
- Make executable lowercase `swaggen` (breaking on linux) #68
- **BREAKING** generation moved into generate command: `swaggen generate` #68
- **BREAKING** `--spec` has changed to a required parameter: `swaggen generate path_to_spec` #68
- 

### Removed
- **BREAKING** Swift template: models no longer have `init(jsonDictionary: JSONDictionary)` or `encode() -> JSONDictionary` functions #61
- Swift template: removed `JSONUtilities` dependency functions #61

## [1.2.0](https://github.com/yonaskolb/SwagGen/compare/1.1.0...1.2.0)
### Added
- Added `fixedWidthIntegers` option to Swift template. Thanks @martinknabbe
- Added support for response references #58

### Fixed
- Fixed Swift 4.0.2 warnings
- Fixed Brew install

## [1.1.0](https://github.com/yonaskolb/SwagGen/compare/1.0.0...1.1.0)
### Added
- Generate typealias for models with reference and array types #42 thanks @Liquidsoul
- generate typealias for models that only have additional properties

### Fixed
- fixed SPM installation issue

## [1.0.0](https://github.com/yonaskolb/SwagGen/compare/0.6.1...1.0.0)
### Added
- Swift template: decode response on background queue and then call completion on main thread or new `queue` parameter

### Changed
- Updated project to Swift 4 #42
- Updated Swift templates to Swift 4 #42

## [0.6.1](https://github.com/yonaskolb/SwagGen/compare/0.6.0...0.6.1)
### Added
- Homebrew and Make installations
- Enums now also have a raw property to access original json

### Changed
- Requests in Swift template are final

### Fixed
- Fixed parameters with a file type not being generated

## [0.6.0](https://github.com/yonaskolb/SwagGen/compare/0.5.3...0.6.0)
This includes a large rewrite with a lot more test cases so many more specs should be supported

### Added
- Integer, Double and Float enums are now generated
- operation now has `hasFileParam` and `isFile` #27 Thanks @dangthaison91
- `spec.operationsByTag` now also includes operations without tags with an empty string name #28 Thanks @dangthaison91
- Operations now include common parameters defined in the path #29 Thanks @dangthaison91
- Added a bunch of test specs which are now validated against
- Added a script that generates and then compiles all test specs

### Fixed
- Removed symbols from generated filenames
- Generate Floats as `Float` not `Double`
- Fixed some array query parameters not joining their contents with the collectionFormat seperator (uses comma delimeted by default now if none is provided)
- Arrays and dictionaries of enums are now encoded
- Arrays of models are now encoded
- Support for a default response with no schema
- Support for `[String: Any]` responses
- Simple type definitions including enums are generated properly
- Fixed generation of operations without tags
- Enums in responses are now generated
- Overall more solid spec support. For example the whole [fake petstore example](https://github.com/swagger-api/swagger-codegen/issues/5419) now generates and compiles properly

### Changed
- Within templates `tags` is now just a list of all tag names. The previous tag dictionary which contains `name` and `operations` has been moved to `operationsByTag`
- request response enum cases have been renamed

## [0.5.3](https://github.com/yonaskolb/SwagGen/compare/0.5.2...0.5.3)
### Swift template fixes
- fixed not building with Swift Package Manager in certain situations
- fixed array bodies being generated as inline classes
- fix compiler error when operations have no default response
- escape built in Swift Foundation types like Error and Data
- escape filenames in different way to class names

### Swift template changes
- now uses Stencil includes. Paves the way for recursive nested schemas
- changed how operations are decoded. Paves the way for non json responses
- added APIError.name
- made RequestAuthorizer.authorize completed parameter escaping
- add tag to printed request and service descriptions

### Added
Added suite of tests for parsing, generating and compiling templates from a list of specs. Will improve stability and help prevent regressions. Still some work to do in this area

## [0.5.2](https://github.com/yonaskolb/SwagGen/compare/0.5.1...0.5.2)
### Added
- added SuccessType typealias to APIResponseValue. This lets you map from a response to successful value

### Changed
- Replaced `CustomDebugStringConvertible` with `PrettyPrinted` conformance on Models, so you can specify your own `CustomDebugStringConvertible`. Same string is available at `model.prettyPrinted`
- Moved generated request enums and anonymous schema from APIRequest.Request to one level higher in scope


## [0.5.1](https://github.com/yonaskolb/SwagGen/compare/0.5.0...0.5.1)
### Added
- A request's response now has a responseResult with either `.success(SuccessValue)` or `.failure(FailureValue)`. This is only generated if there is a single schema type for successes responses and a single schema type for failure responses

### Changed
- Added back `successType` in response context for backwards compatibility with old templates
- Updated Alamofire to 4.4.0

### Fixed
- Fixed api name not being replaced in `Decoding.swift` anymore

## [0.5.0](https://github.com/yonaskolb/SwagGen/compare/0.4.1...0.5.0)

### Added
- `APIClient.makeRequest` now returns an Alamofire `Request` if one was created, so requests can now be cancelled
- All operation responses are now generated, not just the successful one, meaning you get access to typed errors

### Template Changes

##### Model
- Properties in a model subclass initialiser will now be ordered so that all required properties come first, instead of parent and then child's properties
- Now provides a `CustomDebugStringConvertible` conformance that pretty prints all nested values

##### APIRequest
- Each Request now has a typed `Response` enum that includes all it's responses in the spec. Each case has the decoded schema as an associated enum if specified
- The actual APIRequest subclass now sits at `MyGetOperation.Request`

##### APIClient

The `APIClient.makeRequest` complete closure parameter has changed from `DataResponse` to `APIResponse` which:

- replaces result value with the new response enum
- has result error of APIError enum via [antitypical/Result](https://github.com/antitypical/Result) which has cases for:
	- `unexpectedStatusCode(statusCode: Int, data: Data)`
	- `jsonDeserializationError(JSONUtilsError)`
	- `decodingError(DecodingError)`
	- `invalidBaseURL(String)`
	- `authorizationError(AuthorizationError)`
	- `networkError(Error)`
	- `unknownError(Error)`

##### Descriptions
Models, Requests, Errors and Responses now have CustomStringConvertible and/or CustomDebugStringConvertible conformances

### Fixed
- Path parameters are no longer also encoded as url parameters in the request template


## [0.4.1](https://github.com/yonaskolb/SwagGen/compare/0.4.0...0.4.1)
### Fixed
Improved the generation of complicated specs:

- escape *all* Swift keywords:
- escape and rename invalid characters
- escape symbols starting with numbers
- better support for deeply nested arrays and dictionaries
- fixed nested enums

## [0.4.0](https://github.com/yonaskolb/SwagGen/compare/0.3...0.4)
### Added
- Added generated API Client in Swift template #16
	- monitoring and modification of requests via request behaviours
	- asynchronous authorization of requests
	- central place for api options
	- configurable Alamofire SessionManager
- Models now have support for `additionalProperties` #15
- Swift template is now Swift Package Manager compatible #17
- New `clean` CI arguement for ignoring dot files #18

### Changed
- Names and properties in Swift template are now escaped with \`\` instead of appending `Type`,`Enum` ...etc

### Fixed
- Swift names and types are now escaped with a greater range of swift keywords

## [0.3.0](https://github.com/yonaskolb/SwagGen/compare/0.2...0.3)

### Fixed
- Operations with multiple path variables now properly generate an operationId. #11  Thanks @HSchultjan
- Operation parameters that contain anonymous schemas (those that don't reference a definition schema but define a schema inline) are now genererated properly as nested structs within the APIRequest #13

## [0.2.0](https://github.com/yonaskolb/SwagGen/compare/0.1...0.2)
### Added
- `Operation`, `Definition`, `Property` and `Parameter`, now have a `raw` property that can be accessed from templates. This represents the raw data that was in the original spec. This lets you access any custom properties you have in your spec

### Changed
- `Property` and `Parameter` have lost their `rawType` and `rawName` properties in favour of the above, so they are now `raw.type` and `raw.name`
- Upgraded Stencil to [0.9](https://github.com/kylef/Stencil/releases/tag/0.9.0)

## 0.1.0
- First official release
