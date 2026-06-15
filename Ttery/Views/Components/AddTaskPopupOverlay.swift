//
//  AddTaskPopupOverlay.swift
//  Team17Project
//

import SwiftUI

struct AddTaskPopupOverlay: View {
    let editingTask: TaskItem?
    let onSave: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ModalDimmedOverlay(onDismiss: onCancel) {
            AddTaskView(task: editingTask, onSave: onSave, onCancel: onCancel)
        }
    }
}

#Preview {
    AddTaskPopupOverlay(editingTask: nil, onSave: {}, onCancel: {})
}
