//
//  LowEnergyWarningBadge.swift
//  Team17Project
//

import SwiftUI

struct LowEnergyWarningBadge: View {
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Image(systemName: "exclamationmark")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 18, height: 18)
                .background(Circle().fill(.yellow))
        }
        .buttonStyle(.plain)
        .offset(x: 30, y: -35)
    }
}

#Preview {
    LowEnergyWarningBadge(onTap: {})
}
