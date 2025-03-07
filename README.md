# Parrot iOS

## 📖 Overview
Parrot iOS is the mobile application for the Parrot language learning platform. It provides an interactive and engaging experience for users to practice pronunciation, complete lessons, and track progress through a structured curriculum.

## 📂 Project Structure
```
.
├── ParrotIos/              # Main application source code
│   ├── Assets.xcassets/    # App assets (icons, images, colors)
│   ├── Features/           # Core app features
│   │   ├── Auth/           # Authentication (Login, Signup)
│   │   ├── Leaderboard/    # User rankings and competition
│   │   ├── Lesson/         # Lesson and exercise handling
│   │   ├── Profile/        # User profile and settings
│   │   ├── Unit/           # Curriculum and lesson structuring
│   │   ├── WordOfTheDay/   # Daily word practice
│   │   ├── Nav/            # Navigation components
│   ├── Services/           # API and data services
│   ├── Shared/             # Shared components (Models, Utilities, Views)
│   ├── ParrotIosApp.swift  # App entry point
│   ├── Info.plist          # Configuration and app metadata
├── ParrotIosTests/         # Unit and UI tests
├── ParrotIos.xcodeproj/    # Xcode project configuration
├── ParrotIos.xcworkspace/  # Xcode workspace
├── LaunchScreen.storyboard # App launch screen
├── dev.xcconfig            # Development environment configuration
├── prod.xcconfig           # Production environment configuration
├── README.md               # Project documentation
```

## 🚀 Getting Started

### Running the App
1. Select the **ParrotIos** scheme in Xcode.
2. Choose a simulator or connect a physical device.
3. Click **Run (⌘R)** to build and launch the app.

### Running Tests
To execute unit and UI tests:
```sh
⌘U (Run Tests in Xcode)
```

## 🛠 Development

### Coding Style
- Follow Swift best practices and SwiftLint guidelines.
- Use MVVM (Model-View-ViewModel) architecture for UI components.
