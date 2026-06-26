//
//  SettingsPreferences.swift
//  Ttery
//

import Foundation

struct SettingsPreferences {
    private enum Key {
        static let resetsEnergyDaily = "settings.resetsEnergyDaily"
        static let remindersEnabled = "settings.remindersEnabled"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func resetsEnergyDaily(fallback: Bool = true) -> Bool {
        bool(forKey: Key.resetsEnergyDaily, fallback: fallback)
    }

    func setResetsEnergyDaily(_ value: Bool) {
        defaults.set(value, forKey: Key.resetsEnergyDaily)
    }

    func remindersEnabled(fallback: Bool = true) -> Bool {
        bool(forKey: Key.remindersEnabled, fallback: fallback)
    }

    func setRemindersEnabled(_ value: Bool) {
        defaults.set(value, forKey: Key.remindersEnabled)
    }

    func sync(_ state: DailyState) {
        if defaults.object(forKey: Key.resetsEnergyDaily) == nil {
            setResetsEnergyDaily(state.resetsEnergyDaily)
        } else {
            state.resetsEnergyDaily = resetsEnergyDaily(fallback: state.resetsEnergyDaily)
        }

        if defaults.object(forKey: Key.remindersEnabled) == nil {
            setRemindersEnabled(state.remindersEnabled)
        } else {
            state.remindersEnabled = remindersEnabled(fallback: state.remindersEnabled)
        }
    }

    private func bool(forKey key: String, fallback: Bool) -> Bool {
        guard defaults.object(forKey: key) != nil else { return fallback }
        return defaults.bool(forKey: key)
    }
}
