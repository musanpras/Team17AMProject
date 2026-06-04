//
//  AddTaskView.swift
//  Team17Project
//
//  Created by Muhammad Sandy Prastyo on 26/05/26.
//

import SwiftUI
import SwiftData

struct AddTaskView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context


    let task: TaskItem?
    var onSave: (() -> Void)?
    var onCancel: (() -> Void)?

    @State private var title = ""
    @State private var energy = 1
    @State private var isDraining = true
    @State private var icon = "🪫"

    init(
        task: TaskItem? = nil,
        onSave: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self.task = task
        self.onSave = onSave
        self.onCancel = onCancel
    }

    private var isEditing: Bool {
        task != nil
    }

    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !icon.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var energyTypeText: String {
        isDraining ? "draining" : "energizing"
    }
    
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 24)
                .fill(.white)
                .shadow(color: .black, radius: 0, x: 0, y: 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.black, lineWidth: 2)
                )

            VStack(spacing: 14) {
                Text(isEditing ? "edit task" : "custom task")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.black)
                    .padding(.top, 28)
                
                inputPanel
                energyPanel
                energyTypeRow
                saveButton
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 22)
            
            HStack {
                circleButton(
                    systemImage: "xmark",
                    foregroundColor: .black,
                    backgroundColor: .white,
                    action: close
                )
                
                Spacer()
            }
            .padding(.horizontal, -16)
            .offset(x: -10, y: -18)

            if isEditing {
                HStack {
                    Spacer()

                    circleButton(
                        systemImage: "trash",
                        foregroundColor: .white,
                        backgroundColor: .red,
                        action: deleteTask
                    )
                }
                .padding(.horizontal, -16)
                .offset(x: 10, y: -18)
            }
        }
        .frame(width: 294, height: 293)
        .onAppear {
            loadTaskIfNeeded()
        }
    }
    
    private var inputPanel: some View {
        VStack(spacing: 10) {
            TextField("activity", text: $title)
                .font(.system(size: 20, weight: .semibold))
                .textInputAutocapitalization(.never)
                .foregroundStyle(.black)
                .onChange(of: title) { _, newValue in
                    if newValue.count > 12 {
                        title = String(newValue.prefix(12))
                        
                    }
                }
    
        }
        .tint(.black)
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemGray6))
        )
    }
    
    private var energyPanel: some View {
        HStack{
            Button(action: {
                if energy > 1 {
                    energy -= 1
                }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(energy == 1 ? .gray : .black)
                    }
            ForEach(1...energy, id: \.self) {_ in
                if isDraining {
                    Image(systemName: "arrowshape.down.fill")
                } else {
                    Image(systemName: "arrowshape.up")
                }
                
            }
            Button(action: {
                if energy < 4 {
                    energy += 1
                }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(energy == 4 ? .gray : .black)
                    }
            
        }
    }
    
    private var energyTypeRow: some View {
        HStack(spacing: 12) {
            TextField("🪫", text: $icon)
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .frame(width: 36, height: 36)
                .background(Circle().fill(Color(.systemGray6)))
                .onChange(of: icon) { _, newValue in
                    icon = sanitizedIcon(from: newValue)
                }
            
            Spacer()
            
            Text(energyTypeText)
                .font(.system(size: 21, weight: .medium))
                .foregroundStyle(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            
            Toggle("", isOn: Binding(
                get: { !isDraining },
                set: { isDraining = !$0 }
            ))
            .labelsHidden()
            .tint(.green)
            .scaleEffect(0.82)
            .frame(width: 48)
        }
        .padding(.horizontal, 6)
        .onChange(of: isDraining){_, newValue in
            icon = newValue ? "🪫" : "🔋"
            
        }
    }
    
    private var saveButton: some View {
        Button {
            saveTask()
        } label: {
            Text(isEditing ? "confirm changes?" : "add to marketplace?")
                .font(.system(size: 16))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .underline()
                .strikethrough(!isFormValid)
                .foregroundStyle(isFormValid ? .black : .gray)
        }
        .disabled(!isFormValid)
        .padding(.top, 4)
    }
    
    private func circleButton(
        systemImage: String,
        foregroundColor: Color,
        backgroundColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(foregroundColor)
                .frame(width: 58, height: 58)
                .background(Circle().fill(backgroundColor)
                    .shadow(color: .black, radius: 0, x: 0, y: 7))
                .overlay(Circle().stroke(.white.opacity(0.85), lineWidth: 1))
        }
        .buttonStyle(.plain)
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

    private func loadTaskIfNeeded() {
        guard let task else { return }

        title = task.title
        energy = task.energyImpact
        isDraining = task.isDraining
        icon = task.icon
    }

    private func close() {
        onCancel?()
        dismiss()
    }

    private func deleteTask() {
        guard let task else { return }

        context.delete(task)
        try? context.save()
        onSave?()
        dismiss()
    }

    private func saveTask() {

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

            context.insert(task)
        }

        try? context.save()
        onSave?()
        dismiss()
    }
}

#Preview {
    AddTaskView()
}
