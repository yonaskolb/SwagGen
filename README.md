# SwagGen

[![Build Status](https://img.shields.io/travis/yonaskolb/SwagGen/master.svg?style=flat)](https://travis-ci.org/yonaskolb/SwagGen)

This is a Swift command line tool that generates client code based on a [Swagger/OpenAPI Spec](http://swagger.io)

It has many advantages over the official [swagger-codegen](https://github.com/swagger-api/swagger-codegen) java tool such as speed, configurability, simplicity, extensibility, and an improved templating language.

The default Swift templates it generates are also much improved with support for model inheritance, shared enums, mutable parameter structs, convenience initialisers and many more improvements.

## Install
Make sure Xcode 8 is installed and run the following commands in the same directory as this repo. You can either build via the Swift Package Manager on the command line or Xcode

### 1. Command Line
```
swift build -c release
```
This compiles a release build via the Swift Package Manager. You can find the output in the build directory which by default is at `.build/release/SwagGen`. You can move it out of there or simply run it:

```
.build/release/SwagGen
```
If you would like to run from anywhere, move it into `/usr/local/bin/`

### 2. Xcode
```
swift package generate-xcodeproj
```
will create an `xcodeproj` file that you can open, edit and run in Xcode, which also makes editing any code easier.

If you want to pass the required arguments when running in XCode, you can edit the scheme to include launch arguments.

## Usage
Use `SwagGen -help` to see the list of options:

- **spec** (required): This is the path to the Swagger spec. It can either be a file path or a web url to a YAML or JSON file
- **template** (required): This is the path to the template config yaml file. It can either be a direct path to the file, or a path to the parent directory which will by default look for `/template.yml`
- **destination** The directory that the generated files will be added to.
- **options**: A list of options that are passed to each template. Options must be comma delimited and each key value pair must be colon delimited. Whitespace is automatically trimmed, though if you have values with spaces in them, surround the argument with quotes. e.g.  `--options "option: value 1, option2: value 2"`
- **clean** true or false - whether the destination directory is cleaned before the generated files are created. Defaults to false

Example:

```
SwagGen --template Templates/Swift --spec http://myapi.com/spec --options "name: MyAPI, customProperty: custom value"
```

## Templates
Templates are made up of a template config file, a bunch of **Stencil** files, and other files that will be copied over during generation

### Template config
This is the configuration and manifest file for the template in YAML or JSON format. It can contain:

- **formatter**: Optional formatter to use. This affects what properties are available in the templates and how they are formatted e.g. `Swift`
- **templateFiles**: a list of template files. These can each have their paths, contents and destination directories modified through Stencil tags. One template file can also output to multiple files if they path is changed depending on a list context. Each file contains:
	- **path**: relative path to the template config. The extension is usually .stencil or the type it is going to end up as
	- **context**: optional context within the spec. This is provided to the generated file, otherwise the full context will be passed. If this is a list then a file will be created for each object and the context within that list is used. (e.g. a file for every model in the spec `definitions` gets it's own definition context). Note that properties in the template `options` field can be used here
	- **destination**: optional destination path. This can contain stencil tags whose context is that from the context above. e.g. if context was `definitions` then the path could be `Models/{{ name }}.swift` and the filename would be the name of the definition. If this is left out the destination will be the same as the path, relative to the final destination directory. If it resolves to an empty string it will be skipped and not generated.
- **copiedFiles**: this is an array of relative paths that will be copied to the destination. They can be files or directories. This is used for files that won't have their contents, filenames or paths changed.
- **options**: these are the options passed into every stencil file and can be used to customize the template. These options are merged with the `options` argument, with the argument options taking precendance. These options can be references in template file paths and their contents.

An example template for Swift can be found [here](Templates/Swift/template.yml)

### Template Files
These files follow the **Stencil** file format outlined here [https://stencil.fuller.li](https://stencil.fuller.li)

## Formatters
Formatters change what information is available to the templates and how it's formatted. They can be specified via the `formatter` property in the template config. Usually these would map to a specific target language, but can be customized for different purposes.

## Output Languages
SwagGen can be used to generate code for any language. At the moment there is only a formatter and template for **Swift**
