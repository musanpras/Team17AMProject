//
//  MarketActivityGrid.swift
//  Team17Project
//

import SwiftUI

struct MarketActivityGrid: View {
    let tasks: [TaskItem]
    let remainingEnergy: Int
    let pressedTask: TaskItem?
    let onAddTask: () -> Void
    let onEditTask: (TaskItem) -> Void
    let onSelectTask: (TaskItem) -> Void
    let onLowEnergyWarning: (TaskItem) -> Void
    let onPressChange: (TaskItem?) -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 4)

    private var visibleRows: Int {
        min(4, Int(ceil(Double(tasks.count + 1) / 4.0)))
    }

    private var dynamicBottomPadding: CGFloat {
        switch visibleRows {
        case 3: return -10
        case 2: return 90
        case 1: return 185
        default: return -97
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: .black, radius: 0, x: 0, y: 6)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    AddTaskButton(onTap: onAddTask)

                    ForEach(tasks.reversed()) { task in
                        let isPressed = pressedTask.map(ObjectIdentifier.init) == ObjectIdentifier(task)
                        let isLowEnergy = EnergyCalculator.isLowEnergy(task: task, currentEnergy: remainingEnergy)

                        ZStack {
                            ActivityCell(task: task)

                            if isLowEnergy {
                                LowEnergyWarningBadge {
                                    onLowEnergyWarning(task)
                                }
                            }
                        }
                        .scaleEffect(isPressed ? 1.03 : 1)
                        .offset(y: isPressed ? -4 : 0)
                        .shadow(
                            color: .black.opacity(isPressed ? 0.15 : 0),
                            radius: isPressed ? 8 : 0
                        )
                        .zIndex(isPressed ? 1 : 0)
                        .animation(.snappy(duration: 0.2), value: pressedTask.map(ObjectIdentifier.init))
                        .onLongPressGesture(
                            minimumDuration: 0.5,
                            pressing: { pressing in
                                if pressing {
                                    Haptic.medium()
                                }
                                onPressChange(pressing ? task : nil)
                            }
                        ) {
                            onEditTask(task)
                        }
                        .onTapGesture {
                            if isLowEnergy {
                                onLowEnergyWarning(task)
                            } else {
                                onSelectTask(task)
                            }
                        }
                    }
                }
            }
            .frame(height: CGFloat(visibleRows) * 94)
            .scrollBounceBehavior(.basedOnSize)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black, lineWidth: 1)
            )
        }
        .padding(.bottom, dynamicBottomPadding)
    }
}

#Preview {
    MarketActivityGrid(
        tasks: [],
        remainingEnergy: 50,
        pressedTask: nil,
        onAddTask: {},
        onEditTask: { _ in },
        onSelectTask: { _ in },
        onLowEnergyWarning: { _ in },
        onPressChange: { _ in }
    )
    .padding()
}
