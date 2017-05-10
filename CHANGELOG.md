# Change Log

## [0.4] - 2017-05-10
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

## [0.3] - 2017-05-04

### Fixed
- Operations with multiple path variables now properly generate an operationId. #11  Thanks @HSchultjan
- Operation parameters that contain anonymous schemas (those that don't reference a definition schema but define a schema inline) are now genererated properly as nested structs within the APIRequest #13

## [0.2] - 2017-05-03
### Added
- `Operation`, `Definition`, `Property` and `Parameter`, now have a `raw` property that can be accessed from templates. This represents the raw data that was in the original spec. This lets you access any custom properties you have in your spec

### Changed
- `Property` and `Parameter` have lost their `rawType` and `rawName` properties in favour of the above, so they are now `raw.type` and `raw.name`
- Upgraded Stencil to [0.9](https://github.com/kylef/Stencil/releases/tag/0.9.0)

## 0.1 - 2017-04-27
- First official release

[0.4]: https://github.com/yonaskolb/SwagGen/compare/0.3...0.4
[0.3]: https://github.com/yonaskolb/SwagGen/compare/0.2...0.3
[0.2]: https://github.com/yonaskolb/SwagGen/compare/0.1...0.2
