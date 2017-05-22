# Change Log

## [0.5.3] - 2017-05-22
### Swift template fixes
- fixed not building with Swift Package Manager in certain situations
- fixed array bodies being generated as inline classes
- fix compiler error when operations have no default response
- escape built in Swift Foundation types like Error and Data
- escape filenames in different way to class names

### Swift template changes
- now uses Stencil includes. Paves the way for recursive nested schemas
- added APIError.name
- made RequestAuthorizer.authorize completed parameter escaping
- add tag to printed request and service descriptions

### Added
Added suite of tests for parsing, generating and compiling templates from a list of specs. Will improve stability and help prevent regressions. Still some work to do in this area

## [0.5.2] - 2017-05-16
### Added
- added SuccessType typealias to APIResponseValue. This lets you map from a response to successful value

### Changed
- Replaced `CustomDebugStringConvertible` with `PrettyPrinted` conformance on Models, so you can specify your own `CustomDebugStringConvertible`. Same string is available at `model.prettyPrinted`
- Moved generated request enums and anonymous schema from APIRequest.Request to one level higher in scope


## [0.5.1] - 2017-05-16
### Added
- A request's response now has a responseResult with either `.success(SuccessValue)` or `.failure(FailureValue)`. This is only generated if there is a single schema type for successes responses and a single schema type for failure responses

### Changed
- Added back `successType` in response context for backwards compatibility with old templates
- Updated Alamofire to 4.4.0

### Fixed
- Fixed api name not being replaced in `Decoding.swift` anymore

## [0.5.0] - 2017-05-16
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


## [0.4.1] - 2017-05-11
### Fixed
Improved the generation of complicated specs:

- escape *all* Swift keywords:
- escape and rename invalid characters
- escape symbols starting with numbers
- better support for deeply nested arrays and dictionaries
- fixed nested enums

## [0.4.0] - 2017-05-10
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

## [0.3.0] - 2017-05-04

### Fixed
- Operations with multiple path variables now properly generate an operationId. #11  Thanks @HSchultjan
- Operation parameters that contain anonymous schemas (those that don't reference a definition schema but define a schema inline) are now genererated properly as nested structs within the APIRequest #13

## [0.2.0] - 2017-05-03
### Added
- `Operation`, `Definition`, `Property` and `Parameter`, now have a `raw` property that can be accessed from templates. This represents the raw data that was in the original spec. This lets you access any custom properties you have in your spec

### Changed
- `Property` and `Parameter` have lost their `rawType` and `rawName` properties in favour of the above, so they are now `raw.type` and `raw.name`
- Upgraded Stencil to [0.9](https://github.com/kylef/Stencil/releases/tag/0.9.0)

## 0.1.0 - 2017-04-27
- First official release

[0.5.3]: https://github.com/yonaskolb/SwagGen/compare/0.5.2...0.5.3
[0.5.2]: https://github.com/yonaskolb/SwagGen/compare/0.5.1...0.5.2
[0.5.1]: https://github.com/yonaskolb/SwagGen/compare/0.5.0...0.5.1
[0.5.0]: https://github.com/yonaskolb/SwagGen/compare/0.4.1...0.5.0
[0.4.1]: https://github.com/yonaskolb/SwagGen/compare/0.4.0...0.4.1
[0.4.0]: https://github.com/yonaskolb/SwagGen/compare/0.3...0.4
[0.3.0]: https://github.com/yonaskolb/SwagGen/compare/0.2...0.3
[0.2.0]: https://github.com/yonaskolb/SwagGen/compare/0.1...0.2
