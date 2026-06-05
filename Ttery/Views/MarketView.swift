//
//  MarketView.swift
//  Team17Project
//
//  Created by Muhammad Sandy Prastyo on 26/05/26.

import SwiftUI
import SwiftData

struct MarketView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var tasks: [TaskItem]
    @Query private var states: [DailyState]
    
    @State private var showingAdd: Bool = false
    @State private var showNotif: Bool = false
    @State private var selectedFilter: EnergyFilter = .energizing
    
    @State private var editingTask: TaskItem?
    @State private var tempTask: TaskItem?
    @State private var remainingEnergy: Int = 0
    
    @Binding var selectedTab: Tab
    
    private let maxSelectedTasks = 4
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 4)
    
    private struct SelectedTaskSlot: Identifiable {
        let id = UUID()
        let task: TaskItem
        let isCommitted: Bool
    }
    
    private var dailyState: DailyState? {
        states.first
    }
    
    private var energyValue: Double {
        guard let dailyState, dailyState.maxEnergy > 0 else { return 0 }
        return Double(remainingEnergy) / Double(dailyState.maxEnergy)
    }
    
    private var pendingSelectedTasks: [TaskItem] {
        tasks.flatMap{task in Array(repeating: task, count: task.pendingSelectionCount)
        }
    }
    
    private var pendingSelectedSlots: [SelectedTaskSlot] {
        var committedUsed: [ObjectIdentifier: Int] = [:]
        
        return pendingSelectedTasks.map { task in
            let id = ObjectIdentifier(task)
            let used = committedUsed[id, default: 0]
            let isCommitted = used < task.selectedCount
            committedUsed[id] = used + 1
            return SelectedTaskSlot(task: task, isCommitted: isCommitted)
        }
    }
    
    
    private var filteredTasks: [TaskItem] {
        tasks.filter { task in
            selectedFilter == .draining ? task.isDraining : !task.isDraining
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
                    VStack(alignment: .leading, spacing: 16) {
                        header
                        filterPicker
                        activityGrid
                        
                        selectedTaskGrid
                        proceedText()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 18)
                }
                
                .scrollDisabled(true)
                
                
                if showingAdd {
                    addTaskPopup
                }
                
                if showNotif {
                    warningPopup
                }
            }
            
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                remainingEnergy = Int(dailyState?.currentEnergy ?? 0)
                createStateIfNeeded()
