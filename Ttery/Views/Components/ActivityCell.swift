//
//  ActivityCell.swift
//  Team17Project
//
//  Created by Imelda Damayanti on 26/05/26.
//

import SwiftUI

struct ActivityCell: View {
    let icon: String
    let title: String
    let energyImpact: Int
    let isDraining: Bool

    init(
        icon: String = "🚿",
        title: String = "shower",
        energyImpact: Int = 2,
        isDraining: Bool = false
    ) {
        self.icon = icon
        self.title = title
        self.energyImpact = energyImpact
        self.isDraining = isDraining
    }

    init(task: TaskItem) {
        self.icon = task.icon
        self.title = task.title
        self.energyImpact = task.energyImpact
        self.isDraining = task.isDraining
    }

    var body: some View {
        VStack(spacing: 3) {
            Text(icon)
                .font(.system(size: 30))
                .frame(height: 34)

            Text(title)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.65)
            
            HStack(spacing: 3) {
                ForEach(1...energyImpact, id: \.self) {_ in
                    Image(systemName: isDraining ? "arrowshape.down.fill" : "arrowshape.up")
                        .font(.system(size: 12))
                        .foregroundStyle(.black)
                    
                }
            }

        }
        .frame(maxWidth: .infinity, minHeight: 94)
        .background(.white.opacity(0.75))
        .border(.black, width: 0.5)
    }
}

#Preview {
    ActivityCell()
}
