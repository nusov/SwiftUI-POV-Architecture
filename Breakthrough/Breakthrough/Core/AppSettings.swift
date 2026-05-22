//
//  AppSettings.swift
//  Breakthrough
//
//  Created by Alexander Nusov on 5/19/26.
//

import Foundation
import SwiftUI

@Observable
class AppSettings {
    private class Storage {
        @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
        @AppStorage("selectedTopic") var selectedTopic: String?
    }
    private let storage = Storage()

    // MARK: - Manual synchrozation
    var hasCompletedOnboarding: Bool {
        didSet { storage.hasCompletedOnboarding = hasCompletedOnboarding }
    }

    var selectedTopic: String? {
        didSet { storage.selectedTopic = selectedTopic }
    }

    init() {
        self.hasCompletedOnboarding = storage.hasCompletedOnboarding
        self.selectedTopic = storage.selectedTopic
    }
}
