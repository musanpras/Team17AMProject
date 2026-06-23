//
//  HomeHeader.swift
//  Team17Project
//

import SwiftUI

struct HomeHeader: View {
    let activeTaskTitle: String?
    let hasActiveTask: Bool
    let onDelete: () -> Void
    let onComplete: () -> Void

    var body: some View {
        HStack {
            if hasActiveTask {
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 54, height: 54)
                        .background(Circle().fill(.red).shadow(color: .black, radius: 0, x: 0, y: 4))
                        .overlay(Circle().stroke(.black, lineWidth: 1))
                }
                .buttonStyle(.plain)
            }

            VStack(spacing: 8) {
                Text(activeTaskTitle != nil ? "\(activeTaskTitle!)." : "pick a task.")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.black)
            }
            .frame(maxWidth: .infinity)

            if hasActiveTask {
                Button(action: onComplete) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 54, height: 54)
                        .background(Circle().fill(.blue).shadow(color: .black, radius: 0, x: 0, y: 4))
                        .overlay(Circle().stroke(.black, lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
        }
        .frame(height: 54)
    }
}

#Preview {
    HomeHeader(
        activeTaskTitle: "shower",
        hasActiveTask: true,
        onDelete: {},
        onComplete: {}
    )
    .padding()
}
