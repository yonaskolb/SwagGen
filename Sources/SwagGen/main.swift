import Commander
import Foundation
import PathKit
import SwagGenKit
import SwiftCLI

let version = "2.0.0"
let generateCommand = GenerateCommand()
let cli = CLI(name: "swaggen", version: version, description: "Swagger code generator", commands: [generateCommand])
cli.parser = Parser(router: SingleCommandRouter(command: generateCommand))
cli.goAndExit()
