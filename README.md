# SwagGen

![Platforms](https://img.shields.io/badge/platforms-Linux%20%7C%20macOS-blue.svg?style=for-the-badge)
[![SPM](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=for-the-badge)](https://swift.org/package-manager)
[![Git Version](https://img.shields.io/github/release/yonaskolb/swaggen.svg?style=for-the-badge)](https://github.com/yonaskolb/SwagGen/releases)
[![Build Status](https://img.shields.io/circleci/project/github/yonaskolb/SwagGen.svg?style=for-the-badge)](https://circleci.com/gh/yonaskolb/SwagGen)
[![license](https://img.shields.io/github/license/yonaskolb/SwagGen.svg?style=for-the-badge)](https://github.com/yonaskolb/SwagGen/blob/master/LICENSE)

SwagGen is a library and command line tool for parsing and generating code for [OpenAPI/Swagger 3.0](https://swagger.io/specification) specs, completely written in Swift.

> Swagger 2 support has been removed. For Swagger 2 use version `3.0.2` or the `swagger_2` branch

#### Swagger parser
It contains a `Swagger` library that can be used in Swift to load and parse Swagger specs.

#### Swagger code generator
`SwagGen` is command line tool that generates code from a [OpenAPI/Swagger 3.0](https://swagger.io/specification) spec.
Templates for any language can be written that leverage this generator.

It is an alternative the official [swagger-codegen](https://github.com/swagger-api/swagger-codegen) java code generator, and adds some improvements such as speed, configurability, simplicity, extensibility, and an improved templating language.

#### Swift template
`SwagGen` includes a bundled template for generating a client side Swift library for interfacing with the Swagger spec. It includes support for model inheritance, shared enums, discrete and mutable request objects, inline schemas, Codable and Equatable models, configurable options, generic networking stack, and many other niceties.

## Installing
Make sure Xcode 10.2 is installed first.

### [Mint](https://github.com/yonaskolb/mint)
```sh
$ mint install yonaskolb/SwagGen
```
### Homebrew

```sh
$ brew tap yonaskolb/SwagGen https://github.com/yonaskolb/SwagGen.git
$ brew install SwagGen
```

### Make

```sh
$ git clone https://github.com/yonaskolb/SwagGen.git
$ cd SwagGen
$ make install
```

### Swift Package Manager

#### Use as CLI

```sh
$ git clone https://github.com/yonaskolb/SwagGen.git
$ cd swaggen
$ swift run
```

#### Use as dependency

Add the following to your Package.swift file's dependencies:

```swift
.package(url: "https://github.com/yonaskolb/SwagGen.git", from: "4.3.0"),
```

And then import wherever needed:

```swift
import SwagGenKit
import Swagger
```

## Usage

Use `--help` to see usage information

```
swaggen --help
Usage: swaggen <command> [options]

Commands:
  generate        Generates a template from a Swagger spec
  help            Prints this help information
  version         Prints the current version of this app
```

### generate

```sh
swaggen generate path_to_spec
```

Use `swaggen generate --help` to see the list of generation options.

- **spec**: This is the path to the Swagger spec and is a required parameter. It can either be a file path or a web url to a YAML or JSON file
- **--language**: The language to generate a template for. This defaults to `swift` for now.
- **--template**:: This is the path to the template config yaml file. It can either be a direct path to the file, or a path to the parent directory which will by default look for `/template.yml`. If this is not passed, the default template for the language will be used.
- **--destination**: The directory that the generated files will be added to.
- **--option**: An option that will be merged with the template config options with those in this argument taking precedence, meaning any existing options of the same name will be overwritten. This argument can be repeated to pass in multiple options. Options must specify the option name and option value separated by a colon, with any spaces contained in quotes. Nested options in dictionaries can be set by using a dot syntax. The following formats are allowed:
	- `-- option myOption:myValue`
	- `-- option modelSuffix: Model`
	- `-- option propertyNames.identifier: id`
	- `-- option "myOption: my value"`

- **--clean**: Controls if and how the destination directory is cleaned of non generated files. Options are:
	- `none`: no files are removed (default)
	- `all`: all other files are removed
	- `leave.files`: all files and directories except those that start with `.` in the destination directory are removed. This is useful for keeping configuration files and directories such as `.git` around, while still making sure that items removed from the spec are removed from the generated API.
- **--verbose**: Show more verbose output
- **--silent**: Silences any standard output. Errors will still be shown

Example:

```
swaggen generate http://myapi.com/spec --template Templates/Swift  --destination generated --option name:MyAPI --option "customProperty: custom value --clean leave.files"
```

For the Swift template, a handy option is `name`, which changes the name of the generated framework from the default of `API`. This can be set in the template or by passing in `--option name:MyCoolAPI`.


### Swift Template

List of all available options:

name | action | expected values | default value
--- | --- | --- | ---
name | name of the API | `String` | API
authors | authors in podspec | `String` | Yonas Kolb
baseURL | baseURL in APIClient | `String` | first scheme, host, and base path of spec
fixedWidthIntegers | whether to use types like Int32 and Int64 | `Bool` | false
homepage | homepage in podspec  | `String` | https://github.com/yonaskolb/SwagGen
modelPrefix | model by adding a prefix and model file name | `String` | null
modelSuffix | model by adding a suffix and model file name | `String` | null
mutableModels | whether model properties are mutable | `Bool` | true
modelType | whether each model is a `struct` or `class` | `String` | class
modelInheritance | whether models use inheritance. Must be false for structs | Bool | true
modelNames | override model names | `[String: String]` | [:]
modelProtocol | customize protocol name that all models conform to | `String` | APIModel
enumNames | override enum names | `[String: String]` | [:]
enumUndecodableCase | whether to add undecodable case to enums | `Bool` | false
propertyNames | override property names | `[String: String]` | [:]
safeArrayDecoding | filter out invalid items in array instead of throwing | `Bool` | false
safeOptionalDecoding | set invalid optionals to nil instead of throwing | `Bool` | false
tagPrefix | prefix for all tags | `String` | null
tagSuffix | suffix for all tags | `String` | null
codableResponses | constrains all responses to be Codable | `Bool` | false

If writing your own Swift template there are a few types that are generated that you will need to provide typealias's for:

- `ID`: The `UUID` format. Usually `UUID` or `String`
- `File`: The `file` format. Usually `URL`, `Data` or a custom type with a mimeType and fileName
- `DateTime`: The `date-time` format. Usually `Date`
- `DateDay`:  The `date` format. Usually `Date` or a custom type.

## Editing
```
$ git clone https://github.com/yonaskolb/SwagGen.git
$ cd SwagGen
$ swift package generate-xcodeproj
```
This use Swift Project Manager to create an `xcodeproj` file that you can open, edit and run in Xcode, which makes editing any code easier.

If you want to pass any required arguments when running in XCode, you can edit the scheme to include launch arguments.

## Templates
Templates are made up of a template config file, a bunch of **Stencil** files, and other files that will be copied over during generation

### Template config
This is the configuration and manifest file for the template in YAML or JSON format. It can contain:

- **formatter**: Optional formatter to use. This affects what properties are available in the templates and how they are formatted e.g. `Swift`
- **templateFiles**: a list of template files. These can each have their paths, contents and destination directories modified through Stencil tags. One template file can also output to multiple files if they path is changed depending on a list context. Each file contains:
	- **path**: relative path to the template config. The extension is usually .stencil or the type it is going to end up as
	- **context**: optional context within the spec. This is provided to the generated file, otherwise the full context will be passed. If this is a list then a file will be created for each object and the context within that list is used. (e.g. a file for every model in the spec `definitions` gets it's own definition context). Note that properties in the template `options` field can be used here
	- **destination**: optional destination path. This can contain stencil tags whose context is that from the context above. e.g. if context was `definitions` then the path could be `Models/{{ type }}.swift` and the filename would be the type of the definition. If this is left out the destination will be the same as the path, relative to the final destination directory. If it resolves to an empty string it will be skipped and not generated.
- **copiedFiles**: this is an array of relative paths that will be copied to the destination. They can be files or directories. This is used for files that won't have their contents, filenames or paths changed.
- **options**: these are the options passed into every stencil file and can be used to customize the template. These options are merged with the `options` argument, with the argument options taking precendance. These options can be references in template file paths and their contents.

An example template for Swift can be found [here](Templates/Swift/template.yml)

### Template Files
These files follow the **Stencil** file format outlined here [https://stencil.fuller.li](https://stencil.fuller.li)

## Formatters
Formatters change what information is available to the templates and how it's formatted. They can be specified via the `formatter` property in the template config. Usually these would map to a specific target language, but can be customized for different purposes.

## Output Languages
SwagGen can be used to generate code for any language. At the moment there is only a formatter and template for **Swift**

## Swift API usage
Usage documentation can be found in the [Readme](Templates/Swift/README.md) that is generated with your template.

---

## Attributions

This tool is powered by:

- [JSONUtilities](https://github.com/yonaskolb/JSONUtilities)
- [Stencil](https://github.com/stencilproject/Stencil)
- [StencilSwiftKit](https://github.com/SwiftGen/StencilSwiftKit)
- [Spectre](https://github.com/kylef/Spectre)
- [PathKit](https://github.com/kylef/PathKit)
- [SwiftCLI](https://github.com/jakeheis/SwiftCLI)
- [Yams](https://github.com/jpsim/Yams)

Thanks also to [Logan Shire](https://github.com/AttilaTheFun) and his initial work on [Swagger Parser](https://github.com/AttilaTheFun/SwaggerParser)

## Contributions
Pull requests and issues are welcome

## License

SwagGen is licensed under the MIT license. See [LICENSE](LICENSE) for more info.
