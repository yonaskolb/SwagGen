import Foundation
import PathKit
import SwagGenKit
import SwiftCLI

let version = "4.2.0"
let generateCommand = GenerateCommand()
let cli = CLI(name: "swaggen", version: version, description: "Swagger code generator", commands: [generateCommand])
cli.goAndExit()
