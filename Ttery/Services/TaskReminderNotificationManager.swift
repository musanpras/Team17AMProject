//
//  TaskReminderNotificationManager.swift
//  Team17Project
//
//  Created by Muhammad Sandy Prastyo on 03/06/26.
//

import Foundation
import UserNotifications

final class TaskReminderNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = TaskReminderNotificationManager()

    private let reminderPrefix = "taskReminder_"
    private let notificationCenter = UNUserNotificationCenter.current()

    let number: Int = Int.random(in: 1...2)

    private override init() {
        super.init()
        notificationCenter.delegate = self
    }

    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    func scheduleDailyReminders(
        startMinute: Int,
        endMinute: Int,
        intervalMinutes: Int,
        activeTaskTitle: String?,
        selectedTaskCount: Int
    ) {
        guard startMinute < endMinute, intervalMinutes > 0 else {
            removeAllReminders()
            return
        }

        removeAllReminders { [weak self] in
            guard let self else { return }

            let content = makeReminderContent(
                activeTaskTitle: activeTaskTitle,
                selectedTaskCount: selectedTaskCount
            )

            for currentMinutes in stride(from: startMinute, through: endMinute, by: intervalMinutes) {
                let hour = currentMinutes / 60
                let minute = currentMinutes % 60
                let identifier = "\(reminderPrefix)\(hour)_\(minute)"

                scheduleNotification(
                    hour: hour,
                    minute: minute,
                    content: content,
                    identifier: identifier
                )
            }
        }
    }
    
    private func makeReminderContent(
        activeTaskTitle: String?,
        selectedTaskCount: Int
    ) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = WidgetMessageProvider.title(
            activeTaskTitle: activeTaskTitle,
            selectedTaskCount: selectedTaskCount,
            greetingVariant: number
        )
        content.body = WidgetMessageProvider.body(
            activeTaskTitle: activeTaskTitle,
            selectedTaskCount: selectedTaskCount,
            greetingVariant: number
        )
        return content
    }

    private func scheduleNotification(
        hour: Int,
        minute: Int,
        content: UNMutableNotificationContent,
        identifier: String
    ) {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )

        notificationCenter.add(request)
    }
    
    func removeAllReminders() {
        removeAllReminders(completion: nil)
    }

    private func removeAllReminders(completion: (() -> Void)?) {
        notificationCenter.getPendingNotificationRequests { [weak self] requests in
            guard let self else { return }

            let identifiers = requests
                .map(\.identifier)
                .filter { $0.hasPrefix(self.reminderPrefix) }

            notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
            completion?()
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound, .list]
    }
}
