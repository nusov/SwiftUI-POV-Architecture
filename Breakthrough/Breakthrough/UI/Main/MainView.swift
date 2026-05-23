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
    @Environment(AppState.self) var appState
    @Environment(AppRepository.self) var appRepository

    var body: some View {
        VStack {
            if let topic = appState.settings.selectedTopic {
                Text(topic)
            } else {
                Text("No Topic Selected")
            }

            Button("Reset") {
                try? appRepository.reset(in: modelContext)
                appState.resetSettings()
            }
        }

    }
}
