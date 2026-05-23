//
//  AppSettings.swift
//  Breakthrough
//
//  Created by Alexander Nusov on 5/19/26.
//

import Foundation

struct AppSettings: Codable {
    var hasCompletedOnboarding: Bool = false
    var selectedTopic: String? = nil
}
