# SwagGen

![Platforms](https://img.shields.io/badge/platforms-Linux%20%7C%20macOS-blue.svg)
[![SPM](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)
[![Git Version](https://img.shields.io/github/release/yonaskolb/swaggen.svg)](https://github.com/yonaskolb/SwagGen/releases)
[![Build Status](https://img.shields.io/travis/yonaskolb/SwagGen/master.svg?style=flat)](https://travis-ci.org/yonaskolb/SwagGen)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/yonaskolb/SwagGen/blob/master/LICENSE)

This is a Swift command line tool that generates client code based on a [Swagger/OpenAPI Spec](http://swagger.io)

It has many advantages over the official [swagger-codegen](https://github.com/swagger-api/swagger-codegen) java tool such as speed, configurability, simplicity, extensibility, and an improved templating language.

The default Swift templates it generates are also much improved with support for model inheritance, shared enums, mutable parameter structs, convenience initialisers and many more improvements.

## Installing
Make sure Xcode 9 is installed first.

### [Mint](https://github.com/yonaskolb/mint)
```sh
$ mint run yonaskolb/SwagGen
```
### Homebrew

```
$ brew tap yonaskolb/SwagGen https://github.com/yonaskolb/SwagGen.git
$ brew install SwagGen
```

### Make

```
$ git clone https://github.com/yonaskolb/SwagGen.git
$ cd SwagGen
$ make
```

### Swift Package Manager

#### Use as CLI

```sh
$ git clone https://github.com/yonaskolb/XcodeGen.git
$ cd XcodeGen
$ swift run
```

#### Use as dependency

Add the following to your Package.swift file's dependencies:

```
.package(url: "https://github.com/yonaskolb/SwagGen.git", from: "1.1.0"),
```

And then import wherever needed:

```
import SwagGenKit
```

## Usage
Use `SwagGen -help` to see the list of options:

- **spec** (required): This is the path to the Swagger spec. It can either be a file path or a web url to a YAML or JSON file
- **template**: (required): This is the path to the template config yaml file. It can either be a direct path to the file, or a path to the parent directory which will by default look for `/template.yml`
- **destination**: The directory that the generated files will be added to.
- **option**: An option that will be merged with the template config options with those in this argument taking precedence, meaning any existing options of the same name will be overwritten. This argument can be repeated to pass in multiple options. Options must specify the option name and option value seperated by a colon, with any spaces contained in quotes. The following formats are allowed:
	- `-- option myOption:myValue`
	- `-- option "myOption: my value"`
	- `-- option myOption:" my value"`

- **clean**: Controls if and how the destination directory is cleaned of non generated files. Options are:
	- `none`: no files are removed (default)
	- `all`: all other files are removed
	- `leave.files`: all files and directories except those that start with `.` in the destination directory are removed. This is useful for keeping configuration files and directories such as `.git` around, while still making sure that items removed from the spec are removed from the generated API.

Example:

```
SwagGen --template Templates/Swift --spec http://myapi.com/spec --destination generated --option name:MyAPI --option "customProperty: custom value --clean leave.files"
```

For the Swift template, a handy option is `name`, which changes the name of the generated framework from the default of `API`. This can be set in the template or by passing in `--option name:MyCoolAPI`.

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

---

## Attributions

This tool is powered by:

- custom fork of [JSONUtilities](https://github.com/yonaskolb/JSONUtilities) by [Luciano Marisi](https://github.com/lucianomarisi)
- custom fork of [Stencil](https://github.com/yonaskolb/Stencil) by [Kyle Fuller](https://github.com/kylef)
- [Spectre](https://github.com/kylef/Spectre) by [Kyle Fuller](https://github.com/kylef)
- [PathKit](https://github.com/kylef/PathKit) by [Kyle Fuller](https://github.com/kylef)
- [Commander](https://github.com/kylef/Commander) by [Kyle Fuller](https://github.com/kylef)
- [Yams](https://github.com/jpsim/Yams) by [JP Simard](https://github.com/jpsim)

Thanks also to [Logan Shire](https://github.com/AttilaTheFun) and his work on [Swagger Parser](https://github.com/AttilaTheFun/SwaggerParser)

## Contributions
Pull requests and issues are welcome

## License

SwagGen is licensed under the MIT license. See [LICENSE](LICENSE) for more info.
