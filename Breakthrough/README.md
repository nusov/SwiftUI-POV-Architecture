# Breakthrough

An Universal SwiftUI example app demonstrating the **Protocol Oriented View (POV)** architecture pattern in SwiftUI.

The app presents a 3-step onboarding flow — Welcome, Design, and Topic selection — built entirely around protocols, `@Observable` state, and SwiftUI's `@Environment` for dependency injection.

<img width="32%" height="2622" alt="Simulator Screenshot - iPhone 17 - 2026-05-22 at 20 37 36" src="https://github.com/user-attachments/assets/08476ffc-c802-4404-82bd-ddeca782d6fe" />
<img width="32%" height="2622" alt="Simulator Screenshot - iPhone 17 - 2026-05-22 at 20 37 40" src="https://github.com/user-attachments/assets/f897b021-c8ae-422d-b236-a188de7aad71" />
<img width="32%" height="2622" alt="Simulator Screenshot - iPhone 17 - 2026-05-22 at 20 37 45" src="https://github.com/user-attachments/assets/bf21f3c6-eb11-4a8b-bee0-6a2648dd4c06" />

## How It Works

1. **BreakthroughApp** creates shared dependencies (`AppState`, `AppSettings`, `AppRepository`) and injects them into the SwiftUI environment.
2. **RootView** checks `appSettings.hasCompletedOnboarding` and shows either the onboarding flow or the main screen.
3. **OnboardingView** conforms to `OnboardingProtocol`, which provides all navigation and business logic via a protocol extension. The view only handles layout.
4. Each screen (`WelcomeScreen`, `DesignScreen`, `TopicScreen`) is a standalone, stateless view with no business logic.

## File Structure

```
Breakthrough/
├── BreakthroughApp.swift
├── Core/
│   ├── AppConstants.swift
│   ├── AppSettings.swift
│   ├── AppState.swift
│   └── Protocols/
│       └── CaseSteppable+Extension.swift
├── Data/
│   ├── AppMigrationPlan.swift
│   ├── AppRepository.swift
│   ├── Extensions/
│   │   └── ModelContainer+Extension.swift
│   ├── Repositories/
│   │   └── TopicRepository.swift
│   └── Schema/
│       └── AppSchemaV1.swift
└── UI/
    ├── RootView.swift
    ├── Main/
    │   └── MainView.swift
    └── Onboarding/
        ├── OnboardingView.swift
        ├── OnboardingView+POV.swift
        ├── Components/
        │   ├── FeatureRow.swift
        │   └── SelectionCard.swift
        └── Screens/
            ├── WelcomeScreen.swift
            ├── DesignScreen.swift
            └── TopicScreen.swift
```

## File Descriptions

### App Entry

| File | Description |
|---|---|
| `BreakthroughApp.swift` | `@main` entry point. Creates the `ModelContainer` and shared dependencies, injects them into the environment via `.modelContainer()` and `.environment()`. |

### Core

| File | Description |
|---|---|
| `AppConstants.swift` | Holds static constants like the project GitHub URL. |
| `AppSettings.swift` | `@Observable` class that persists user settings (`hasCompletedOnboarding`, `selectedTopic`) to `UserDefaults` via `@AppStorage`. |
| `AppState.swift` | `@Observable` class for transient global state (currently empty, available for future use). |
| `CaseSteppable+Extension.swift` | Protocol that adds `isFirst`, `isLast`, `previous`, and `next` to any `CaseIterable` enum. Used by `OnboardingStep` for navigation. |

### Data

| File | Description |
|---|---|
| `AppSchemaV1.swift` | Defines the SwiftData schema (version 1.0.0) with the `Topic` model (`name` + `summary`). |
| `AppMigrationPlan.swift` | Schema migration plan for SwiftData. Exposes `typealias Topic = CurrentSchema.Topic` for app-wide use. |
| `AppRepository.swift` | `@Observable` class handling data lifecycle. Seeds the database with 3 architecture topics on first launch. Provides a `reset()` method to clear data and restart onboarding. |
| `TopicRepository.swift` | Placeholder repository for topic-specific queries (available for future expansion). |
| `ModelContainer+Extension.swift` | Extension on `ModelContainer` with factory methods: `sharedModelContainer` (persisted) and `previewContainer` (in-memory, pre-seeded for Xcode Previews). |

### UI — Root & Main

| File | Description |
|---|---|
| `RootView.swift` | Switches between `OnboardingView` and `MainView` based on `appSettings.hasCompletedOnboarding`, with an animated transition. |
| `MainView.swift` | Post-onboarding screen. Displays the selected topic name and a Reset button to restart the onboarding flow. |

### UI — Onboarding

| File | Description |
|---|---|
| `OnboardingView+POV.swift` | The **POV core**. Defines `OnboardingState` (with `OnboardingStep` enum), `OnboardingProtocol` (the contract), and its extension (the default implementation for `prepare`, `goBack`, `goNext`, `finish`). |
| `OnboardingView.swift` | The View struct conforming to `OnboardingProtocol`. Declares `@Environment` dependencies and `@State` for `OnboardingState`. Layout includes step switching, Back/Next buttons, and error alerts. |
| `WelcomeScreen.swift` | First onboarding step. Shows 3 core POV architecture points using `FeatureRow` components. |
| `DesignScreen.swift` | Second onboarding step. Explains the 3 layers of POV architecture (Protocol, Extension, View) with a GitHub link. |
| `TopicScreen.swift` | Third onboarding step. Queries `Topic` objects from SwiftData and displays them as selectable `SelectionCard` rows. Auto-selects the first topic. |

### UI — Components

| File | Description |
|---|---|
| `FeatureRow.swift` | Reusable row with a colored circle icon, title, and description. Used by Welcome and Design screens. |
| `SelectionCard.swift` | Tappable card with title, subtitle, and a checkmark/circle selection indicator. Used by Topic screen. |

## The POV Pattern in This App

```
┌─────────────────────────────────────────────┐
│  OnboardingProtocol (contract)              │
│  - var modelContext, appSettings, state     │
│  - func goBack(), goNext(), finish()        │
├─────────────────────────────────────────────┤
│  Protocol Extension (default implementation)│
│  - Navigation logic, data seeding, finishing│
├─────────────────────────────────────────────┤
│  OnboardingView (conforms to protocol)      │
│  - @Environment dependencies                │
│  - @State var state = OnboardingState()     │
│  - Layout only (no business logic)          │
├─────────────────────────────────────────────┤
│  OnboardingState (@Observable)              │
│  - Pure data: currentStep, selectedTopic    │
└─────────────────────────────────────────────┘
```
