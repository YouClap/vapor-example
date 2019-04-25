# Vapor template for services

[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Vapor 3.3.0](https://img.shields.io/badge/Vapor-3.3.0-blueviolet.svg?style=flat)](https://github.com/vapor/vapor)
[![Vapor template](https://img.shields.io/badge/Vapor-template-blueviolet.svg?style=flat)](https://github.com/vapor/vapor)
[![license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/Youclap/vapor-template/blob/master/LICENSE)
![platforms](https://img.shields.io/badge/platforms-server%20side-lightgrey.svg)

⚠️  Under development... 🚧

## Requirements

You must have vapor toolbox installed to use this template, at least it helps.

### For macOS

[Vapor docs](https://docs.vapor.codes/3.0/install/macos/)

Assuming you have Xcode installed, or swift setted up on your machine, run:

```
brew tap vapor/tap
brew install vapor/tap/vapor
```

### For Ubuntu

[Vapor docs](https://docs.vapor.codes/3.0/install/ubuntu/)

Assuming you have swift installed and configured on your machine, follow the following steps to install vapor

Add APT repo

`eval "$(curl -sL https://apt.vapor.sh)"`

Install vapor

`sudo apt-get install swift vapor`

## Using this template

Vapor toolbox allows to start a new project by cloning a template

`vapor new <service name> --template=youclap/vapor-template`

To open the project in xcode, you have to generate a project

`vapor xcode`

which basicaly calls `swift package generate-xcodeproj`

Configuring the repository to use versioned hooks

`git config --local include.path ../.gitconfig`

### The Structure

On going... 🚧

# About

With ❤️ from [YouClap](https://youclap.tech) [Development team](mailto://development@youclap.tech)
