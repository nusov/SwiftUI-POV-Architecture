//
//  OnboardingViewPOV.swift
//  RolesWitch
//
//  Created by Alexander Nusov on 5/16/26.
//

import SwiftUI
import SwiftData

enum OnboardingStep: CaseIterable, @MainActor CaseSteppabble {
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
    var appSeeder: AppSeeder { get }
    var modelContext: ModelContext { get }
    var state: OnboardingState { get set }

    func prepare()
    func finish()
    func goBack()
    func goNext()

}

extension OnboardingProtocol {
    func prepare() {
        print("prepare")
        settingsManager.setBestVoice()
        appSeeder.seed(into: modelContext)
    }

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
    // Dependencies
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(RoleService.self) var roleService
    @Environment(AppSeeder.self) var appSeeder
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
                if state.currentStep.isFirst {
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
        .task {
            prepare()
        }
    }
}

#Preview {
    OnboardingViewPOV()
        .environmentObject(SettingsManager())
        .environment(RoleService())
        .environment(AppSeeder())
}
