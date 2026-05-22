//
//  AppSchemaV1.swift
//  Breakthrough
//
//  Created by Alexander Nusov on 5/16/26.
//

import SwiftData

enum AppSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version {
        Schema.Version(1, 0, 0)
    }

    static var models: [any PersistentModel.Type] {
        [Topic.self]
    }

    @Model
    final class Topic {
        var name: String
        var summary: String

        init(name: String, summary: String) {
            self.name = name
            self.summary = summary
        }
    }
}
