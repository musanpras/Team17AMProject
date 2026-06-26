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

        do {
            return try ModelContainer(
                for: schema,
                configurations: [
                    ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
                ]
            )
        } catch {
            preconditionFailure("Unable to create a persistent SwiftData ModelContainer: \(error)")
        }
    }
}
