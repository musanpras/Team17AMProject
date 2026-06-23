//
//  MarketSelectedTaskGrid.swift
//  Team17Project
//

import SwiftUI

struct MarketSelectedTaskGrid: View {
    struct Slot: Identifiable {
        let id = UUID()
        let task: TaskItem
        let isCommitted: Bool
    }

    let slots: [Slot]
    let emptySlotCount: Int
    let onRemove: (TaskItem) -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 4)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: .black, radius: 0, x: 0, y: 6)

            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(slots.reversed()) { slot in
                    let task = slot.task

                    ZStack(alignment: .topTrailing) {
                        ActivityCell(task: task)
                            .background(slot.isCommitted ? Color.gray : .white.opacity(0.75))

                        if !slot.isCommitted {
                            Button {
                                Haptic.light()
                                onRemove(task)
                            } label: {
                                Image(systemName: "minus")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundStyle(.white)
                                    .frame(width: 18, height: 18)
                                    .background(Circle().fill(.red))
                            }
                            .buttonStyle(.plain)
                            .offset(x: -4, y: 4)
                        }
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
    MarketSelectedTaskGrid(
        slots: [],
        emptySlotCount: 4,
        onRemove: { _ in }
    )
    .padding()
}
