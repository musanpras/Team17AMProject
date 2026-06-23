//
//  EmptyTaskSlot.swift
//  Team17Project
//

import SwiftUI

struct EmptyTaskSlot: View {
    var body: some View {
        Color.white.opacity(0.35)
            .frame(maxWidth: .infinity, minHeight: 94)
            .border(.black, width: 0.5)
    }
}

#Preview {
    EmptyTaskSlot()
}
