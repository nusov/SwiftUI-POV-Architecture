//
//  BreakthroughApp.swift
//  Breakthrough
//
//  Created by Alexander Nusov on 5/22/26.
//

import SwiftUI
import SwiftData

@main
struct BreakthroughApp: App {
    // Create shared model container
    private let sharedModelContainer = ModelContainer.sharedModelContainer

    // Create App State (Global)
    private let appState = AppState()

    // Create App Settings (Persisted into UserDefaults using @AppStorage)
    private let appSettings = AppSettings()

    // Create App Repository (Main data lifecycle)
    private let appRepository = AppRepository()

    // Application Scene Body
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
        .environment(appState)
        .environment(appSettings)
        .environment(appRepository)
    }
}
