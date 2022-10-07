# Change Log

## Next Version

### Changed
- Updated `StencilSwiftKit` to 2.10.1 and therefore Stencil to 0.15.1 #309 @flex-tackgyu

## 4.7.0

### Changed
- Expanded `IntegerFormat` to support more fixed width integers #301 @wqz-leo
- Append more types of values to MultipartFormData including arrays and dictionaries #293 @0x0c

### Fixed
- Fixed duplicated switch cases when using explicit mappings in oneOf discriminator #297 @JanC
- Prefer generating composed types (oneOf, anyOf, ..) if the schema contains both `type: object` and `oneOf` #302 @JanC

## 4.6.0

### Fixed
- Fixed compilation with Xcode 13 #282 @sroebert

### Changed
- Improved `CodeFormatter` efficiency #272 @zntfdr
- Updated Alamofire used in template to 5.4.4 #283 @0x0c

## 4.5.0

### Changed
- Updated Alamore version in the Swift template to be 5.4.3 #273 @0x0c
- Minimum Swift version in the Swift template is now 5.2 #273 @0x0c
- Minimum iOS version in the Swift template is now 10 #273 @0x0c

### Fixed
- Fixed sporadic crashes due to malformed URLs #268 @marcelvoss
- Fixed generation of inline types for `allOf` #267 @nicholascross, #278 @liamnichols

## 4.4.0

### Added
- Support multiple authentication types per operation #222 @malteburkert
- Added support for `decimal` number format #259 @yonaskolb
- Added `numberType`, `doubleType`, `floatType` and `decimalType` template options #259 @yonaskolb
- Added support for binary response bodies #224 @Hustenbonbon

### Fixed
- Fixed inline allOf group generation
- Fixed property generation when there is only one group schema;  the first group schema type will be used as the type #217
- Added `anyType` option that allows to override `Any` in models
- Fixed date encoding formatter to conform to RFC3339
- Fixed `.swift-version` to use Swift 5.2 instead of Swift 4.1 #246
- Fixed Server is not defined issue #197

### Internal
- SwagGen minimum Swift version is 5.0

## 4.3.1

### Fixed
- Fixed `'??' has non-optional type` warning #207
- Fixed incorrect replacements in server variables #209
- Fixed nullable references not being generated as optionals #216 @alephao

### Internal
 - Removed needless `Array` initialization. #212 @RomanPodymov

## 4.3.0

### Added
- Added ability to set nested template options from the command line using dot syntax eg `--option "typeAliases.ID: String"` #189
- Added a customizable `jsonEncoder` on APIClient #172 #203
- Added support for using a custom encoder per request #172 #203

### Changes
- List operations by path and then by method to keep the order consistent between code generations #185
- Add `codableResponses` option that constrains all models and responses to Codable #198
- Add `propertyNames` option that allow to override the name of properties #196

### Fixed
- Fixed responses from silently failing to parse when missing a `description`, which is now an optional property that defaults to an empty string #193
- Add missing custom model protocol name #191
- Fixed missing customization of JSONEncoder instance to encode request's body #147
- Fixed string uploads #161

## 4.2.0

### Swift Template Changes
- Added support for objects in query params #158
- Added support for nullable properties #165
- Removed 3rd party Result framework #174
- Fixed path to `Enum.swift` on Linux #157
- Fixed model initializers with multiple levels of inheritance #175

### Fixes
- Decode Swagger specs with no components #180

### Changes
- Update dependencies

## 4.1.0

### Added
- Added swift template option `enumUndecodableCase` that adds an `undecodable` case to enums when decoding fails #141

### Fixed
- Fixed installing in Swift 5 #139
- Fixed Swift template building in Swift 5 by Alamofire #139

### Changed:
- Updated codebase to Swift 5 and dropped Swift 4.2 #139

## 4.0.0

