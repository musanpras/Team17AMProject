//
//  HomeView.swift
//  Team17Project
//  Created by ROONEY on 26/05/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [TaskItem]
    @Query private var states: [DailyState]
    @State private var viewModel: HomeViewModel?

    private var dailyState: DailyState? {
        states.first
    }

    private var selectedTaskCount: Int {
        TaskSelection.expandedSelectedTasks(from: tasks).count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                CodedGridBackground()

                if let viewModel {
                    homeContent(viewModel: viewModel)
                }
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = HomeViewModel(modelContext: modelContext)
                }
                viewModel?.onAppear(states: states, tasks: tasks)
            }
            .onChange(of: viewModel?.activeTask?.title) { _, _ in
                viewModel?.scheduleTaskReminder(tasks: tasks, dailyState: dailyState)
            }
            .onChange(of: selectedTaskCount) { _, _ in
                viewModel?.scheduleTaskReminder(tasks: tasks, dailyState: dailyState)
            }
            .onChange(of: dailyState?.currentEnergy) { _, _ in
                viewModel?.syncWidget(tasks: tasks, dailyState: dailyState)
            }
        }
    }

    @ViewBuilder
    private func homeContent(viewModel: HomeViewModel) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                HomeHeader(
                    activeTaskTitle: viewModel.activeTask?.title,
                    hasActiveTask: viewModel.activeTask != nil,
                    onDelete: {
                        viewModel.deleteActiveTask(tasks: tasks, dailyState: dailyState)
                    },
                    onComplete: {
                        viewModel.completeActiveTask(dailyState: dailyState, tasks: tasks)
                    }
                )
                HomeMascotSection(
                    mascotEnergy: EnergyCalculator.mascotEnergy(
                        for: viewModel.energyValue(for: dailyState)
                    )
                )
                StyledEnergyBar(
                    value: viewModel.energyValue(for: dailyState),
                    energyColor: EnergyCalculator.color(
                        for: viewModel.energyValue(for: dailyState)
                    ),
                    style: .home
                )
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 16) {
                HomeSelectedTaskGrid(
                    slots: viewModel.selectedTaskSlots(from: tasks),
                    emptySlotCount: viewModel.emptySelectedSlotCount(from: tasks),
                    currentEnergy: dailyState?.currentEnergy ?? 0,
                    onTaskTap: { task in
                        viewModel.handleTaskTap(task, currentEnergy: dailyState?.currentEnergy ?? 0)
                    },
                    onLowEnergyWarning: { _ in
                        viewModel.showNotif = true
                    }
                )
                HomeTteryInfoLink()
            }
            .edgesIgnoringSafeArea(.bottom)
            .padding(.horizontal, 24)
            .offset(x: 0, y: -60)
        }
        .scrollDisabled(true)
        .overlay {
            if viewModel.showNotif {
                HomeWarningPopup(
                    onConfirm: {
                        viewModel.confirmLowEnergyWarning(tasks: tasks, dailyState: dailyState)
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
    HomeView()
        .modelContainer(for: [TaskItem.self, DailyState.self], inMemory: true)
}
