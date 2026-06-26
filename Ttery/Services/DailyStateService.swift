//
//  DailyStateService.swift
//  Team17Project
//

import Foundation
import SwiftData

struct DailyStateService {
    let modelContext: ModelContext
    private let settingsPreferences = SettingsPreferences()

    @discardableResult
    func ensureExists(in states: [DailyState]) -> DailyState? {
        if let state = states.first {
            settingsPreferences.sync(state)
            refreshForNewDayIfNeeded(state)
            save()
            return state
        }

        let state = DailyState()
        settingsPreferences.sync(state)
        modelContext.insert(state)
        save()
        return state
    }

    func refreshForNewDayIfNeeded(_ state: DailyState) {
        guard state.resetsEnergyDaily else { return }

        let calendar = Calendar.current
        guard !calendar.isDateInToday(state.lastUpdated) else { return }

        state.currentEnergy = state.maxEnergy
        state.lastUpdated = .now
        save()
    }

    func setResetsEnergyDaily(_ enabled: Bool, for state: DailyState) {
        settingsPreferences.setResetsEnergyDaily(enabled)
        state.resetsEnergyDaily = enabled
        if enabled {
            refreshForNewDayIfNeeded(state)
        }
        save()
    }

    @discardableResult
    func save() -> Bool {
        do {
            try modelContext.save()
            return true
        } catch {
            assertionFailure("Failed to save DailyState: \(error)")
            return false
        }
    }
}
