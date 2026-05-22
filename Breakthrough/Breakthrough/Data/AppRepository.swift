//
//  AppRepository.swift
//  Breakthrough
//
//  Created by Alexander Nusov on 5/19/26.
//

import SwiftData

@Observable
@MainActor
final class AppRepository {
    func seedIfNeeded(into context: ModelContext) throws {
        let fetchDescriptor = FetchDescriptor<Topic>()
        let fetchCount = try context.fetchCount(fetchDescriptor)
        guard fetchCount == 0 else { return }
        
        context.insert(Topic(name: "Logic Injection", summary: "Learn how business logic lives in Protocol Extensions"))
        context.insert(Topic(name: "Direct Environment", summary: "Explore accessing dependencies via @Environment"))
        context.insert(Topic(name: "State and Behavior Split", summary: "Discover how @Observable and Protocols work together"))
    }
    
    func reset(in context: ModelContext) throws {
        try context.delete(model: Topic.self)
        try context.save()
    }
}
