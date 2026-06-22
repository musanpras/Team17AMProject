//
//  ModelContainerFactory.swift
//  Team17Project
//

import SwiftData

enum ModelContainerFactory {
    static func make() -> ModelContainer {
        let schema = Schema([
            Item.self,
            DailyState.self,
            TaskItem.self,
        ])

        let configurations = [
            ModelConfiguration(schema: schema, isStoredInMemoryOnly: false),
            ModelConfiguration(schema: schema, isStoredInMemoryOnly: true),
        ]

        for configuration in configurations {
            if let container = try? ModelContainer(
                for: schema,
                configurations: [configuration]
            ) {
                return container
            }
        }

        preconditionFailure("Unable to create a SwiftData ModelContainer.")
    }
}
