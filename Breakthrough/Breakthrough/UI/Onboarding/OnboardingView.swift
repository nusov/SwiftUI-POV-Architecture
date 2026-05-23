//
//  OnboardingView.swift
//  Breakthrough
//
//  Created by Alexander Nusov on 5/19/26.
//

import SwiftUI
import SwiftData

struct OnboardingView: View, @MainActor OnboardingProtocol {
    // Dependencies
    @Environment(\.modelContext) var modelContext
    @Environment(AppState.self) var appState
    @Environment(AppRepository.self) var appRepository

    // View state
    @State var state = OnboardingState()

    // View layout
    var body: some View {
        // Root container
        VStack {
            Spacer()

            switch state.currentStep {
            case .welcome:
                WelcomeScreen()
            case .design:
                DesignScreen()
            case .topic:
                TopicScreen(selectedTopic: $state.selectedTopic)
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
                            .background(.background.secondary)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
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
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .blue.opacity(0.3), radius: 12, y: 6)
                }
                .buttonStyle(.plain)
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
    OnboardingView()
        .modelContainer(ModelContainer.previewContainer)
        .environment(AppState())
        .environment(AppRepository())
}
