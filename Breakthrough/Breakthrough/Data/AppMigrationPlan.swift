//
//  AppMigrationPlan.swift
//  Breakthrough
//
//  Created by Alexander Nusov on 5/16/26.
//

import SwiftData

enum AppMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [AppSchemaV1.self]
    }

    static var stages: [MigrationStage] {
        []
    }
}

typealias CurrentSchema = AppSchemaV1
typealias Topic = CurrentSchema.Topic
