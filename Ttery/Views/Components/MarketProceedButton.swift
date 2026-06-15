//
//  MarketProceedButton.swift
//  Team17Project
//

import SwiftUI

struct MarketProceedButton: View {
    let selectedCount: Int
    let maxSelectedTasks: Int
    let onProceed: () -> Void

    var body: some View {
        Button {
            Haptic.light()
            onProceed()
        } label: {
            Text("\(selectedCount)/\(maxSelectedTasks) tasks selected. proceed?")
                .font(.system(size: 14))
                .underline()
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .disabled(selectedCount == 0)
    }
}

#Preview {
    MarketProceedButton(selectedCount: 2, maxSelectedTasks: 4, onProceed: {})
}
