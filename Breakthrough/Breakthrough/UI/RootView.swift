//
//  RootView.swift
//  Breakthrough
//
//  Created by Alexander Nusov on 5/19/26.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(AppState.self) var appState

    var body: some View {
        Group {
            if appState.settings.hasCompletedOnboarding {
                MainView()
            } else {
                OnboardingView()
            }
        }
        .animation(.easeInOut, value: appState.settings.hasCompletedOnboarding)
    }
}

#Preview {
    RootView()
        .modelContainer(ModelContainer.previewContainer)
        .environment(AppState())
        .environment(AppRepository())
}
