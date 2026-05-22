//
//  MainView.swift
//  Breakthrough
//
//  Created by Alexander Nusov on 5/19/26.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(AppSettings.self) var appSettings
    @Environment(AppRepository.self) var appRepository

    var body: some View {
        VStack {
            if let topic = appSettings.selectedTopic {
                Text(topic)
            } else {
                Text("No Topic Selected")
            }

            Button("Reset") {
                try? appRepository.reset(in: modelContext)
                appSettings.hasCompletedOnboarding = false
            }
        }

    }
}
