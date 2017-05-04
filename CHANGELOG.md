# Change Log

## [0.3] - 2017-05-04

### Fixed
- Operations with multiple path variables now properly generate an operationId. Thanks @HSchultjan
- Operation parameters that contain anonymous schemas (those that don't reference a definition schema but define a schema inline) are now genererated properly as nested structs within the APIRequest 

## [0.2] - 2017-05-03
### Added
- `Operation`, `Definition`, `Property` and `Parameter`, now have a `raw` property that can be accessed from templates. This represents the raw data that was in the original spec. This lets you access any custom properties you have in your spec

### Changed
- `Property` and `Parameter` have lost their `rawType` and `rawName` properties in favour of the above, so they are now `raw.type` and `raw.name`
- Upgraded Stencil to [0.9](https://github.com/kylef/Stencil/releases/tag/0.9.0)

## 0.1 - 2017-04-27
- First official release

[0.3]: https://github.com/yonaskolb/SwagGen/compare/0.2...0.3
[0.2]: https://github.com/yonaskolb/SwagGen/compare/0.1...0.2
