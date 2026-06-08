//
//  MarketViewModel.swift
//  Ttery
//
//  Created during MVVM refactoring.
//  Handles state management and business logic for MarketView.
//

import SwiftUI
import SwiftData

@Observable
class MarketViewModel {
    
    // MARK: - State
    var showingAdd: Bool = false
    var showNotif: Bool = false
    var selectedFilter: EnergyFilter = .energizing
    var editingTask: TaskItem? = nil
    var tempTask: TaskItem? = nil
    var remainingEnergy: Int = 0
    
    // MARK: - Data (set by View from @Query)
    var tasks: [TaskItem] = []
    var states: [DailyState] = []
    
    // MARK: - Context (injected by View)
    var context: ModelContext?
    
    // MARK: - Constants
    let maxSelectedTasks = 4
    
    // MARK: - Nested Types
    struct SelectedTaskSlot: Identifiable {
        let id = UUID()
        let task: TaskItem
        let isCommitted: Bool
    }
    
    // MARK: - Computed Properties
    
    var dailyState: DailyState? {
        states.first
    }
    
    var energyValue: Double {
        guard let dailyState, dailyState.maxEnergy > 0 else { return 0 }
        return Double(remainingEnergy) / Double(dailyState.maxEnergy)
    }
    
    var pendingSelectedTasks: [TaskItem] {
        tasks.flatMap{task in Array(repeating: task, count: task.pendingSelectionCount)
        }
    }
    
    var pendingSelectedSlots: [SelectedTaskSlot] {
        var committedUsed: [ObjectIdentifier: Int] = [:]
        
        return pendingSelectedTasks.map { task in
            let id = ObjectIdentifier(task)
            let used = committedUsed[id, default: 0]
            let isCommitted = used < task.selectedCount
            committedUsed[id] = used + 1
            return SelectedTaskSlot(task: task, isCommitted: isCommitted)
        }
    }
    
    var filteredTasks: [TaskItem] {
        tasks.filter { task in
            selectedFilter == .draining ? task.isDraining : !task.isDraining
        }
    }
    
    var energyColor: Color {
        switch energyValue {
        case ..<0.25: return .red
        case 0.25..<0.5: return .orange
        case 0.5..<0.75: return .yellow
        default: return .green
        }
    }
    
    var emptySelectedSlotCount: Int {
        max(0, maxSelectedTasks - pendingSelectedTasks.count)
    }
    
    var visibleRows: Int {
        min(4, Int(ceil(Double(filteredTasks.count + 1) / 4.0)))
    }
    
    var dynamicBottomPadding: CGFloat {
        switch visibleRows {
        case 3:
            return -10
        case 2:
            return 90
        case 1:
            return 185
            
        default:
            return -97
        }
    }
    
    // MARK: - Methods
    
    /// Initializes remainingEnergy from the persisted daily state
    func initializeEnergy() {
        remainingEnergy = Int(dailyState?.currentEnergy ?? 0)
    }
    
    func proceedWithSelectedTasks() {
        
        
        let pending = Array(pendingSelectedTasks.prefix(maxSelectedTasks))
        
        
        var countMap: [ObjectIdentifier: Int] = [:]
        for task in pending {
            let id = ObjectIdentifier(task)
            countMap[id, default: 0] += 1
        }
        
        for task in tasks {
            let id = ObjectIdentifier(task)
            if let count = countMap[id] {
                task.isSelected = true
                task.selectedCount = count
            } else {
                task.isSelected = false
                task.selectedCount = 0
            }
        }
        
        try? context?.save()
        
        TaskReminderNotificationManager.shared.scheduleHourlyReminder(
            activeTaskTitle: nil,
            selectedTaskCount: pending.count
        )
        
    }
    
    func addSelection(for task: TaskItem) {
        guard pendingSelectedTasks.count < maxSelectedTasks else { return }
        task.pendingSelectionCount += 1
        applyEnergyImpact(task: task, adding: true)
        try? context?.save()
    }
    
    func removeOneSelection(for task: TaskItem) {
        guard task.pendingSelectionCount > 0 else { return }
        task.pendingSelectionCount -= 1
        applyEnergyImpact(task: task, adding: false)
        try? context?.save()
    }
    
    func applyEnergyImpact(task: TaskItem, adding: Bool) {
        let delta = task.energyImpact * 10
        if task.isDraining {
            remainingEnergy += adding ? -delta : delta
        } else {
            remainingEnergy += adding ? delta : -delta
        }
    }
    
    func syncPendingSelectionFromCommittedSelection() {
        
        for task in tasks {
            task.pendingSelectionCount = task.selectedCount
        }
        try? context?.save()
        
    }
    
//    private func seedDefaultTasksIfNeeded() {
//        guard tasks.isEmpty else { return }
//        
//        for task in TaskItem.defaultTasks {
//            context.insert(task)
//        }
//        
//        try? context.save()
//    }
    
    func createStateIfNeeded() {
        guard let context else { return }
        if states.isEmpty {
            let state = DailyState()
            context.insert(state)
            try? context.save()
        }
    }
    
    /// Handles a task tap in the activity grid
    func handleTaskTap(_ task: TaskItem) {
        if task.isDraining && ((task.energyImpact * 10) > remainingEnergy){
            tempTask = task
            showNotif = true
        }else {
            
            addSelection(for: task)
            
        }
    }
    
    /// Shows warning for a specific task (exclamation icon button)
    func showWarningForTask(_ task: TaskItem) {
        tempTask = task
        showNotif = true
    }
    
    /// Confirms the warning and adds the task selection
    func handleWarningConfirm() {
        if let task = tempTask {
            addSelection(for: task)
        }
        tempTask = nil
        showNotif = false
    }
    
    /// Cancels the warning popup
    func handleWarningCancel() {
        tempTask = nil
        showNotif = false
    }
    
    /// Opens the add task popup
    func openAddTask() {
        editingTask = nil
        showingAdd = true
    }
    
    /// Opens the edit task popup for a specific task
    func openEditTask(_ task: TaskItem) {
        editingTask = task
        showingAdd = true
    }
    
    /// Closes the add/edit task popup
    func closeAddTask() {
        editingTask = nil
        showingAdd = false
    }
    
    /// Checks if a task exceeds the remaining energy
    func isTaskOverEnergy(_ task: TaskItem) -> Bool {
        task.isDraining && ((task.energyImpact * 10) > remainingEnergy)
    }
}
