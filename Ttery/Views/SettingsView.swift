//
//  SettingsView.swift
//  Team17Project
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var states: [DailyState]
    @Query private var tasks: [TaskItem]
    @State private var viewModel: SettingsViewModel?
    @State private var showTimeError = false

    private var dailyState: DailyState? {
        states.first
    }
    

    var body: some View {
        ZStack {
            CodedGridBackground()

            if let viewModel, let dailyState {
                settingsContent(viewModel: viewModel, dailyState: dailyState)
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = SettingsViewModel(modelContext: modelContext)
            }
            viewModel?.onAppear(states: states)
        }.alert(
            "Invalid Schedule",
            isPresented: $showTimeError
        ) {
            Button("OK") { }
        } message: {
            Text(
                "End time must be later than start time."
            )
        }
    }

    @ViewBuilder
    private func settingsContent(viewModel: SettingsViewModel, dailyState: DailyState) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("settings")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.black)

                energyResetCard(viewModel: viewModel, dailyState: dailyState)
                

                Text("when enabled, your energy refills to 100% at the start of each day.")
                    .font(.system(size: 14))
                    .foregroundStyle(.black.opacity(0.6))
                
                reminderSettingsCard(
                    viewModel: viewModel,
                    dailyState: dailyState
                )
                
                Text(
                    "Remind me every \(dailyState.reminderHours) hour(s) between \(dailyState.formattedStart) and \(dailyState.formattedEnd)"
                )
                .font(.caption)
                .foregroundStyle(.gray)
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
        }
        .scrollDisabled(true)
    }

    private func energyResetCard(viewModel: SettingsViewModel, dailyState: DailyState) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Daily Energy Reset")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.black)

                Text("reset to 100% every day")
                    .font(.system(size: 14))
                    .foregroundStyle(.black.opacity(0.65))
            }

            Spacer()

            Toggle(
                "",
                isOn: Binding(
                    get: { viewModel.resetsEnergyDaily(for: dailyState) },
                    set: { newValue in
                        viewModel.setResetsEnergyDaily(newValue, state: dailyState, tasks: tasks)
                    }
                )
            )
            .labelsHidden()
            .tint(.green)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black, radius: 0, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 1)
        )
    }
    
    private func reminderSettingsCard(
        viewModel: SettingsViewModel,
        dailyState: DailyState
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {

            HStack {
                Text("Reminders")
                    .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.black)

                Spacer()

                Toggle(
                    "",
                    isOn: Binding(
                        get: {
                            viewModel.remindersEnabled(
                                for: dailyState
                            )
                        },
                        set: { value in
                            showTimeError = !viewModel.setRemindersEnabled(
                                value,
                                state: dailyState
                            )
                        }
                    )
                )
                .labelsHidden()
            }
            
            Stepper(
                value: Binding(
                    get: {
                        dailyState.reminderHours
                    },
                    set: { newValue in
                        showTimeError = !viewModel.setReminderHours(
                            newValue,
                            state: dailyState
                        )
                    }
                ),
                in: 1...3,
                step: 1
            ) {

                Text(
                    "Every \(dailyState.reminderHours) hour(s)"
                )
                .foregroundStyle(.black)
            }
            .foregroundStyle(.black)
            
            DatePicker(
                "Start Time",
                selection: startTimeBinding(
                    viewModel: viewModel,
                    state: dailyState
                ),
                displayedComponents: .hourAndMinute
            )
            .foregroundStyle(.black)
            .colorScheme(.light)
            
            DatePicker(
                "End Time",
                selection: endTimeBinding(
                    viewModel: viewModel,
                    state: dailyState
                ),
                displayedComponents: .hourAndMinute
            )
            .foregroundStyle(.black)
            .colorScheme(.light)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black,
                        radius: 0,
                        x: 0,
                        y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 1)
        )
    }
    
    private func startTimeBinding(viewModel: SettingsViewModel, state: DailyState) -> Binding<Date> {
        Binding {
            viewModel.date(from: state.reminderStartMinute)
        } set: { newDate in
            showTimeError = !viewModel.setReminderStartDate(newDate, state: state)
        }
    }

    private func endTimeBinding(viewModel: SettingsViewModel, state: DailyState) -> Binding<Date> {
        Binding {
            viewModel.date(from: state.reminderEndMinute)
        } set: { newDate in
            showTimeError = !viewModel.setReminderEndDate(newDate, state: state)
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [DailyState.self, TaskItem.self], inMemory: true)
}
