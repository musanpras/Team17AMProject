//
//  Ttery.swift
//  Ttery
//
//  Created by Muhammad Sandy Prastyo on 22/05/26.
//

import SwiftData
import SwiftUI

@main
struct TteryApp: App {
    @State private var isSplashActive = true
    @State private var didConfigureApp = false

    private let sharedModelContainer = ModelContainerFactory.make()

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isSplashActive {
                    SplashScreenView()
                } else {
                    MainTabView()
                }
            }
            .onAppear {
                configureAppIfNeeded()

                TaskReminderNotificationManager.shared.requestAuthorization()

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isSplashActive = false
                    }
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }

    private func configureAppIfNeeded() {
        guard !didConfigureApp else { return }
        didConfigureApp = true

        let context = sharedModelContainer.mainContext
        TaskSeeder.seedDefaultTasksIfNeeded(in: context)

        let states = (try? context.fetch(FetchDescriptor<DailyState>())) ?? []
        if let state = states.first,
           state.remindersEnabled {

            TaskReminderNotificationManager.shared.scheduleDailyReminders(
                startMinute: state.reminderStartMinute,
                endMinute: state.reminderEndMinute,
                intervalMinutes: state.reminderIntervalMinutes,
                activeTaskTitle: nil,
                selectedTaskCount: 0
            )
            
        }
        _ = DailyStateService(modelContext: context).ensureExists(in: states)
    }
}
