//
//  AddTaskViewModel.swift
//  Ttery
//
import SwiftUI
import SwiftData

@Observable
class AddTaskViewModel {

    var title = ""
    var energy = 1
    var isDraining = false
    var icon = "🔋"
    
    private(set) var task: TaskItem?
    
    var context: ModelContext?
    
    
    var isEditing: Bool {
        task != nil
    }

    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !icon.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var energyTypeText: String {
        isDraining ? "draining" : "energizing"
    }
    
    
    init(task: TaskItem? = nil) {
        self.task = task
    }
    

    func loadTaskIfNeeded() {
        guard let task else { return }

        title = task.title
        energy = task.energyImpact
        isDraining = task.isDraining
        icon = task.icon
    }
    
    
    func handleTitleChange(_ newValue: String) {
        if newValue.count > 12 {
            title = String(newValue.prefix(12))
            
        }
    }
    

    func handleIconChange(_ newValue: String) {
        icon = sanitizedIcon(from: newValue)
    }
    
    
    func handleDrainingChange(_ newValue: Bool) {
        icon = newValue ? "🪫" : "🔋"
        
    }

    func saveTask() {

        if let task {
            task.title = title.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            task.energyImpact = energy
            task.isDraining = isDraining
            task.icon = icon.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            let task = TaskItem(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
                energyImpact: energy,
                isDraining: isDraining,
                icon: icon.trimmingCharacters(in: .whitespacesAndNewlines)
            )

            context?.insert(task)
        }

        try? context?.save()
    }

    func deleteTask() {
        guard let task else { return }

        context?.delete(task)
        try? context?.save()
    }
    
    func sanitizedIcon(from value: String) -> String {
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
