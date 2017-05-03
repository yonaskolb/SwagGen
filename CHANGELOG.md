# Change Log

## [0.2] - 2017-05-04
### Added
- `Operation`, `Definition`, `Property` and `Parameter`, now have a `raw` property that can be accessed from templates. This represents the raw data that was in the original spec. This lets you access any custom properties you have in your spec

### Changed
- `Property` and `Parameter` have lost their `rawType` and `rawName` properties in favour of the above, so they are now `raw.type` and `raw.name`
- Upgraded Stencil to [0.9](https://github.com/kylef/Stencil/releases/tag/0.9.0)

## 0.1 - 2017-04-27
- First official release

[0.3]: https://github.com/yonaskolb/SwagGen/compare/0.2...0.3
[0.2]: https://github.com/yonaskolb/SwagGen/compare/0.1...0.2
