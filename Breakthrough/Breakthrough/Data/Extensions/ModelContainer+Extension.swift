//
//  ModelContainer+Extension.swift
//  Breakthrough
//
//  Created by Alexander Nusov on 5/16/26.
//

import SwiftData

@MainActor
extension ModelContainer {
    static func createContainer(isStoredInMemoryOnly: Bool) throws -> ModelContainer {
        let schema = Schema(versionedSchema: AppSchemaV1.self)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isStoredInMemoryOnly)
        
        do {
            return try ModelContainer(
                for: schema,
                migrationPlan: AppMigrationPlan.self,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    static var sharedModelContainer: ModelContainer {
        do {
            return try createContainer(isStoredInMemoryOnly: false)
        } catch {
            fatalError("Failed to created sharedModelContainer: \(error)")
        }
    }
    
    static var previewContainer: ModelContainer {
        do {
            let container = try createContainer(isStoredInMemoryOnly: true)
            let appRepository = AppRepository()
            try appRepository.seedIfNeeded(into: container.mainContext)
            return container
        } catch {
            fatalError("Failed to create previewContainer: \(error)")
        }
    }
}
