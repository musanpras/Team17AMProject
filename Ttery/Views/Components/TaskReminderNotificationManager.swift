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
    
    let number: Int = Int.random(in: 1...2)
    
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
            content.title = "just checking in..."
            content.body = "done with \(activeTaskTitle) yet?"
        } else if selectedTaskCount > 0 {
            content.title = "yo, it's ttery!"
            content.body = "i'm bored, let's do something"
        } else {
            content.title = number == 1 ? "ttery here." : "ttery says hello"
            content.body = number == 1 ? "what's been up this past hour?" : "how are you doing?"
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
