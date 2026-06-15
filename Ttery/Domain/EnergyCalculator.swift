//
//  EnergyCalculator.swift
//  Team17Project
//

import SwiftUI

enum EnergyCalculator {
    static let scaleFactor = 10

    static func color(for value: Double) -> Color {
        switch value {
        case ..<0.25: return .red
        case 0.25..<0.5: return .orange
        case 0.5..<0.75: return .yellow
        default: return .green
        }
    }

    static func mascotEnergy(for value: Double) -> String {
        switch value {
        case 0: return "depleted"
        case 0.01..<0.25: return "tired"
        case 0.25..<0.5: return "idle"
        case 0.5..<0.75: return "energized"
        default: return "hyped"
        }
    }

    static func normalizedValue(current: Int, max: Int) -> Double {
        guard max > 0 else { return 0 }
        return Double(current) / Double(max)
    }

    static func energyCost(for task: TaskItem) -> Int {
        task.energyImpact * scaleFactor
    }

    static func isLowEnergy(task: TaskItem, currentEnergy: Int) -> Bool {
        task.isDraining && energyCost(for: task) > currentEnergy
    }

    static func applyCompletion(task: TaskItem, to state: DailyState) {
        if task.isDraining {
            state.currentEnergy -= energyCost(for: task)
        } else {
            state.currentEnergy += energyCost(for: task)
        }
        state.currentEnergy = max(0, min(state.currentEnergy, state.maxEnergy))
    }

    static func previewEnergyChange(task: TaskItem, currentEnergy: Int, adding: Bool) -> Int {
        let delta = energyCost(for: task)
        if task.isDraining {
            return currentEnergy + (adding ? -delta : delta)
        }
        return currentEnergy + (adding ? delta : -delta)
    }
}
