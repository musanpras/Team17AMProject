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
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            DailyState.self,
            TaskItem.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init () {
        let context = sharedModelContainer.mainContext
        let descriptor = FetchDescriptor<TaskItem>()
        let existing = (try? context.fetch(descriptor)) ?? []
        
        guard existing.isEmpty else { return }
        for task in TaskItem.defaultTasks {
            context.insert(task)
        }
        
    }
    
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
                TaskReminderNotificationManager.shared.requestAuthorization()

                // Keep splash visible for 2.5 seconds, then transition out
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.isSplashActive = false
                    }
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}

