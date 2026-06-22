//
//  EnergyBar.swift
//  TteryShared
//
//  Created by Imelda Damayanti on 26/05/26.
//

import SwiftUI

struct EnergyBar: View {
    let value: Double
    var fillColor: Color = .green
    var compact: Bool = false
    var showsPercentage: Bool = true

    private var clampedValue: Double {
        min(max(value, 0), 1)
    }

    private var barHeight: CGFloat {
        compact ? 22 : 40
    }

    private var boltSize: CGFloat {
        compact ? 30 : 56
    }

    private var boltIconSize: CGFloat {
        compact ? 14 : 32
    }

    private var percentageFontSize: CGFloat {
        compact ? 11 : 17
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.black)
                    .frame(width: geo.size.width)
                    .shadow(radius: compact ? 4 : 10, x: 0, y: compact ? 4 : 10)

                Capsule()
                    .fill(fillColor)
                    .frame(width: geo.size.width * clampedValue)

                if showsPercentage {
                    Text("\(Int(clampedValue * 100))")
                        .font(.system(size: percentageFontSize, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(height: barHeight)
        .overlay(alignment: .leading) {
            Circle()
                .fill(Color.white)
                .overlay(
                    Image(systemName: "bolt.fill")
                        .font(.system(size: boltIconSize, weight: .bold))
                        .foregroundStyle(.black)
                )
                .overlay(
                    Circle().stroke(Color.black, lineWidth: compact ? 1.5 : 2)
                )
                .frame(width: boltSize, height: boltSize)
        }
        .padding(.leading, compact ? 2 : 4)
    }
}

#Preview {
    VStack(spacing: 20) {
        EnergyBar(value: 0.6)
        EnergyBar(value: 0.4, fillColor: .orange, compact: true)
    }
    .padding()
}
