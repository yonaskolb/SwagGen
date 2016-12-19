# SwagGen

This is a Swift command line tool that generates client code based on a [Swagger/OpenAPI Spec](http://swagger.io)

## Installation
Make sure XCode 8 is installed and run the following commands in the same directory as this repo. You can either install via the command line or Xcode

### 1. Command Line
```
swift build
```
You can then find the output in the build directory at `.build/debug/SwagGen`. You can move it out of there or simply run it:

```
.build/debug/SwagGen
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

- **spec** This is the path to the json Swagger spec. It can either be a file path or a url
- **template** This is the path to directory that contains the template. This directory must contain a `template.json` manifest file
- **destination** The directory where the generated files will go
- **options**: A list of options that are passed to each template. Options must be comma delimited and each key value pair must be colon delimited e.g.  "option: value, option2: value2"
- **clean** true or false - whether the destination directory is cleaned before the generated files are created. Defaults to true

Example:

```
SwagGen --template Templates/Swift --spec http://myapi.com/spec --options "name:MyAPI, customProperty: custom value"
```

## Templates
Templates are made up of a `template.json` manifest file and a bunch of `.stencil` files.

### template.json
This is a manifest for the template in a **json** format. It should contains:

- **formatter**: Optional formatter to use. This affects what properties are available in the templates e.g. `Swift`
- **files**: a list of files that contain:
	- **template**: path to stencil file
	- **context**: optional context within the spec. This is provided to the generated file, otherwise the full context will be. If this is an array then a file will be created for each object and the context within that array is used. e.g. a file for every model in the spec `definitions` gets it's own definition context 
	- **path**: the output path. This can contain stencil tags whose context is that from the context above. e.g. if context was `definitions` then the path could be `Models/{{name}}.swift` and the name would be the name of the definition
- **options**: this are the options passed into every stencil file and can be used to customize the template. These options can be override with the `templateOptions` arguement. 

An example template for Swift can be found [here](Templates/Swift/template.json)

### .stencil files
These files follow the **Stencil** file format outlined here [https://stencil.fuller.li](https://stencil.fuller.li)

## Formatters
Formatters change what information is available to the templates and how it's formatted. They can be specified via the formatter property in the `template.json` file. Usually these would map to a specific target language, but can be customized for different purposes.

## Languages
SwagGen can be used to generate code for any language. At the moment there is only a formatter and template for **Swift**