//
//  MarketViewModel.swift
//  Team17Project
//

import Foundation
import SwiftData

@Observable
final class MarketViewModel {
    var showingAdd = false
    var showNotif = false
    var selectedFilter: EnergyFilter = .energizing
    var editingTask: TaskItem?
    var tempTask: TaskItem?
    var remainingEnergy = 0
    var pressedTask: TaskItem?

    private let dailyStateService: DailyStateService
    private let taskRepository: TaskRepository
    private let notificationService: TaskReminderNotificationManager

    init(
        modelContext: ModelContext,
        notificationService: TaskReminderNotificationManager = .shared
    ) {
        self.dailyStateService = DailyStateService(modelContext: modelContext)
        self.taskRepository = TaskRepository(modelContext: modelContext)
        self.notificationService = notificationService
    }

    func onAppear(states: [DailyState], tasks: [TaskItem]) {
        remainingEnergy = Int(states.first?.currentEnergy ?? 0)
        dailyStateService.ensureExists(in: states)
        taskRepository.syncPendingFromCommitted(tasks: tasks)
    }

    func energyValue(for dailyState: DailyState?) -> Double {
        guard let dailyState, dailyState.maxEnergy > 0 else { return 0 }
        return EnergyCalculator.normalizedValue(
            current: remainingEnergy,
            max: dailyState.maxEnergy
        )
    }

    func pendingSelectedTasks(from tasks: [TaskItem]) -> [TaskItem] {
        TaskSelection.expandedPendingTasks(from: tasks)
    }

    func pendingSelectedSlots(from tasks: [TaskItem]) -> [MarketSelectedTaskGrid.Slot] {
        TaskSelection.pendingSlots(from: tasks)
    }

    func filteredTasks(from tasks: [TaskItem]) -> [TaskItem] {
        tasks.filter { selectedFilter.matches($0) }
    }

    func emptySelectedSlotCount(from tasks: [TaskItem]) -> Int {
        TaskSelection.emptySlotCount(selectedCount: pendingSelectedTasks(from: tasks).count)
    }

    func presentAddTask() {
        editingTask = nil
        showingAdd = true
    }

    func presentEditTask(_ task: TaskItem) {
        editingTask = task
        showingAdd = true
    }

    func dismissAddTask() {
        editingTask = nil
        showingAdd = false
    }

    func presentLowEnergyWarning(for task: TaskItem) {
        tempTask = task
        showNotif = true
    }

    func confirmLowEnergyWarning(tasks: [TaskItem]) {
        if let task = tempTask {
            addSelection(for: task, tasks: tasks)
        }
        tempTask = nil
        showNotif = false
    }

    func dismissWarning() {
        tempTask = nil
        showNotif = false
    }

    func addSelection(for task: TaskItem, tasks: [TaskItem]) {
        guard pendingSelectedTasks(from: tasks).count < TaskSelection.maxSlots else { return }
        taskRepository.addPendingSelection(task)
        remainingEnergy = EnergyCalculator.previewEnergyChange(
            task: task,
            currentEnergy: remainingEnergy,
            adding: true
        )
    }

    func removeOneSelection(for task: TaskItem) {
        guard task.pendingSelectionCount > 0 else { return }
        taskRepository.removePendingSelection(task)
        remainingEnergy = EnergyCalculator.previewEnergyChange(
            task: task,
            currentEnergy: remainingEnergy,
            adding: false
        )
    }

    func proceedWithSelectedTasks(tasks: [TaskItem]) {
        let pending = pendingSelectedTasks(from: tasks)
        taskRepository.commitPendingSelection(tasks: tasks, pending: pending)
        notificationService.scheduleHourlyReminder(
            activeTaskTitle: nil,
            selectedTaskCount: min(pending.count, TaskSelection.maxSlots)
        )
    }
}
