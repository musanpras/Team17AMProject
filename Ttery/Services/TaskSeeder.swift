//
//  TaskSeeder.swift
//  Team17Project
//

import SwiftData

enum TaskSeeder {
    static func seedDefaultTasksIfNeeded(in context: ModelContext) {
        let descriptor = FetchDescriptor<TaskItem>()
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }

        for task in TaskItem.defaultTasks {
            context.insert(task)
        }
    }
}
