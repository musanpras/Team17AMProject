//
//  MarketView.swift
//  Team17Project
//
//  Created by Muhammad Sandy Prastyo on 26/05/26.

import SwiftUI
import SwiftData

struct MarketView: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [TaskItem]
    @Query private var states: [DailyState]
    @State private var viewModel: MarketViewModel?

    @Binding var selectedTab: Tab

    private var dailyState: DailyState? {
        states.first
    }

    var body: some View {
        NavigationStack {
            ZStack {
                CodedGridBackground()

                if let viewModel {
                    marketContent(viewModel: viewModel)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                if viewModel == nil {
                    viewModel = MarketViewModel(modelContext: modelContext)
                }
                viewModel?.onAppear(states: states, tasks: tasks)
            }
        }
    }

    @ViewBuilder
    private func marketContent(viewModel: MarketViewModel) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                MarketHeader(
                    energyValue: viewModel.energyValue(for: dailyState),
                    energyColor: EnergyCalculator.color(
                        for: viewModel.energyValue(for: dailyState)
                    )
                )
                EnergyFilterPicker(selectedFilter: Bindable(viewModel).selectedFilter)
                MarketActivityGrid(
                    tasks: viewModel.filteredTasks(from: tasks),
                    remainingEnergy: viewModel.remainingEnergy,
                    pressedTask: viewModel.pressedTask,
                    onAddTask: {
                        viewModel.presentAddTask()
                    },
                    onEditTask: { task in
                        viewModel.presentEditTask(task)
                    },
                    onSelectTask: { task in
                        viewModel.addSelection(for: task, tasks: tasks)
                    },
                    onLowEnergyWarning: { task in
                        viewModel.presentLowEnergyWarning(for: task)
                    },
                    onPressChange: { task in
                        viewModel.pressedTask = task
                    }
                )
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 16) {
                MarketSelectedTaskGrid(
                    slots: viewModel.pendingSelectedSlots(from: tasks),
                    emptySlotCount: viewModel.emptySelectedSlotCount(from: tasks),
                    onRemove: { task in
                        viewModel.removeOneSelection(for: task)
                    }
                )
                MarketProceedButton(
                    selectedCount: viewModel.pendingSelectedTasks(from: tasks).count,
                    maxSelectedTasks: TaskSelection.maxSlots,
                    onProceed: {
                        viewModel.proceedWithSelectedTasks(tasks: tasks, dailyState: dailyState)
                        selectedTab = .home
                    }
                )
            }
            .padding(.horizontal, 24)
            .offset(x: 0, y: -60)
        }
        .scrollDisabled(true)
        .overlay {
            if viewModel.showingAdd {
                AddTaskPopupOverlay(
                    editingTask: viewModel.editingTask,
                    onSave: {
                        viewModel.dismissAddTask()
                    },
                    onCancel: {
                        viewModel.dismissAddTask()
                    }
                )
            }

            if viewModel.showNotif {
                MarketWarningPopup(
                    onConfirm: {
                        viewModel.confirmLowEnergyWarning(tasks: tasks)
                    },
                    onCancel: {
                        viewModel.dismissWarning()
                    }
                )
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: TaskItem.self, DailyState.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    for task in TaskItem.defaultTasks {
        container.mainContext.insert(task)
    }

    return MarketView(selectedTab: .constant(.market))
        .modelContainer(container)
}
