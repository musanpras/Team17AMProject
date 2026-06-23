//
//  TaskRepository.swift
//  Team17Project
//

import Foundation
import SwiftData

struct TaskRepository {
    let modelContext: ModelContext

    @discardableResult
    func save() -> Bool {
        do {
            try modelContext.save()
            return true
        } catch {
            assertionFailure("Failed to save TaskItem changes: \(error)")
            return false
        }
    }

    func complete(_ task: TaskItem, dailyState: DailyState) {
        EnergyCalculator.applyCompletion(task: task, to: dailyState)
        dailyState.lastUpdated = .now
        decrementSelection(for: task)
        save()
    }

    func removeActiveSelection(_ task: TaskItem) {
        decrementSelection(for: task)
        task.isPendingSelected = false
        save()
    }

    func addPendingSelection(_ task: TaskItem) {
        task.pendingSelectionCount += 1
        save()
    }

    func removePendingSelection(_ task: TaskItem) {
        guard task.pendingSelectionCount > 0 else { return }
        task.pendingSelectionCount -= 1
        save()
    }

    func commitPendingSelection(tasks: [TaskItem], pending: [TaskItem], max: Int = TaskSelection.maxSlots) {
        let limitedPending = Array(pending.prefix(max))
        var countMap: [ObjectIdentifier: Int] = [:]

        for task in limitedPending {
            let id = ObjectIdentifier(task)
            countMap[id, default: 0] += 1
        }

        for task in tasks {
            let id = ObjectIdentifier(task)
            if let count = countMap[id] {
                task.isSelected = true
                task.selectedCount = count
            } else {
                task.isSelected = false
                task.selectedCount = 0
            }
        }

        save()
    }

    func syncPendingFromCommitted(tasks: [TaskItem]) {
        for task in tasks {
            task.pendingSelectionCount = task.selectedCount
        }
        save()
    }

    func insert(_ task: TaskItem) {
        modelContext.insert(task)
        save()
    }

    func delete(_ task: TaskItem) {
        modelContext.delete(task)
        save()
    }

    func update(
        _ task: TaskItem,
        title: String,
        energyImpact: Int,
        isDraining: Bool,
        icon: String
    ) {
        task.title = title
        task.energyImpact = energyImpact
        task.isDraining = isDraining
        task.icon = icon
        save()
    }

    private func decrementSelection(for task: TaskItem) {
        if task.selectedCount > 1 {
            task.selectedCount -= 1
        } else {
            task.selectedCount = 0
            task.isSelected = false
        }
    }
}
