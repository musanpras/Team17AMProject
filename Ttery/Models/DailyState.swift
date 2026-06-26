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
    static let defaultCurrentEnergy = 100
    static let defaultMaxEnergy = 100
    static let defaultReminderIntervalMinutes = 60
    static let defaultReminderStartMinute = 480
    static let defaultReminderEndMinute = 1320
    static let defaultReminderHours = 1

    var currentEnergy: Int = DailyState.defaultCurrentEnergy
    var maxEnergy: Int = DailyState.defaultMaxEnergy
    var lastUpdated: Date = Date()
    var resetsEnergyDaily: Bool = true
    
    var remindersEnabled: Bool = true
    var reminderIntervalMinutes: Int = DailyState.defaultReminderIntervalMinutes
    var reminderStartMinute: Int = DailyState.defaultReminderStartMinute
    var reminderEndMinute: Int = DailyState.defaultReminderEndMinute
    var reminderHours: Int = DailyState.defaultReminderHours
    
    init(
        currentEnergy: Int = DailyState.defaultCurrentEnergy,
        maxEnergy: Int = DailyState.defaultMaxEnergy,
        lastUpdated: Date = .now,
        resetsEnergyDaily: Bool = true,
        remindersEnabled: Bool = true,
        reminderIntervalMinutes: Int = DailyState.defaultReminderIntervalMinutes,
        reminderStartMinute: Int = DailyState.defaultReminderStartMinute,
        reminderEndMinute: Int = DailyState.defaultReminderEndMinute,
        reminderHours: Int = DailyState.defaultReminderHours
    ) {
        self.currentEnergy = currentEnergy
        self.maxEnergy = maxEnergy
        self.lastUpdated = lastUpdated
        self.resetsEnergyDaily = resetsEnergyDaily
        
        self.remindersEnabled = remindersEnabled
        self.reminderIntervalMinutes = reminderIntervalMinutes
        self.reminderStartMinute = reminderStartMinute
        self.reminderEndMinute = reminderEndMinute
        self.reminderHours = reminderHours
    }
}

extension DailyState {

    var formattedStart: String {
        formatTime(from: reminderStartMinute)
    }

    var formattedEnd: String {
        formatTime(from: reminderEndMinute)
    }

    private func formatTime(from minutes: Int) -> String {

        let hour = minutes / 60
        let minute = minutes % 60

        let dateComponents = DateComponents(
            hour: hour,
            minute: minute
        )

        guard let date = Calendar.current.date(
            from: dateComponents
        ) else {
            return "--:--"
        }

        let formatter = DateFormatter()
        formatter.timeStyle = .short

        return formatter.string(from: date)
    }
}
