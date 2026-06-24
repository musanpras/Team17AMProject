//
//  AddTaskPopupOverlay.swift
//  Team17Project
//

import SwiftUI
import SwiftData

struct AddTaskPopupOverlay: View {
    @Environment(\.modelContext) private var modelContext

    let editingTask: TaskItem?
    let onSave: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ModalDimmedOverlay(onDismiss: onCancel) {
            AddTaskView(
                modelContext: modelContext,
                task: editingTask,
                onSave: onSave,
                onCancel: onCancel
            )
            .id(editingTask?.persistentModelID)
        }
    }
}

#Preview {
    AddTaskPopupOverlay(editingTask: nil, onSave: {}, onCancel: {})
        .modelContainer(for: TaskItem.self, inMemory: true)
}
