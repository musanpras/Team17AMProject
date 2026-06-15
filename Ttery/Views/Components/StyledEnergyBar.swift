//
//  StyledEnergyBar.swift
//  Team17Project
//

import SwiftUI

struct StyledEnergyBar: View {
    enum Style {
        case home
        case market

        var boltFontSize: CGFloat {
            switch self {
            case .home: return 28
            case .market: return 20
            }
        }

        var boltFrameSize: CGFloat {
            switch self {
            case .home: return 42
            case .market: return 30
            }
        }

        var boltOffsetX: CGFloat {
            switch self {
            case .home: return 8
            case .market: return 6
            }
        }

        var boltShadowY: CGFloat {
            switch self {
            case .home: return 4
            case .market: return 2
            }
        }

        var barWidth: CGFloat {
            switch self {
            case .home: return 160
            case .market: return 100
            }
        }

        var barHeight: CGFloat {
            switch self {
            case .home: return 32
            case .market: return 20
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .home: return 16
            case .market: return 8
            }
        }

        var barShadowY: CGFloat {
            switch self {
            case .home: return 3
            case .market: return 2
            }
        }
    }

    let value: Double
    let energyColor: Color
    let style: Style

    private var clampedValue: Double {
        min(max(value, 0), 1)
    }

    private var barShape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: 0,
            bottomLeadingRadius: 0,
            bottomTrailingRadius: style.cornerRadius,
            topTrailingRadius: style.cornerRadius
        )
    }

    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "bolt.fill")
                .font(.system(size: style.boltFontSize, weight: .bold))
                .foregroundStyle(.black)
                .frame(width: style.boltFrameSize, height: style.boltFrameSize)
                .background(Circle().fill(.white))
                .overlay(Circle().stroke(.black, lineWidth: 2))
                .background(
                    Circle()
                        .fill(.white)
                        .shadow(color: .black, radius: 0, x: 0, y: style.boltShadowY)
                )
                .zIndex(1)
                .offset(x: style.boltOffsetX)

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    barShape
                        .fill(.black)

                    barShape
                        .fill(.black)
                        .offset(y: style.barShadowY)

                    barShape
                        .fill(energyColor)
                        .frame(width: proxy.size.width * clampedValue)
                }
            }
            .frame(width: style.barWidth, height: style.barHeight)
            .overlay(barShape.stroke(.black, lineWidth: 1))
        }
        .frame(maxWidth: style == .home ? .infinity : nil)
    }
}

#Preview {
    VStack(spacing: 24) {
        StyledEnergyBar(value: 0.6, energyColor: .green, style: .home)
        StyledEnergyBar(value: 0.4, energyColor: .orange, style: .market)
    }
    .padding()
}
