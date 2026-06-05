//
//  HomeView.swift
//  Team17Project
//  Created by ROONEY on 26/05/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Environment(\.modelContext) private var context
    
    @State private var activeTask: TaskItem? = nil
    @State private var tempTask: TaskItem? = nil
    @Query private var tasks: [TaskItem]
    @Query private var states: [DailyState]
    
    @State private var showNotif: Bool = false
    
    private let maxSelectedTasks = 4
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 4)
    
    var dailyState: DailyState? {
        states.first
    }
    
    private struct SelectedTaskSlot: Identifiable {
        let id = UUID()
        let task: TaskItem
    }

    private var selectedTaskSlots: [SelectedTaskSlot] {
        selectedTasks.map { SelectedTaskSlot(task: $0) }
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
    
    private var energyValue: Double {
        guard let dailyState, dailyState.maxEnergy > 0 else { return 0 }
        return Double(dailyState.currentEnergy) / Double(dailyState.maxEnergy)
    }
    
    private var mascotEnergy: String {
        switch energyValue {
        case 0: return "depleted"
        case 0.01..<0.25: return "tired"
        case 0.25..<0.5: return "idle"
        case 0.5..<0.75: return "energized"
        default: return "hyped"
        }
    }
    
    private var energyColor: Color {
        switch energyValue {
        case ..<0.25: return .red
        case 0.25..<0.5: return .orange
        case 0.5..<0.75: return .yellow
        default: return .green
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CodedGridBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        header
                        mascotSection
                        energyBar
                        selectedTaskGrid
                        tteryInfo
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 36)
                    .padding(.bottom, 110)
                }
                .scrollDisabled(true)
                
                if showNotif {
                    warningPopup
                }
            }
            .onAppear {
                createStateIfNeeded()
                scheduleTaskReminder()
            }
            .onChange(of: activeTask?.title) { _, _ in
                scheduleTaskReminder()
            }
            .onChange(of: selectedTasks.count) { _, _ in
                scheduleTaskReminder()
            }
        }
    }
    
    private var warningPopup: some View {
        ZStack {
            Color.black.opacity(0.18)
                .ignoresSafeArea()
                .onTapGesture {
                    showNotif = false
                }
            
            PopUpNotif(
                onClick: {
                    activeTask = tempTask
                    tempTask = nil
                    showNotif = false
                },
                onCancel: {
                    showNotif = false
                }
            )
            .frame(maxWidth: 660)
            .padding(.horizontal, 18)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.96)))
        .zIndex(10)
    }
    
    private var header: some View {
        HStack{
            if hasActiveTask{
                Button {
                    if let task = activeTask {
                           // buang satu slot saja
                           if task.selectedCount > 1 {
                               task.selectedCount -= 1
                           } else {
                               task.selectedCount = 0
                               task.isSelected = false
                           }
                           task.isPendingSelected = false
                           try? context.save()
                           activeTask = nil
                           scheduleTaskReminder()
                       }
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 54, height: 54)
                        .background(Circle().fill(.red).shadow(color: .black, radius: 0, x: 0, y: 4))
                        .overlay(Circle().stroke(.black, lineWidth: 1))
                    
                }
                .buttonStyle(.plain)
            }
            
            VStack(spacing: 8) {
                Text(activeTask != nil ? activeTask!.title : "pick a task.")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.black)
            }
            .frame(maxWidth: .infinity)
            if hasActiveTask{
                Button {
                    if let task = activeTask {
                        complete(task)
                        activeTask = nil
                    }
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 54, height: 54)
                        .background(Circle().fill(.blue).shadow(color: .black, radius: 0, x: 0, y: 4))
                        .overlay(Circle().stroke(.black, lineWidth: 1))
                    
                }
                .buttonStyle(.plain)
            }
            
        }
        .frame( height: 54)
        
    }
    
    private var mascotSection: some View {
        ZStack(alignment: .leading) {
            
            Image(mascotEnergy)
                .resizable()
                .scaledToFit()
                .frame(width: 170, height: 310)
                .frame(maxWidth: .infinity)
            
            
        }
        .frame(height: 330)
    }
    
    private var energyBar: some View {
        HStack(spacing: 0) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.black)
                .frame(width: 42, height: 42)
                .background(Circle().fill(.white))
                .overlay(Circle().stroke(.black, lineWidth: 2))
                .background(Circle().fill(.white).shadow(color: .black, radius: 0, x: 0, y: 4))
                .zIndex(1)
            .offset(x: 16)
            
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.black)
                    
                    Capsule()
                        .fill(.black)
                        .offset(y: 3)
                    Capsule()
                        .fill(energyColor)
                        .frame(width: proxy.size.width * min(max(energyValue, 0), 1))
                }
            }
            .frame(width: 160, height: 32)
            .overlay(Capsule().stroke(.black, lineWidth: 1))
        }
        .frame(maxWidth: .infinity)
    }
    
    private var selectedTaskGrid: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: .black, radius: 0, x: 0, y: 6)
                .padding(.top, 16)
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(selectedTaskSlots.reversed()) { slot in
                    let task = slot.task
                    Button {
                        if ((task.energyImpact * 10) > dailyState?.currentEnergy ?? 0) && task.isDraining {
                            showNotif = true
                            tempTask = task
                        } else {
                            activeTask = task
                        }
                    } label: {
                        ZStack {
                            ActivityCell(task: task)
                            
                            
                            if task.isDraining && ((task.energyImpact * 10) > dailyState?.currentEnergy ?? 0){
                                Button {
                                    showNotif = true
                                } label: {
                                    Image(systemName: "exclamationmark")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundStyle(.white)
                                        .frame(width: 18, height: 18)
                                        .background(Circle().fill(.yellow))
                                }
                                .buttonStyle(.plain)
                                .offset(x: 30, y: -35)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
                
                ForEach(0..<emptySelectedSlotCount, id: \.self) { _ in
                    Color.white.opacity(0.35)
                        .frame(maxWidth: .infinity, minHeight: 94)
                        .border(.black, width: 0.5)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black, lineWidth: 1)
            )
            .padding(.top, 16)
        }
    }
    
    private var tteryInfo: some View {
        NavigationLink {
            StoryView()
        } label: {
            Text("who’s ttery?")
                .font(.system(size: 14))
                .underline()
                .foregroundStyle(.black)
        }
        .foregroundColor(.primary)
    }
    
    private var hasActiveTask: Bool {
        activeTask != nil
    }
    
    private var emptySelectedSlotCount: Int {
        max(0, maxSelectedTasks - selectedTasks.count)
    }
    
    private func scheduleTaskReminder() {
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
        
        try? context.save()
    }
    
    func createStateIfNeeded() {
        
        if states.isEmpty {
            
            let state = DailyState()
            context.insert(state)
            
            try? context.save()
        }
    }
}



#Preview {
    HomeView()
        .modelContainer(for: [TaskItem.self, DailyState.self], inMemory: true)
}
