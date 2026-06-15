//
//  EnergyFilterPicker.swift
//  Team17Project
//

import SwiftUI

struct EnergyFilterPicker: View {
    @Binding var selectedFilter: EnergyFilter

    var body: some View {
        HStack(spacing: 0) {
            ForEach(EnergyFilter.displayOrder, id: \.self) { filter in
                Button {
                    Haptic.medium()
                    selectedFilter = filter
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: filter.icon)
                            .font(.system(size: 16, weight: .bold))

                        Text(filter.title)
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(selectedFilter == filter ? .white : .clear)
                            .shadow(
                                color: selectedFilter == filter ? .black.opacity(0.18) : .clear,
                                radius: 10,
                                x: 0,
                                y: 2
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.fixedGray6)
                .shadow(color: .black, radius: 0, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(.black, lineWidth: 1)
        )
    }
}

#Preview {
    EnergyFilterPicker(selectedFilter: .constant(.energizing))
        .padding()
}
