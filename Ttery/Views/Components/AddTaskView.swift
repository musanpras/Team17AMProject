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
    @State private var viewModel: AddTaskViewModel

    var onSave: (() -> Void)?
    var onCancel: (() -> Void)?

    init(
        modelContext: ModelContext,
        task: TaskItem? = nil,
        onSave: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        _viewModel = State(
            initialValue: AddTaskViewModel(
                modelContext: modelContext,
                editingTask: task
            )
        )
        self.onSave = onSave
        self.onCancel = onCancel
    }

    var body: some View {
        addTaskContent(viewModel: viewModel)
    }

    @ViewBuilder
    private func addTaskContent(viewModel: AddTaskViewModel) -> some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 24)
                .fill(.white)
                .shadow(color: .black, radius: 0, x: 0, y: 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.black, lineWidth: 2)
                )

            VStack(spacing: 14) {
                Text(viewModel.isEditing ? "edit task" : "custom task")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.black)
                    .padding(.top, 28)

                inputPanel(viewModel: viewModel)
                energyPanel(viewModel: viewModel)
                energyTypeRow(viewModel: viewModel)
                saveButton(viewModel: viewModel)
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 22)

            HStack {
                circleButton(
                    systemImage: "xmark",
                    foregroundColor: .black,
                    backgroundColor: .white,
                    action: { close(viewModel: viewModel) }
                )

                Spacer()
            }
            .padding(.horizontal, -16)
            .offset(x: -10, y: -18)

            if viewModel.isEditing {
                HStack {
                    Spacer()

                    circleButton(
                        systemImage: "trash",
                        foregroundColor: .white,
                        backgroundColor: .red,
                        action: { deleteTask(viewModel: viewModel) }
                    )
                }
                .padding(.horizontal, -16)
                .offset(x: 10, y: -18)
            }
        }
        .frame(width: 294, height: 293)
    }

    private func inputPanel(viewModel: AddTaskViewModel) -> some View {
        VStack(spacing: 10) {
            TextField("", text: Bindable(viewModel).title, prompt: Text("activity")
                .foregroundStyle(.gray)
                .font(.body))
                .font(.system(size: 20, weight: .semibold))
                .textInputAutocapitalization(.never)
                .foregroundStyle(.black)
                .onChange(of: viewModel.title) { _, newValue in
                    viewModel.updateTitle(newValue)
                }
        }
        .tint(.black)
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.fixedGray6)
        )
    }

    private func energyPanel(viewModel: AddTaskViewModel) -> some View {
        HStack {
            Button(action: viewModel.decrementEnergy) {
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(viewModel.energy == 1 ? .gray : .black)
            }
            ForEach(1...viewModel.energy, id: \.self) { _ in
                Image(systemName: viewModel.isDraining ? "arrowshape.down.fill" : "arrowshape.up")
                    .foregroundStyle(.black)
            }
            Button(action: viewModel.incrementEnergy) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(viewModel.energy == 4 ? .gray : .black)
            }
        }
    }

    private func energyTypeRow(viewModel: AddTaskViewModel) -> some View {
        HStack(spacing: 12) {
            TextField("🪫", text: Bindable(viewModel).icon)
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .frame(width: 36, height: 36)
                .background(Circle().fill(Color.fixedGray6))
                .onChange(of: viewModel.icon) { _, newValue in
                    viewModel.updateIcon(newValue)
                }

            Spacer()

            Text(viewModel.energyTypeText)
                .font(.system(size: 21, weight: .medium))
                .foregroundStyle(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Toggle("", isOn: Binding(
                get: { !viewModel.isDraining },
                set: { viewModel.updateDrainingToggle(isEnergizing: $0) }
            ))
            .labelsHidden()
            .tint(.green)
            .scaleEffect(0.82)
            .frame(width: 48)
        }
        .padding(.horizontal, 6)
    }

    private func saveButton(viewModel: AddTaskViewModel) -> some View {
        Button {
            viewModel.save()
            onSave?()
            dismiss()
        } label: {
            Text(viewModel.isEditing ? "confirm changes?" : "add to marketplace?")
                .font(.system(size: 16))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .underline()
                .strikethrough(!viewModel.isFormValid)
                .foregroundStyle(viewModel.isFormValid ? .black : .gray)
        }
        .disabled(!viewModel.isFormValid)
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

    private func close(viewModel: AddTaskViewModel) {
        Haptic.light()
        onCancel?()
        dismiss()
    }

    private func deleteTask(viewModel: AddTaskViewModel) {
        viewModel.delete()
        onSave?()
        dismiss()
    }
}

#Preview {
    AddTaskView(
        modelContext: try! ModelContainer(
            for: TaskItem.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        ).mainContext
    )
}
