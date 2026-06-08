//
//  HomeViewModel.swift
//  Ttery
//
//  Created during MVVM refactoring.
//  Handles state management and business logic for HomeView.
//

import SwiftUI
import SwiftData

@Observable
class HomeViewModel {
    
    // MARK: - State
    var activeTask: TaskItem? = nil
    var tempTask: TaskItem? = nil
    var showNotif: Bool = false
    
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
    }
    
    // MARK: - Computed Properties
    
    var dailyState: DailyState? {
        states.first
    }
    
    var selectedTasks: [TaskItem] {
        let selected = tasks.filter { $0.isSelected }
           return Array(
               selected.flatMap { task in
                   Array(repeating: task, count: max(1, task.selectedCount))
               }
               .prefix(maxSelectedTasks)
           )
    }
    
    var selectedTaskSlots: [SelectedTaskSlot] {
        selectedTasks.map { SelectedTaskSlot(task: $0) }
    }
    
    var energyValue: Double {
        guard let dailyState, dailyState.maxEnergy > 0 else { return 0 }
        return Double(dailyState.currentEnergy) / Double(dailyState.maxEnergy)
    }
    
    var mascotEnergy: String {
        switch energyValue {
        case 0: return "depleted"
        case 0.01..<0.25: return "tired"
        case 0.25..<0.5: return "idle"
        case 0.5..<0.75: return "energized"
        default: return "hyped"
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
    
    var hasActiveTask: Bool {
        activeTask != nil
    }
    
    var emptySelectedSlotCount: Int {
        max(0, maxSelectedTasks - selectedTasks.count)
    }
    
    // MARK: - Methods
    
    func scheduleTaskReminder() {
        TaskReminderNotificationManager.shared.scheduleHourlyReminder(
            activeTaskTitle: activeTask?.title,
            selectedTaskCount: selectedTasks.count
        )
    }
    
    func complete(_ task: TaskItem) {
        
        guard let state = dailyState else { return }
        
        if task.isDraining {
            state.currentEnergy -= (task.energyImpact * 10)
        } else {
            state.currentEnergy += (task.energyImpact * 10)
        }
        state.currentEnergy = max(0, min(state.currentEnergy, state.maxEnergy))
            
            
            if task.selectedCount > 1 {
                task.selectedCount -= 1
            } else {
                task.selectedCount = 0
                task.isSelected = false
            }
        
        try? context?.save()
    }
    
    func createStateIfNeeded() {
        guard let context else { return }
        
        if states.isEmpty {
            
            let state = DailyState()
            context.insert(state)
            
            try? context.save()
        }
    }
    
    /// Removes the active task from selected slots (trash button action)
    func deleteActiveTask() {
        if let task = activeTask {
               // buang satu slot saja
               if task.selectedCount > 1 {
                   task.selectedCount -= 1
               } else {
                   task.selectedCount = 0
                   task.isSelected = false
               }
               task.isPendingSelected = false
               try? context?.save()
               activeTask = nil
               scheduleTaskReminder()
           }
    }
    
    /// Completes the active task (checkmark button action)
    func completeActiveTask() {
        if let task = activeTask {
            complete(task)
            activeTask = nil
        }
    }
    
    /// Handles task selection from the grid, showing warning if energy is insufficient
    func handleTaskSelection(_ task: TaskItem) {
        if ((task.energyImpact * 10) > dailyState?.currentEnergy ?? 0) && task.isDraining {
            showNotif = true
            tempTask = task
        } else {
            activeTask = task
        }
    }
    
    /// Confirms the warning popup and sets the active task
    func confirmWarningAndSetActive() {
        activeTask = tempTask
        tempTask = nil
        showNotif = false
    }
    
    /// Cancels the warning popup
    /// NOTE: tempTask is intentionally NOT cleared on cancel, preserving original behavior
    func cancelWarning() {
        showNotif = false
    }
    
    /// Checks if a task exceeds the current available energy
    func isTaskOverEnergy(_ task: TaskItem) -> Bool {
        task.isDraining && ((task.energyImpact * 10) > dailyState?.currentEnergy ?? 0)
    }
}
