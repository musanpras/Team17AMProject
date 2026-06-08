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

    @State private var viewModel: AddTaskViewModel

    var onSave: (() -> Void)?
    var onCancel: (() -> Void)?

    init(
        task: TaskItem? = nil,
        onSave: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self._viewModel = State(initialValue: AddTaskViewModel(task: task))
        self.onSave = onSave
        self.onCancel = onCancel
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
                Text(viewModel.isEditing ? "edit task" : "custom task")
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

            if viewModel.isEditing {
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
            viewModel.context = context
            viewModel.loadTaskIfNeeded()
        }
    }
    
    private var inputPanel: some View {
        VStack(spacing: 10) {
            TextField("", text: $viewModel.title, prompt: Text("activity")
                .foregroundStyle(.gray)
                .font(.body))
                .font(.system(size: 20, weight: .semibold))
                .textInputAutocapitalization(.never)
                .foregroundStyle(.black)
                .onChange(of: viewModel.title) { _, newValue in
                    viewModel.handleTitleChange(newValue)
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
    
    private var energyPanel: some View {
        HStack{
            Button(action: {
                if viewModel.energy > 1 {
                    viewModel.energy -= 1
                }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(viewModel.energy == 1 ? .gray : .black)
                    }
            ForEach(1...viewModel.energy, id: \.self) {_ in
                Image(systemName: viewModel.isDraining ? "arrowshape.down.fill" : "arrowshape.up")
                    .foregroundStyle(.black)
                
            }
            Button(action: {
                if viewModel.energy < 4 {
                    viewModel.energy += 1
                }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(viewModel.energy == 4 ? .gray : .black)
                    }
            
        }
    }
    
    private var energyTypeRow: some View {
        HStack(spacing: 12) {
            TextField("🪫", text: $viewModel.icon)
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .frame(width: 36, height: 36)
                .background(Circle().fill(Color.fixedGray6))
                .onChange(of: viewModel.icon) { _, newValue in
                    viewModel.handleIconChange(newValue)
                }
            
            Spacer()
            
            Text(viewModel.energyTypeText)
                .font(.system(size: 21, weight: .medium))
                .foregroundStyle(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            
            Toggle("", isOn: Binding(
                get: { !viewModel.isDraining },
                set: { viewModel.isDraining = !$0 }
            ))
            .labelsHidden()
            .tint(.green)
            .scaleEffect(0.82)
            .frame(width: 48)
        }
        .padding(.horizontal, 6)
        .onChange(of: viewModel.isDraining){_, newValue in
            viewModel.handleDrainingChange(newValue)
            
        }
    }
    
    private var saveButton: some View {
        Button {
            viewModel.saveTask()
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

    private func close() {
        onCancel?()
        dismiss()
    }

    private func deleteTask() {
        viewModel.deleteTask()
        onSave?()
        dismiss()
    }
}

#Preview {
    AddTaskView()
}
