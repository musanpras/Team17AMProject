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

    @State private var title = ""
    @State private var energy = ""
    @State private var isDraining = true
    @State private var icon = "☺️"

    var onSave: (() -> Void)?
    var onCancel: (() -> Void)?

    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !icon.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && Int(energy) != nil
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
                Text("custom task")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.black)
                    .padding(.top, 28)

                inputPanel
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
            .offset(y: -18)
        }
        .frame(width: 294, height: 293)
    }

    private var inputPanel: some View {
        VStack(spacing: 10) {
            TextField("activity", text: $title)
                .font(.system(size: 20, weight: .semibold))
                .textInputAutocapitalization(.words)
                .foregroundStyle(.black)

            Divider()
                .frame(height: 1)
                .background(.gray.opacity(0.28))

            HStack(spacing: 6) {
                Image(systemName: "bolt.circle")
                    .font(.system(size: 18, weight: .semibold))

                TextField("points", text: $energy)
                    .font(.system(size: 18, weight: .semibold))
                    .keyboardType(.numberPad)
                    .foregroundStyle(.black)
                    .onChange(of: energy) { _, newValue in
                        energy = newValue.filter { $0.isNumber }
                    }
            }
            .foregroundStyle(.gray.opacity(0.55))
        }
        .tint(.black)
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemGray6))
        )
    }

    private var energyTypeRow: some View {
        HStack(spacing: 12) {
            TextField("☺️", text: $icon)
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
    }

    private var saveButton: some View {
        Button {
            saveTask()
        } label: {
            Text("add to marketplace?")
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

    private func close() {
        onCancel?()
        dismiss()
    }

    func saveTask() {

        guard let energyImpact = Int(energy) else { return }

        let task = TaskItem(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            energyImpact: energyImpact,
            isDraining: isDraining,
            icon: icon.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        context.insert(task)

        try? context.save()

        onSave?()
        dismiss()
    }
}

#Preview {
    AddTaskView()
}
