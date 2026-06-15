//
//  HomeSelectedTaskGrid.swift
//  Team17Project
//

import SwiftUI

struct HomeSelectedTaskGrid: View {
    struct Slot: Identifiable {
        let id = UUID()
        let task: TaskItem
    }

    let slots: [Slot]
    let emptySlotCount: Int
    let currentEnergy: Int
    let onTaskTap: (TaskItem) -> Void
    let onLowEnergyWarning: (TaskItem) -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 4)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: .black, radius: 0, x: 0, y: 6)

            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(slots.reversed()) { slot in
                    let task = slot.task
                    let isLowEnergy = EnergyCalculator.isLowEnergy(task: task, currentEnergy: currentEnergy)

                    ZStack(alignment: .topTrailing) {
                        ActivityCell(task: task)

                        if isLowEnergy {
                            LowEnergyWarningBadge {
                                onLowEnergyWarning(task)
                            }
                        }
                    }
                    .onTapGesture {
                        Haptic.selection()
                        onTaskTap(task)
                    }
                }

                ForEach(0..<emptySlotCount, id: \.self) { _ in
                    EmptyTaskSlot()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black, lineWidth: 1)
            )
        }
        .frame(height: 96)
    }
}

#Preview {
    HomeSelectedTaskGrid(
        slots: [],
        emptySlotCount: 4,
        currentEnergy: 50,
        onTaskTap: { _ in },
        onLowEnergyWarning: { _ in }
    )
    .padding()
}
