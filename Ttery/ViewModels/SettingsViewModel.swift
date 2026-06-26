//
//  SettingsViewModel.swift
//  Team17Project
//

import Foundation
import SwiftData

@MainActor
@Observable
final class SettingsViewModel {
    private let dailyStateService: DailyStateService
    private let notificationService: TaskReminderNotificationManager
    private let settingsPreferences: SettingsPreferences
    private let calendar: Calendar

    init(
        modelContext: ModelContext,
        notificationService: TaskReminderNotificationManager? = nil,
        settingsPreferences: SettingsPreferences = SettingsPreferences(),
        calendar: Calendar = .current
    ) {
        self.dailyStateService = DailyStateService(modelContext: modelContext)
        self.notificationService = notificationService ?? .shared
        self.settingsPreferences = settingsPreferences
        self.calendar = calendar
    }

    func onAppear(states: [DailyState]) {
        _ = dailyStateService.ensureExists(in: states)
    }

    func resetsEnergyDaily(for state: DailyState?) -> Bool {
        settingsPreferences.resetsEnergyDaily(fallback: state?.resetsEnergyDaily ?? true)
    }

    func setResetsEnergyDaily(_ enabled: Bool, state: DailyState?, tasks: [TaskItem]) {
        guard let state else { return }
        dailyStateService.setResetsEnergyDaily(enabled, for: state)
        WidgetSyncService.update(
            from: state,
            activeTaskTitle: nil,
            selectedTaskCount: TaskSelection.expandedSelectedTasks(from: tasks).count
        )
    }

    func remindersEnabled(for state: DailyState?) -> Bool {
        settingsPreferences.remindersEnabled(fallback: state?.remindersEnabled ?? true)
    }

    func setRemindersEnabled(_ enabled: Bool, state: DailyState?) -> Bool {
        guard let state else { return true }
        settingsPreferences.setRemindersEnabled(enabled)
        state.remindersEnabled = enabled
        dailyStateService.save()
        return updateReminder(for: state)
    }

    func setReminderHours(_ hours: Int, state: DailyState?) -> Bool {
        guard let state else { return true }
        state.reminderHours = hours
        state.reminderIntervalMinutes = hours * 60
        dailyStateService.save()
        return updateReminder(for: state)
    }

    func date(from minutes: Int) -> Date {
        let hour = minutes / 60
        let minute = minutes % 60

        return calendar.date(
            bySettingHour: hour,
            minute: minute,
            second: 0,
            of: .now
        ) ?? .now
    }

    func setReminderStartDate(_ date: Date, state: DailyState?) -> Bool {
        guard let state else { return true }
        let minutes = minutes(from: date)
        guard minutes < state.reminderEndMinute else { return false }

        state.reminderStartMinute = minutes
        dailyStateService.save()
        return updateReminder(for: state)
    }

    func setReminderEndDate(_ date: Date, state: DailyState?) -> Bool {
        guard let state else { return true }
        let minutes = minutes(from: date)
        guard state.reminderStartMinute < minutes else { return false }

        state.reminderEndMinute = minutes
        dailyStateService.save()
        return updateReminder(for: state)
    }

    func updateReminder(for state: DailyState) -> Bool {
        guard state.reminderStartMinute < state.reminderEndMinute else { return false }

        notificationService.scheduleReminders(
            for: state,
            activeTaskTitle: nil,
            selectedTaskCount: 0
        )

        return true
    }

    private func minutes(from date: Date) -> Int {
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        return hour * 60 + minute
    }
}
