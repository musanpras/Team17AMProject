//
//  DailyState.swift
//  Team17Project
//
//  Created by Muhammad Sandy Prastyo on 26/05/26.
//

import SwiftData
import Foundation

@Model
class DailyState {

    var currentEnergy: Int
    var maxEnergy: Int
    var lastUpdated: Date

    init(
        currentEnergy: Int = 100,
        maxEnergy: Int = 100,
        lastUpdated: Date = .now
    ) {
        self.currentEnergy = currentEnergy
        self.maxEnergy = maxEnergy
        self.lastUpdated = lastUpdated
    }
}
