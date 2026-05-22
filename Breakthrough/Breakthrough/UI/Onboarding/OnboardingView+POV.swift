//
//  OnboardingView+POV.swift
//  Breakthrough
//
//  Created by Alexander Nusov on 5/19/26.
//

import Foundation
import SwiftData

@Observable
@MainActor
final class OnboardingState {
    enum OnboardingStep: CaseIterable, @MainActor CaseSteppabble {
        case welcome
        case design
        case topic
    }
    
    var currentStep: OnboardingStep = .welcome
    var selectedTopic: Topic?
    
    var hasPrepared = false
    var showSeedError = false
    var seedErrorMessage = ""
}

@MainActor
protocol OnboardingProtocol {
    var modelContext: ModelContext { get }
    var appSettings: AppSettings { get }
    var appRepository: AppRepository { get }
    var state: OnboardingState { get }

    func prepare()
    func finish()
    func goBack()
    func goNext()
}

extension OnboardingProtocol {
    func prepare() {
        guard !state.hasPrepared else { return }
        state.hasPrepared = true

        do {
            try appRepository.seedIfNeeded(into: modelContext)
        } catch {
            state.seedErrorMessage = error.localizedDescription
            state.showSeedError = true
        }
    }

    func finish() {
        if let selectedTopic = state.selectedTopic {
            appSettings.selectedTopic = selectedTopic.name
        }

        appSettings.hasCompletedOnboarding = true
    }

    func goBack() {
        if let previousStep = state.currentStep.previous {
            state.currentStep = previousStep
        }
    }

    func goNext() {
        if let nextStep = state.currentStep.next {
            state.currentStep = nextStep
        } else {
            finish()
        }
    }
}
