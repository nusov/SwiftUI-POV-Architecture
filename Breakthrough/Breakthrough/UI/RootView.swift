//
//  RootView.swift
//  Breakthrough
//
//  Created by Alexander Nusov on 5/19/26.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(AppSettings.self) var appSettings
    
    var body: some View {
        Group {
            if appSettings.hasCompletedOnboarding {
                MainView()
            } else {
                OnboardingView()
            }
        }
        .animation(.easeInOut, value: appSettings.hasCompletedOnboarding)
    }
}

#Preview {
    RootView()
        .modelContainer(ModelContainer.previewContainer)
        .environment(AppSettings())
        .environment(AppRepository())
}

