//
//  AddTaskButton.swift
//  Team17Project
//

import SwiftUI

struct AddTaskButton: View {
    let onTap: () -> Void

    var body: some View {
        Button {
            Haptic.light()
            onTap()
        } label: {
            VStack {
                Image(systemName: "plus")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.black)
            }
            .frame(maxWidth: .infinity, minHeight: 94)
            .background(.white.opacity(0.75))
            .border(.black, width: 0.5)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AddTaskButton(onTap: {})
}
