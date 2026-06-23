//
//  TteryWidgetView.swift
//  TteryWidget
//

import SwiftUI
import WidgetKit

struct TteryWidgetView: View {
    let entry: TteryWidgetEntry

    private var energyValue: Double {
        entry.snapshot.energyValue
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
//            HStack {
//                Text(EnergyDisplay.label(
//                    current: entry.snapshot.currentEnergy,
//                    max: entry.snapshot.maxEnergy
//                ))
//                .font(.system(size: 14, weight: .bold))
//                .foregroundStyle(.black)
//
//                Spacer()
//            }
            Text(entry.header)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.black)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, alignment: .leading)

            EnergyBar(
                value: energyValue,
                fillColor: EnergyDisplay.color(for: energyValue),
                compact: true,
                showsPercentage: false
            )

            Text(entry.message)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.black)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .containerBackground(for: .widget) {
            widgetBackground
        }
    }

    private var widgetBackground: some View {
        ZStack {
            Color(red: 0.96, green: 0.96, blue: 0.97)

            Canvas { context, size in
                let spacing: CGFloat = 14
                var path = Path()

                stride(from: 0, through: size.width, by: spacing).forEach { x in
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: size.height))
                }

                stride(from: 0, through: size.height, by: spacing).forEach { y in
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: size.width, y: y))
                }

                context.stroke(path, with: .color(.black.opacity(0.05)), lineWidth: 0.5)
            }
        }
    }
}

#Preview(as: .systemSmall) {
    TteryWidget()
} timeline: {
    TteryWidgetEntry(date: .now, snapshot: .placeholder)
    TteryWidgetEntry(date: .now, snapshot: .empty)
}
