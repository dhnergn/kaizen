# Kaizen

Kaizen is a minimal, focused iOS application designed as a "daily self-development operating system." 
It transforms abstract personal-development concepts into executable daily habits without overwhelming gamification.

## Features
- **Daily Dashboard:** View today's progress, habit list, and define your "One Thing."
- **Habit Engine:** Auto-generates a balanced daily routine (Light, Normal, Deep) based on your chosen focus categories.
- **Library & Custom Habits:** Select from over 30 pre-built habits inspired by self-mastery literature, or create your own with custom scheduling.
- **Journal & Weekly Review:** Date-based morning intentions and evening reflections, plus a weekly check-in to ensure long-term consistency.
- **Local-First (Privacy by Design):** Built with SwiftData. No servers, no accounts, and no data tracking.

## Tech Stack
- **Platform:** iOS 17.0+
- **Framework:** SwiftUI
- **Architecture:** MVVM + Observation framework (`@Observable`)
- **Data Persistence:** SwiftData

## Getting Started

Since this project was generated via AI, the easiest way to open it in Xcode is to use [XcodeGen](https://github.com/yonaskolb/XcodeGen) to generate the `.xcodeproj` file, or simply create a new Xcode project and drag the `Kaizen` folder into it.

### Method 1: Using XcodeGen (Recommended)
If you have Homebrew installed on your Mac:
```bash
brew install xcodegen
cd path/to/Kaizen
xcodegen generate
open Kaizen.xcodeproj
```

### Method 2: Manual Xcode Project
1. Open Xcode -> Create a new Xcode project -> iOS App.
2. Name the project **Kaizen**.
3. Choose **SwiftUI** for Interface and **SwiftData** for Storage (optional, since we manually set it up anyway).
4. Drag and drop the contents of the generated `Kaizen/Kaizen` folder into your new Xcode project, replacing the default `ContentView.swift` and `KaizenApp.swift`.
5. Select the iOS 17.0 simulator and hit **Run** (`Cmd + R`).

## Core Principles
- "Read less. Practice more."
- Meaningful routines over endless checklists.
- Behavioral consistency over artificial gamification.
