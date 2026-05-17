//
//  OnboardingView.swift
//  RolesWitch
//
//  Created by Alexander Nusov on 2/10/26.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    var viewModel: ViewModel

    var body: some View {
        // Local bindable reference for SwiftUI Bindings ($)
        @Bindable var viewModel = viewModel

        VStack {
            Spacer()

            switch viewModel.currentStep {
            case .welcome:
                WelcomeScreen()
            case .privacy:
                PrivacyScreen()
            case .role:
                RoleScreen(selectedRoleId: $viewModel.selectedRoleId)
            }

            Spacer()

            HStack(spacing: 16) {
                if !viewModel.currentStep.isFirst {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            viewModel.goBack()
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
                        viewModel.goNext()
                    }
                } label: {
                    Text(viewModel.currentStep.isLast ? "Finish Setup" : "Next")
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
            viewModel.prepare()
        }
    }
}

struct OnboardingParentView: View {
    // Dependencies
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(RoleService.self) var roleService
    @Environment(AppSeeder.self) var appSeeder
    @Environment(\.modelContext) var modelContext

    // Fix: @State keeps the ViewModel alive across view redraws
    @State private var viewModel: OnboardingView.ViewModel?

    var body: some View {
        Group {
            if let viewModel {
                OnboardingView(viewModel: viewModel)
            } else {
                ProgressView()
            }
        }
        .task {
            if viewModel == nil {
                viewModel = OnboardingView.ViewModel(
                    settings: settingsManager,
                    roleService: roleService,
                    appSeeder: appSeeder,
                    context: modelContext
                )
            }
        }
    }

}

#Preview {
    OnboardingParentView()
        .environmentObject(SettingsManager())
        .environment(RoleService())
        .environment(AppSeeder())
}

//
//  OnboardingView+ViewModel.swift
//  RolesWitch
//
//  Created by Alexander Nusov on 5/10/26.
//

import SwiftUI
import SwiftData

extension OnboardingView {
    // MARK: Additional types

    enum OnboardingStep: CaseIterable, @MainActor CaseSteppabble {
        case welcome
        case privacy
        case role
    }

    // MARK: View model

    @Observable
    @MainActor
    class ViewModel {
        // Dependencies
        private var settings: SettingsManager
        private var roleService: RoleService
        private var appSeeder: AppSeeder
        private var context: ModelContext

        // UI View State variables
        var currentStep: OnboardingStep = .welcome
        var selectedRoleId: String?

        // Inject dependencies and calls prepare()
        init(settings: SettingsManager, roleService: RoleService, appSeeder: AppSeeder, context: ModelContext) {
            self.settings = settings
            self.roleService = roleService
            self.appSeeder = appSeeder
            self.context = context
            
            print("initialized ViewModel()")
        }

        // Prepares the view on appear
        func prepare() {
            settings.setBestVoice()
            appSeeder.seed(into: context)
        }

        // Navigate to previous screen
        func goBack() {
            if let previousStep = currentStep.previous {
                currentStep = previousStep
            }
        }

        // Navigate to next screen
        func goNext() {
            if let nextStep = currentStep.next {
                currentStep = nextStep
            } else {
                finish()
            }
        }

        // Create a new thread and finish onboarding
        func finish() {
            if let roleId = selectedRoleId {
                roleService.createThreadForSelectedRole(
                    roleId: roleId,
                    settings: settings,
                    context: context
                )
            }
            settings.hasCompletedOnboarding = true
        }
    }
}