### Added
- Added support for OpenAPISpec/Swagger 3. Support for Swagger 2 has been removed. For that please use release 3.0.2 or the `swagger_2` branch #118 #121
- Added [StencilSwiftKit](https://github.com/SwiftGen/StencilSwiftKit) support for templates #111
- Added `oneOf` and `anyOf` with discriminators #121
- Added support for generating inline schemas when they are wrapped in an array #121

### Swift Template Updates
- Swagger 3 support #118
- Added generated `Server` #118
- Discriminated `oneOf` and `anyOf` enums #121
- Allow both form and path parameters in the same request #118
- Add headers to request #120
- Add framework `Info.plist` #117
- Use `safeArrayDecoding` #117
- Catch `APIClientError` from RequestBehaviour validation #117
- Added `typeAliases` option #117
- Validation error changed from a String to an Error #117
- Improve request description and summary #117
- Change `SecurityRequirement.scope` string to `SecurityRequirement.scopes` array #117
- Use `StringCodingKey` instead of enum types #117
- Replace `DateTime` with `Date` #117
- Update `Alamofire` dependency to 4.8.1 #123
- Update `Result` dependency to 4.1.0 #123
- Enums conform to Equatable and CaseIterable #124
- Removed support for Swift 4.1 #124
- Only generate `isEqual` in model classes not structs #117
- Fixed path params that don't have swift friendly names #130
- Fixed operations with mutiple success responses and no error responses #127
- Fix nested schemas in subclasses thinking they have a parent #128
- Handle nil `modelProtocol` option #117

### Removed
- Removed support for Swagger 2 #118
- Removed Swift 4.1 support #134

## 3.0.2

### Added
- Added `example` and `default` to the generator

### Fixed
- Changed default date formatter in templates to use `yyyy` not `YYY` #114
- Fixed date formatting of `DateDay` properties #114
- Fixed encoding of dictionary types #113

### Internal
- Updated to Swift 4.2
- Updated YAMS, Rainbow and SwiftCLI

## 3.0.1

### Added
- Added new `modelProtocol` template option which defaults to `APIModel` #109

### Fixed
- Fixed crash in Swift template when not using any RequestBehaviours #108

## 3.0.0

### Added
- Added File upload support #103
- Added top level security support #104
- Added `modelType` option to Swift template for class or struct models #94
- Added `modelInheritance` template option #94
- Added `modelNames` and `enumNames` template options for overriding names #95
- Added `x-enum-name` property to Swagger for custom enum names #98
- Added operation `summary` to generation and template

### Changed
- Swift template changes #104
	- Renamed `APIError` to `APIClientError`
	- Removed `APIClient.authorizer`
	- Added `RequestBehavour.validate` (replaces `APIClient.authorizer`)
	- `APIClient.makeRequest` now returns a `CancellableRequest` instead of `Alamofire.Request`
	- A new `APIClient.jsonDecoder` property which is used for json requests
	- Renamed `queue` to `completionQueue` in `APIClient.makeRequest`
	- Replaced `APIError. authorizationError` with `APIClientError. validationError`
	- Rename `APIService.authorization` to `APIService.securityRequirement`
- Generated type changes in Swift template. You will now have to handle or typealias the following types #104
	- `ID`: The `UUID` format. Usually `UUID` or `String`
	- `File`: The `file` format. Usually `URL`, `Data` or a custom type with a mimeType and fileName

### Fixed
- Sort operations in generated Readme
- Better name camel casing #100
- Fix empty string field decoding in YAML #101
- Escape `Protocol` in swift templates

## 2.1.2

### Added
- Added generated Swift template documenation #87

### Fixed
- Fixed nil `AnyCodable` values being encoded as null
- Fixed inbuilt templates not being found in Mint installations

## 2.1.1

### Added
- Added support for ASCI encoded swagger specs #80

### Fixed
- Fixed homebrew installation on machines with both Xcode 9.3 and Command line tools installed
- Fixed `UUID` parameter encoding #81

## 2.1.0

### Added
- Separated `date` and `date-time` formats into `DateDay` and `DateTime` structs #74 #77
- Added new `modelPrefix` and `modelSuffix` options #75

### Fixed
- Fixed regression where request bodies were not being encoding properly #76
- Fixed `safeOptionalDecoding` not working on optional Arrays
- Fixed `date-time` not decoding in some cases #77

## 2.0.0

### Added
- Swift template: added `Codable` support to models #61
- Swift template: added `Equatable` support to models #63
- Swift template: added `mutableModels` option #64
- Swift template: added `safeArrayDecoding` option #71
- Swift template: added `safeOptionalDecoding` option #71
- Bundle templates with installation #65
- New `language` argument which defaults to `swift` for now #65
- Default template for language is now used if no template path is specified #65
- Added support for inline anonymous schemas in definitions, body params, and responses #66
- Added UUID support #72
- Added `--silent` flag #68
- Added `--verbose` flag #68
- Added `--version` flag #68

### Changes
- Swift template: move sources out of now unnessary subdirectory #62
- Swift template: reorganise template #69
- Swift template: updated dependencies
- Swift template: Update to Swift 4.1
- Updated CLI #68
- Improved error output #68
- Make executable lowercase `swaggen` (breaking on linux) #68
- **BREAKING** generation moved into generate command: `swaggen generate` #68
- **BREAKING** `--spec` has changed to a required parameter: `swaggen generate path_to_spec` #68

### Removed
- **BREAKING** Swift template: models no longer have `init(jsonDictionary: JSONDictionary)` or `encode() -> JSONDictionary` functions #61
- Swift template: removed `JSONUtilities` dependency #61

## 1.2.0

### Added
- Added `fixedWidthIntegers` option to Swift template. Thanks @martinknabbe
- Added support for response references #58

### Fixed
- Fixed Swift 4.0.2 warnings
- Fixed Brew install

## 1.1.0

### Added
- Generate typealias for models with reference and array types #42 thanks @Liquidsoul
- generate typealias for models that only have additional properties

### Fixed
- fixed SPM installation issue

## 1.0.0

### Added
- Swift template: decode response on background queue and then call completion on main thread or new `queue` parameter

### Changed
- Updated project to Swift 4 #42
- Updated Swift templates to Swift 4 #42

## 0.6.1

### Added
- Homebrew and Make installations
- Enums now also have a raw property to access original json

### Changed
- Requests in Swift template are final

### Fixed
- Fixed parameters with a file type not being generated

## 0.6.0

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
- Fixed some array query parameters not joining their contents with the collectionFormat separator (uses comma delimited by default now if none is provided)
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

## 0.5.3

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

## 0.5.2

### Added
- added SuccessType typealias to APIResponseValue. This lets you map from a response to successful value

### Changed
- Replaced `CustomDebugStringConvertible` with `PrettyPrinted` conformance on Models, so you can specify your own `CustomDebugStringConvertible`. Same string is available at `model.prettyPrinted`
- Moved generated request enums and anonymous schema from APIRequest.Request to one level higher in scope

## 0.5.1

### Added
- A request's response now has a responseResult with either `.success(SuccessValue)` or `.failure(FailureValue)`. This is only generated if there is a single schema type for successes responses and a single schema type for failure responses

### Changed
- Added back `successType` in response context for backwards compatibility with old templates
- Updated Alamofire to 4.4.0

### Fixed
- Fixed api name not being replaced in `Decoding.swift` anymore

## 0.5.0

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

## 0.4.1

### Fixed
Improved the generation of complicated specs:

- escape *all* Swift keywords:
- escape and rename invalid characters
- escape symbols starting with numbers
- better support for deeply nested arrays and dictionaries
- fixed nested enums

## 0.4.0

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

## 0.3.0

### Fixed
- Operations with multiple path variables now properly generate an operationId. #11  Thanks @HSchultjan
- Operation parameters that contain anonymous schemas (those that don't reference a definition schema but define a schema inline) are now genererated properly as nested structs within the APIRequest #13

## 0.2.0

### Added
- `Operation`, `Definition`, `Property` and `Parameter`, now have a `raw` property that can be accessed from templates. This represents the raw data that was in the original spec. This lets you access any custom properties you have in your spec

### Changed
- `Property` and `Parameter` have lost their `rawType` and `rawName` properties in favour of the above, so they are now `raw.type` and `raw.name`
- Upgraded Stencil to [0.9](https://github.com/kylef/Stencil/releases/tag/0.9.0)

## 0.1.0
- First official release
