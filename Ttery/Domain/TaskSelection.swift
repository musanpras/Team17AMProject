//
//  TaskSelection.swift
//  Team17Project
//

import Foundation

enum TaskSelection {
    static let maxSlots = 4

    static func expandedSelectedTasks(from tasks: [TaskItem], maxCount: Int = maxSlots) -> [TaskItem] {
        let selected = tasks.filter(\.isSelected)
        return Array(
            selected.flatMap { task in
                Array(repeating: task, count: max(1, task.selectedCount))
            }
            .prefix(maxCount)
        )
    }

    static func expandedPendingTasks(from tasks: [TaskItem]) -> [TaskItem] {
        tasks.flatMap { task in
            Array(repeating: task, count: task.pendingSelectionCount)
        }
    }

    static func emptySlotCount(selectedCount: Int, maxCount: Int = maxSlots) -> Int {
        max(0, maxCount - selectedCount)
    }

    static func pendingSlots(from tasks: [TaskItem]) -> [MarketSelectedTaskGrid.Slot] {
        var committedUsed: [ObjectIdentifier: Int] = [:]

        return expandedPendingTasks(from: tasks).map { task in
            let id = ObjectIdentifier(task)
            let used = committedUsed[id, default: 0]
            let isCommitted = used < task.selectedCount
            committedUsed[id] = used + 1
            return MarketSelectedTaskGrid.Slot(task: task, isCommitted: isCommitted)
        }
    }

    static func homeSlots(from tasks: [TaskItem], maxCount: Int = maxSlots) -> [HomeSelectedTaskGrid.Slot] {
        expandedSelectedTasks(from: tasks, maxCount: maxCount).map { HomeSelectedTaskGrid.Slot(task: $0) }
    }
}
