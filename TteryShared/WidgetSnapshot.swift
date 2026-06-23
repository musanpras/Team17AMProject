//
//  WidgetSnapshot.swift
//  TteryShared
//

import Foundation

struct WidgetSnapshot: Codable, Equatable {
    var currentEnergy: Int
    var maxEnergy: Int
    var activeTaskTitle: String?
    var selectedTaskCount: Int
    var greetingVariant: Int

    var energyValue: Double {
        EnergyDisplay.normalizedValue(current: currentEnergy, max: maxEnergy)
    }

    static let placeholder = WidgetSnapshot(
        currentEnergy: 60,
        maxEnergy: 100,
        activeTaskTitle: nil,
        selectedTaskCount: 2,
        greetingVariant: 1
    )

    static let empty = WidgetSnapshot(
        currentEnergy: 100,
        maxEnergy: 100,
        activeTaskTitle: nil,
        selectedTaskCount: 0,
        greetingVariant: 1
    )
}
