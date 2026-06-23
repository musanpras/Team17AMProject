//
//  AddTaskViewModel.swift
//  Team17Project
//

import Foundation
import SwiftData

@MainActor
@Observable
final class AddTaskViewModel {
    var title = ""
    var energy = 1
    var isDraining = false
    var icon = "🔋"

    private let taskRepository: TaskRepository
    private let editingTask: TaskItem?

    init(modelContext: ModelContext, editingTask: TaskItem? = nil) {
        self.taskRepository = TaskRepository(modelContext: modelContext)
        self.editingTask = editingTask
        loadTaskIfNeeded()
    }

    var isEditing: Bool {
        editingTask != nil
    }

    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !icon.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var energyTypeText: String {
        isDraining ? "draining" : "energizing"
    }

    func updateTitle(_ newValue: String) {
        title = String(newValue.prefix(12))
    }

    func decrementEnergy() {
        Haptic.light()
        if energy > 1 {
            energy -= 1
        }
    }

    func incrementEnergy() {
        Haptic.light()
        if energy < 4 {
            energy += 1
        }
    }

    func updateIcon(_ newValue: String) {
        icon = sanitizedIcon(from: newValue)
    }

    func updateDrainingToggle(isEnergizing: Bool) {
        isDraining = !isEnergizing
        guard icon.isEmpty else { return }
        icon = isDraining ? "🪫" : "🔋"
    }

    func save() {
        Haptic.light()
        guard isFormValid else { return }

        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let trimmedIcon = icon.trimmingCharacters(in: .whitespacesAndNewlines)

        if let editingTask {
            taskRepository.update(
                editingTask,
                title: trimmedTitle,
                energyImpact: energy,
                isDraining: isDraining,
                icon: trimmedIcon
            )
        } else {
            let task = TaskItem(
                title: trimmedTitle,
                energyImpact: energy,
                isDraining: isDraining,
                icon: trimmedIcon
            )
            taskRepository.insert(task)
        }
    }

    func delete() {
        Haptic.light()
        guard let editingTask else { return }
        taskRepository.delete(editingTask)
    }

    private func loadTaskIfNeeded() {
        guard let editingTask else { return }
        title = editingTask.title
        energy = editingTask.energyImpact
        isDraining = editingTask.isDraining
        icon = editingTask.icon
    }

    private func sanitizedIcon(from value: String) -> String {
        let emojiCharacters = value.filter { character in
            let scalars = character.unicodeScalars
            let hasEmoji = scalars.contains { scalar in
                scalar.properties.isEmoji || scalar.properties.isEmojiPresentation
            }
            let hasLetterOrNumber = scalars.contains { scalar in
                CharacterSet.alphanumerics.contains(scalar)
            }
            return hasEmoji && !hasLetterOrNumber
        }
        return String(emojiCharacters.prefix(1))
    }
}
