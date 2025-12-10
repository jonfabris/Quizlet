# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Swift iOS application built with SwiftUI and Xcode. The project follows Apple's standard iOS app architecture using the App/Scene lifecycle introduced in iOS 14+.

## Build and Development Commands

### Building the Project
- Open `Quizlet.xcodeproj` in Xcode to build and run
- Build from command line: `xcodebuild -project Quizlet.xcodeproj -scheme Quizlet build`
- Run in iOS Simulator from command line: `xcodebuild -project Quizlet.xcodeproj -scheme Quizlet -destination 'platform=iOS Simulator,name=iPhone 15' build`

### Testing
- Run tests in Xcode: Cmd+U 
- Run tests from command line: `xcodebuild test -project Quizlet.xcodeproj -scheme Quizlet -destination 'platform=iOS Simulator,name=iPhone 15'`

## Architecture

### App Structure
- **QuizletApp.swift**: Main app entry point using `@main` App protocol
- **ContentView.swift**: Root SwiftUI view with basic "Hello, world!" content
- **Models/**: Directory for data models (currently empty)

### SwiftUI Architecture
- Uses declarative SwiftUI framework
- Follows MVVM pattern typical for SwiftUI apps
- App lifecycle managed by SwiftUI App protocol
- Views are structs conforming to View protocol

### Project Configuration
- Xcode project format: Modern project.pbxproj with FileSystemSynchronizedRootGroup
- iOS deployment target and Swift version defined in project settings
- No external dependencies or Swift Package Manager packages currently configured

## Development Notes

### File Organization
- Main source code in `Quizlet/` directory
- Assets in `Quizlet/Assets.xcassets/` including app icon and accent color
- Models intended for separate `Models/` directory

### SwiftUI Specifics
- Views use declarative syntax with `body` computed property
- Preview providers using `#Preview` macro for Xcode canvas
- Standard SwiftUI modifiers and view hierarchy patterns