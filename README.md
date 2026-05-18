# Protocol Oriented View (POV) Architecture
Protocol Oriented View Architecture for modern SwiftUI applications

## Architecture Description
The **Protocol Oriented View (POV)** architecture is a SwiftUI-specific pattern that shifts the responsibility of business logic from a separate class (ViewModel) to the View itself via Protocol Conformance.

In this pattern:
1.  **The Protocol** defines the contract: the required dependencies (services, modelContext) and the functions (business logic).
2.  **The Protocol Extension** provides the **default implementation** of the logic. This allows the code to be written once and reused by any view conforming to the protocol.
3.  **The View** conforms to the protocol. It holds the UI layout, declares its dependencies using `@Environment`, and manages a separate `@Observable` State class to hold data.
4.  **The State** is a pure data class (`ViewState`) that handles the mutable properties, ensuring the View struct remains lightweight while keeping data persistence correct.

## Core Points
*   **Logic Injection via Extensions:** Business logic is not inside the View or a ViewModel, but in a Protocol extension. This is "Composition over Inheritance."
*   **Direct Environment Access:** The View accesses dependencies (`SettingsManager`, `RoleService`) directly via `@Environment`, eliminating the need for manual dependency injection pass-through.
*   **Separation of State and Behavior:** The `@Observable` class holds *what* the data is (State), while the Protocol defines *what happens* to it (Behavior).
*   **Self-Initialization:** The View is responsible for fetching its own dependencies and initializing its own state, removing the need for parent "Factory" views.
*   **Reduced Boilerplate:** Eliminates the need for a separate `ViewModel` class file and the verbose binding syntax often associated with MVVM.

## Comparison: POV vs. MVVM

| Feature | MVVM (Model-View-ViewModel) | POV (Protocol Oriented View) |
| :--- | :--- | :--- |
| **Primary Actor** | The `ViewModel` class owns the logic and state. | The `View` struct owns the logic (via Protocol) and UI; a separate class owns the State. |
| **Dependency Injection** | **Manual/Parent-Driven:** A parent View must fetch dependencies and inject them into the ViewModel's initializer. | **Automatic/Environment-Driven:** The View accesses dependencies directly via `@Environment`. |
| **Boilerplate** | High. Requires a separate ViewModel class and often a parent View to initialize it. | Low. Logic lives in Protocol extensions; no separate class file for logic is required. |
| **Syntax** | `viewModel.finish()` | `finish()` (Direct method call on self) |
| **State Location** | Inside the `ViewModel` class. | Inside a dedicated `@Observable` class (e.g., `ViewState`). |
| **Reusability** | Achieved by subclassing ViewModels or sharing instances. | Achieved by conforming different Views to the same Protocol (Mix-ins). |
| **Testability** | Good, archived by extending the ViewModel to create a Mock | High, everything can be overriden. |
## Why POV is Better

### 1. Native SwiftUI Integration
MVVM often fights against SwiftUI's `@Environment` system, requiring developers to extract objects from the environment just to pass them into a ViewModel. POV embraces the environment; the Protocol logic simply uses `self.settingsManager`, making the code flow naturally with SwiftUI's data flow.

### 2. Elimination of "Factory" Views
In the provided MVVM example, `OnboardingParentView` exists solely to instantiate the `OnboardingView.ViewModel`. This adds visual clutter and navigation complexity. POV is self-contained: you can navigate directly to `OnboardingViewPOV`, and it sets itself up correctly.

### 3. Clearer Separation of Concerns
While MVVM mixes state and logic inside the ViewModel, POV forces a cleaner split:
*   **State:** Pure data (what changed).
*   **Protocol Extension:** Pure logic (how to react).
This makes the state easier to serialize or debug, and the logic easier to test or reuse.

### 4. Logic Reusability (The "Mixin" Pattern)
Because the logic lives in a Protocol, you can apply complex behaviors (like "NavigationFlow" or "Pagination") to completely different Views just by adding the protocol conformance. You do not need to inherit from a specific ViewModel base class to get this functionality.

### 5. Reduced Indirection
POV removes the layer of indirection between the View and the Logic. When a button is tapped, calling `goNext()` is immediately intuitive and traceable within the scope of the View, rather than jumping to a separate file to find the ViewModel implementation.

## Example
Here is example implementation of Onboarding (Back, Next/Finish buttons and switching views)

```swift
import SwiftUI
import SwiftData

enum OnboardingStep: CaseIterable, @MainActor CaseSteppable {
    case welcome
    case privacy
    case role
}

@Observable
@MainActor
final class OnboardingState {
    var currentStep: OnboardingStep = .welcome
    var selectedRoleId: String?
}

@MainActor
protocol OnboardingProtocol {
    var settingsManager: SettingsManager { get }
    var roleService: RoleService { get }
    var modelContext: ModelContext { get }
    var state: OnboardingState { get set }

    func goBack()
    func goNext()
    func finish()
}

extension OnboardingProtocol {
    func finish() {
        if let roleId = state.selectedRoleId {
            roleService.createThreadForSelectedRole(
                roleId: roleId,
                settings: settingsManager,
                context: modelContext
            )
        }
        settingsManager.hasCompletedOnboarding = true
    }

    func goBack() {
        if let previousStep = state.currentStep.previous {
            state.currentStep = previousStep
        }
    }

    func goNext() {
        if let nextStep = state.currentStep.next {
            state.currentStep = nextStep
        } else {
            finish()
        }
    }
}

struct OnboardingViewPOV: View, @MainActor OnboardingProtocol {
    // Dependencies (:ObservableObject)
    @EnvironmentObject var settingsManager: SettingsManager

    // Dependencies (@Observables)
    @Environment(RoleService.self) var roleService
    @Environment(\.modelContext) var modelContext

    // View State
    @State var state = OnboardingState()

    var body: some View {
        VStack {
            Spacer()

            switch state.currentStep {
            case .welcome:
                WelcomeScreen()
            case .privacy:
                PrivacyScreen()
            case .role:
                RoleScreen(selectedRoleId: $state.selectedRoleId)
            }

            Spacer()

            HStack(spacing: 16) {
                if !state.currentStep.isFirst {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            goBack()
                        }
                    } label: {
                        Text("Back")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(16)
                    }
                }

                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        goNext()
                    }
                } label: {
                    Text(state.currentStep.isLast ? "Finish Setup" : "Next")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: .blue.opacity(0.3), radius: 12, y: 6)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
    }
}

#Preview {
    OnboardingViewPOV()
        .environmentObject(SettingsManager())
        .environment(RoleService())
}
```

## Unit tests
For unit testing you just need to define a MockView which will conform the protocol and provide dependencies

```swift
import SwiftData
import Foundation
@testable import YourApp

@MainActor
final class MockView: OnboardingProtocol {
    // Required properties
    var settingsManager = MockSettingsManager()
    var roleService = MockRoleService()
    var modelContext: ModelContext = .mockContext

    var state = OnboardingState()
}

@Suite @MainActor 
struct OnboardingTests {
    @Test func testNavigationBounds() {
        let view = MockView()
        
        // Starts at welcome
        #expect(view.state.currentStep == .welcome)
        
        // Cannot go backwards past welcome
        view.goBack()
        #expect(view.state.currentStep == .welcome)

        // ...
    }

    // Other tests
}
```
