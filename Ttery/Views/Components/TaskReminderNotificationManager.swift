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
    
    private let reminderIdentifier = "hourly-task-reminder"
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    func scheduleHourlyReminder(activeTaskTitle: String?, selectedTaskCount: Int) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [reminderIdentifier])
        
        let content = UNMutableNotificationContent()
        content.sound = .default
        
        if let activeTaskTitle, !activeTaskTitle.isEmpty {
            content.title = "Keep going"
            content.body = "You're working on \(activeTaskTitle). Take a moment to check your energy."
        } else if selectedTaskCount > 0 {
            content.title = "Ready for your next task?"
            content.body = "You have \(selectedTaskCount) task\(selectedTaskCount == 1 ? "" : "s") waiting in your list."
        } else {
            content.title = "Pick a task"
            content.body = "Your task list is empty. Add or choose something small to start."
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true)
        let request = UNNotificationRequest(
            identifier: reminderIdentifier,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request)
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound, .list]
    }
}