//                seedDefaultTasksIfNeeded()
                syncPendingSelectionFromCommittedSelection()
            }
        }
    }
    
    
    private var addTaskPopup: some View {
        ZStack {
            Color.black.opacity(0.18)
                .ignoresSafeArea()
                .onTapGesture {
                    editingTask = nil
                    showingAdd = false
                }
            
            AddTaskView(
                task: editingTask,
                onSave: {
                    editingTask = nil
                    showingAdd = false
                },
                onCancel: {
                    editingTask = nil
                    showingAdd = false
                }
            )
            .frame(maxWidth: 660)
            .padding(.horizontal, 18)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.96)))
        .zIndex(10)
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
                    if let task = tempTask {
                        addSelection(for: task)
                    }
                    tempTask = nil
                    showNotif = false
                },
                onCancel: {
                    tempTask = nil
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
        HStack(alignment: .center) {
            Text("market")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.black)
            
            Spacer()
            
            HStack(spacing: 2) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.black)
                    .frame(width: 30, height: 30)
                
                    .background(Circle().fill(.white).shadow(color: .black, radius: 0, x: 0, y: 2))
                    .overlay(Circle().stroke(.black, lineWidth: 2))
                    .zIndex(1)
                    .offset(x: 16)
                
                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.black)
                        Capsule()
                            .fill(.black)
                            .offset(y: 2)
                        
                        Capsule()
                            .fill(energyColor)
                            .frame(width: proxy.size.width * min(max(energyValue, 0), 1))
                    }
                }
                .frame(width: 100, height: 20)
                .overlay(Capsule().stroke(.black, lineWidth: 1))
                
            }
        }
    }
    
    private var filterPicker: some View {
        HStack(spacing: 0) {
            ForEach(EnergyFilter.displayOrder, id: \.self) { filter in
                Button {
                    selectedFilter = filter
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: filter.icon)
                            .font(.system(size: 16, weight: .bold))
                        
                        Text(filter.title)
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(selectedFilter == filter ? .white : .clear)
                            .shadow(
                                color: selectedFilter == filter ? .black.opacity(0.18) : .clear,
                                radius: 10,
                                x: 0,
                                y: 2
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.fixedGray6)
                .shadow(color: .black, radius: 0, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(.black, lineWidth: 1)
        )
    }
    
    private var activityGrid: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: .black, radius: 0, x: 0, y: 6)
            
            ScrollView{
                LazyVGrid(columns: columns, spacing: 0) {
                    addTaskButton
                    
                    ForEach(filteredTasks.reversed()) { task in
                        ZStack{
                            ActivityCell(task: task)
                            
                            if task.isDraining && ((task.energyImpact * 10) > remainingEnergy){
                                Button {
                                    tempTask = task
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
                        .onLongPressGesture(minimumDuration: 0.8) {
                            editingTask = task
                            showingAdd = true
                        }
                        .onTapGesture {
                            if task.isDraining && ((task.energyImpact * 10) > remainingEnergy){
                                tempTask = task
                                showNotif = true
                            }else {
                                
                                addSelection(for: task)
                                
                            }
                            
                        }
                    }
                }
                
            }
            
            .frame(height: CGFloat(visibleRows) * 94)
            .scrollBounceBehavior(.basedOnSize)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black, lineWidth: 1)
            )
        }
        .padding(.bottom, dynamicBottomPadding)
    }
    
    private var visibleRows: Int {
        min(4, Int(ceil(Double(filteredTasks.count + 1) / 4.0)))
    }
    
    
    private var dynamicBottomPadding: CGFloat {
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
    
    private var addTaskButton: some View {
        Button {
            editingTask = nil
            showingAdd = true
        } label: {
            VStack {
                Image(systemName: "plus")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.black)
            }
            .frame(maxWidth: .infinity, minHeight: 94)
            .background(.white.opacity(0.75))
            .border(.black, width: 0.5)
        }
        .buttonStyle(.plain)
    }
    
    private var selectedTaskGrid: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: .black, radius: 0, x: 0, y: 6)
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(pendingSelectedSlots.reversed()) { slot in
                    let task = slot.task
                    ZStack(alignment: .topTrailing) {
                        ActivityCell(task: task)
                            .background(slot.isCommitted ? Color.gray : .white.opacity(0.75))
                        
                        if !slot.isCommitted {
                            Button {
                                
                                removeOneSelection(for: task)
                            } label: {
                                Image(systemName: "minus")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundStyle(.white)
                                    .frame(width: 18, height: 18)
                                    .background(Circle().fill(.red))
                            }
                            .buttonStyle(.plain)
                            .offset(x: -4, y: 4)
                        }
                    }
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 1.0).onEnded { _ in
                            editingTask = task
                            showingAdd = true
                        }
                    )
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
            
            
        }
        .padding(.top,100)
    }
    
    private var emptySelectedSlotCount: Int {
        max(0, maxSelectedTasks - pendingSelectedTasks.count)
    }
    
    private func proceedText() -> some View {
        Button {
            proceedWithSelectedTasks()
            selectedTab = .home
            
        } label: {
            Text("\(pendingSelectedTasks.count)/\(maxSelectedTasks) tasks selected. proceed?")
                .font(.system(size: 13))
                .underline()
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
        }
        .buttonStyle(.plain)
        .disabled(pendingSelectedTasks.isEmpty)
    }
    
    
    private func proceedWithSelectedTasks() {
        
        
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
        
        try? context.save()
        
        TaskReminderNotificationManager.shared.scheduleHourlyReminder(
            activeTaskTitle: nil,
            selectedTaskCount: pending.count
        )
        
    }
    
    
    
    private func addSelection(for task: TaskItem) {
        guard pendingSelectedTasks.count < maxSelectedTasks else { return }
        task.pendingSelectionCount += 1
        applyEnergyImpact(task: task, adding: true)
        try? context.save()
    }
    
    private func removeOneSelection(for task: TaskItem) {
        guard task.pendingSelectionCount > 0 else { return }
        task.pendingSelectionCount -= 1
        applyEnergyImpact(task: task, adding: false)
        try? context.save()
    }
    
    private func applyEnergyImpact(task: TaskItem, adding: Bool) {
        let delta = task.energyImpact * 10
        if task.isDraining {
            remainingEnergy += adding ? -delta : delta
        } else {
            remainingEnergy += adding ? delta : -delta
        }
    }
    
    private func syncPendingSelectionFromCommittedSelection() {
        
        for task in tasks {
            task.pendingSelectionCount = task.selectedCount
        }
        try? context.save()
        
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
    
    private func createStateIfNeeded() {
        if states.isEmpty {
            let state = DailyState()
            context.insert(state)
            try? context.save()
        }
    }
}

private enum EnergyFilter: CaseIterable, Hashable {
    case energizing
    case draining
    
    static let displayOrder: [EnergyFilter] = [.energizing, .draining ]
    
    var title: String {
        switch self {
        case .draining:
            return "draining"
        case .energizing:
            return "energizing"
        }
    }
    
    var icon: String {
        switch self {
        case .draining:
            return "arrowshape.down.fill"
        case .energizing:
            return "arrowshape.up"
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
    //    MarketView()
    //        .modelContainer(for: [TaskItem.self, DailyState.self], inMemory: true)
}
