# SwagGen

This is a Swift command line tool that generates client code based on a [Swagger/OpenAPI Spec](http://swagger.io), via Mustache templates

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
If you would like to run from anywhere move it into `/usr/local/bin/`

### 2. Xcode
```
swift package generate-xcodeproj
```
will create an `xcodeproj` file that you can open, edit and run in Xcode, which also makes editing any code easier.


## Usage
Use `SwagGen -help` to see the list of options:

- **spec** This is the path to the Swagger spec used. It can either be a file path or a url
- **template** This is the path to directory that contains the template. This directory must contain a `template.json` manifest file
- **destination** The director where the generated files will go
- **clean** true or false - whether the destination directory is cleaned before the generated files are created

Example:

```
SwagGen --template Templates/Swift --spec http://myapi.com/spec
```

## Templates
Templates are made up of a `template.json` manifest file and a bunch of `.mustach` files.

### template.json
This is a manifest for the template in a **json** format. It should contains:

- **formatter**: Optional formatter to use. This affects what properties are available in the templates e.g. `Swift`
- **files**: a list of files that contain:
	- **template**: path to mustache file
	- **context**: optional context within the spec. This is provided to the generated file, otherwise the full context will be. If this is an array then a file will be created for each object and the context within that array is used. e.g. a file for every model in the spec `definitions` gets it's own definition context 
	- **path**: the output path. This can contain mustache tags whose context is that from the context above. e.g. if context was `definitions` then the path could be `Models/{{name}}.swift` and the name would be the name of the definition

An example template for Swift can be found [here](Templates/Swift/template.json)

### .mustache files
These files follow the **Mustache** file format. [https://github.com/groue/GRMustache.swift](https://github.com/groue/GRMustache.swift) is used to parse these files so check documentation on the format there.

## Formatters
Formatters change what information is available to the templates and how it's formatted. They can be specified via the formatter property in the `template.json` file. Usually these would map to a specific target language, but can be customized for different purposes.

## Languages
SwagGen can be used to generate code for any language. At the moment there is only an example formatter and template for **Swift**, though the template is unfinished