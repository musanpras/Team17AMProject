//
//  EnergyDisplay.swift
//  TteryShared
//

import SwiftUI

enum EnergyDisplay {
    static func normalizedValue(current: Int, max: Int) -> Double {
        guard max > 0 else { return 0 }
        return Double(current) / Double(max)
    }

    static func color(for value: Double) -> Color {
        switch value {
        case ..<0.25: return .red
        case 0.25..<0.5: return .orange
        case 0.5..<0.75: return .yellow
        default: return .green
        }
    }

    static func label(current: Int, max: Int) -> String {
        "\(current)/\(max)"
    }
}
