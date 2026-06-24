//
//  HomeViewModel.swift
//  Team17Project
//

import Foundation
import SwiftData

@MainActor
@Observable
final class HomeViewModel {
    var activeTask: TaskItem?
    var tempTask: TaskItem?
    var showNotif = false

    private let dailyStateService: DailyStateService
    private let taskRepository: TaskRepository
    private let notificationService: TaskReminderNotificationManager

    init(
        modelContext: ModelContext,
        notificationService: TaskReminderNotificationManager? = nil
    ) {
        self.dailyStateService = DailyStateService(modelContext: modelContext)
        self.taskRepository = TaskRepository(modelContext: modelContext)
        self.notificationService = notificationService ?? .shared
    }

    func onAppear(states: [DailyState], tasks: [TaskItem]) {
        dailyStateService.ensureExists(in: states)
        scheduleTaskReminder(tasks: tasks, dailyState: states.first)
    }

    func energyValue(for dailyState: DailyState?) -> Double {
        guard let dailyState else { return 0 }
        return EnergyCalculator.normalizedValue(
            current: dailyState.currentEnergy,
            max: dailyState.maxEnergy
        )
    }

    func selectedTasks(from tasks: [TaskItem]) -> [TaskItem] {
        TaskSelection.expandedSelectedTasks(from: tasks)
    }

    func selectedTaskSlots(from tasks: [TaskItem]) -> [HomeSelectedTaskGrid.Slot] {
        TaskSelection.homeSlots(from: tasks)
    }

    func emptySelectedSlotCount(from tasks: [TaskItem]) -> Int {
        TaskSelection.emptySlotCount(selectedCount: selectedTasks(from: tasks).count)
    }

    func handleTaskTap(_ task: TaskItem, currentEnergy: Int) {
        if EnergyCalculator.isLowEnergy(task: task, currentEnergy: currentEnergy) {
            showNotif = true
            tempTask = task
        } else {
            activeTask = task
        }
    }

    func confirmLowEnergyWarning(tasks: [TaskItem], dailyState: DailyState?) {
        activeTask = tempTask
        tempTask = nil
        showNotif = false
        syncWidget(tasks: tasks, dailyState: dailyState)
    }

    func dismissWarning() {
        showNotif = false
    }

    func deleteActiveTask(tasks: [TaskItem], dailyState: DailyState?) {
        Haptic.medium()
        guard let task = activeTask else { return }
        taskRepository.removeActiveSelection(task)
        activeTask = nil
        scheduleTaskReminder(tasks: tasks, dailyState: dailyState)
    }

    func completeActiveTask(dailyState: DailyState?, tasks: [TaskItem]) {
        Haptic.medium()
        guard let task = activeTask, let dailyState else { return }
        taskRepository.complete(task, dailyState: dailyState)
        activeTask = nil
        scheduleTaskReminder(tasks: tasks, dailyState: dailyState)
    }

    func scheduleTaskReminder(tasks: [TaskItem], dailyState: DailyState?) {
        let selectedCount = selectedTasks(from: tasks).count
        notificationService.scheduleReminders(
            for: dailyState,
            activeTaskTitle: activeTask?.title,
            selectedTaskCount: selectedCount
        )
        syncWidget(tasks: tasks, dailyState: dailyState)
    }

    func syncWidget(tasks: [TaskItem], dailyState: DailyState?) {
        WidgetSyncService.update(
            from: dailyState,
            activeTaskTitle: activeTask?.title,
            selectedTaskCount: selectedTasks(from: tasks).count
        )
    }
}
