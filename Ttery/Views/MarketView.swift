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
    
    @State private var viewModel = MarketViewModel()
    
    @Binding var selectedTab: Tab
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 4)
    
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
                
                
                if viewModel.showingAdd {
                    addTaskPopup
                }
                
                if viewModel.showNotif {
                    warningPopup
                }
            }
            
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                viewModel.context = context
                viewModel.tasks = tasks
                viewModel.states = states
                viewModel.initializeEnergy()
                viewModel.createStateIfNeeded()
//                seedDefaultTasksIfNeeded()
                viewModel.syncPendingSelectionFromCommittedSelection()
            }
            .onChange(of: tasks.count) { _, _ in
                viewModel.tasks = tasks
            }
            .onChange(of: states.count) { _, _ in
                viewModel.states = states
            }
        }
    }
    
    
    private var addTaskPopup: some View {
        ZStack {
            Color.black.opacity(0.18)
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.closeAddTask()
                }
            
            AddTaskView(
                task: viewModel.editingTask,
                onSave: {
                    viewModel.closeAddTask()
                },
                onCancel: {
                    viewModel.closeAddTask()
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
                    viewModel.handleWarningCancel()
                }
            
            PopUpNotif(
                onClick: {
                    viewModel.handleWarningConfirm()
                },
                onCancel: {
                    viewModel.handleWarningCancel()
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
                            .fill(viewModel.energyColor)
                            .frame(width: proxy.size.width * min(max(viewModel.energyValue, 0), 1))
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
                    viewModel.selectedFilter = filter
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
                            .fill(viewModel.selectedFilter == filter ? .white : .clear)
                            .shadow(
                                color: viewModel.selectedFilter == filter ? .black.opacity(0.18) : .clear,
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
                    
                    ForEach(viewModel.filteredTasks.reversed()) { task in
                        ZStack{
                            ActivityCell(task: task)
                            
                            if viewModel.isTaskOverEnergy(task){
                                Button {
                                    viewModel.showWarningForTask(task)
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
                            viewModel.openEditTask(task)
                        }
                        .onTapGesture {
                            viewModel.handleTaskTap(task)
                        }
                    }
                }
                
            }
            
            .frame(height: CGFloat(viewModel.visibleRows) * 94)
            .scrollBounceBehavior(.basedOnSize)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black, lineWidth: 1)
            )
        }
        .padding(.bottom, viewModel.dynamicBottomPadding)
    }
    
    private var addTaskButton: some View {
        Button {
            viewModel.openAddTask()
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
                ForEach(viewModel.pendingSelectedSlots.reversed()) { slot in
                    let task = slot.task
                    ZStack(alignment: .topTrailing) {
                        ActivityCell(task: task)
                            .background(slot.isCommitted ? Color.gray : .white.opacity(0.75))
                        
                        if !slot.isCommitted {
                            Button {
                                
                                viewModel.removeOneSelection(for: task)
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
                            viewModel.openEditTask(task)
                        }
                    )
                }
                
                ForEach(0..<viewModel.emptySelectedSlotCount, id: \.self) { _ in
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
    
    private func proceedText() -> some View {
        Button {
            viewModel.proceedWithSelectedTasks()
            selectedTab = .home
            
        } label: {
            Text("\(viewModel.pendingSelectedTasks.count)/\(viewModel.maxSelectedTasks) tasks selected. proceed?")
                .font(.system(size: 13))
                .underline()
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
        }
        .buttonStyle(.plain)
        .disabled(viewModel.pendingSelectedTasks.isEmpty)
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
