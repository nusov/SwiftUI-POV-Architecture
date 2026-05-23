//
//  AppState.swift
//  Breakthrough
//
//  Created by Alexander Nusov on 5/20/26.
//

import Foundation

@Observable
final class AppState {
    let appSettingsKey = "appSettings"

    var settings: AppSettings {
        didSet { saveSettings() }
    }

    init() {
        settings = (try? JSONDecoder().decode(AppSettings.self,
                from: UserDefaults.standard.data(forKey: appSettingsKey) ?? Data())) ?? AppSettings()
    }

    func resetSettings() {
        settings = AppSettings()
    }

    private func saveSettings() {
        if let json = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(json, forKey: appSettingsKey)
        }
    }
}
