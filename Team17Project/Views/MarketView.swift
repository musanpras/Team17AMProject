//
//  MarketView.swift
//  Team17Project
//
//  Created by Muhammad Sandy Prastyo on 26/05/26.
//

import SwiftUI
import SwiftData

struct MarketView: View {

    @Environment(\.modelContext) private var context
    @Query private var tasks: [TaskItem]
    @Query private var states: [DailyState]

    @State private var showingAdd = false
    @State private var selectedFilter: EnergyFilter = .draining

    private let maxSelectedTasks = 4
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 4)

    private var dailyState: DailyState? {
        states.first
    }

    private var energyValue: Double {
        guard let dailyState, dailyState.maxEnergy > 0 else { return 0 }
        return Double(dailyState.currentEnergy) / Double(dailyState.maxEnergy)
    }

    private var pendingSelectedTasks: [TaskItem] {
        tasks.filter { $0.isPendingSelected }
    }

    private var filteredTasks: [TaskItem] {
        tasks.filter { task in
            selectedFilter == .draining ? task.isDraining : !task.isDraining
        }
    }

    var body: some View {

        NavigationStack {

            ZStack {
                GridPaperBackground()

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
                    .padding(.bottom, 100)
                }

                if showingAdd {
                    addTaskPopup
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                createStateIfNeeded()
                syncPendingSelectionFromCommittedSelection()
            }
        }
    }

    private var addTaskPopup: some View {
        ZStack {
            Color.black.opacity(0.18)
                .ignoresSafeArea()
                .onTapGesture {
                    showingAdd = false
                }

            AddTaskView(
                onSave: {
                    showingAdd = false
                },
                onCancel: {
                    showingAdd = false
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
                    .offset(x: 20)

                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.black)
                        Capsule()
                            .fill(.black)
                            .offset(y: 2)

                        Capsule()
                            .fill(.yellow)
                            .frame(width: proxy.size.width * min(max(energyValue, 0), 1))
                    }
                }
                .frame(width: 100, height: 20)
                .overlay(Capsule().stroke(.black, lineWidth: 1))

                Text("\(dailyState?.currentEnergy ?? 0)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.black)
            }
        }
    }

    private var filterPicker: some View {
        Picker("Energy type", selection: $selectedFilter) {
            ForEach(EnergyFilter.allCases, id: \.self) { filter in
                Text(filter.title)
                    .tag(filter)
            }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
        .frame(height: 34)
        .background(
            RoundedRectangle(cornerRadius: 17)
                .fill(Color(.systemGray6))
                .shadow(color: .black, radius: 0, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 17)
                .stroke(.black, lineWidth: 1)
        )
    }

    private var activityGrid: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black, radius: 0, x: 0, y: 6)
            
            LazyVGrid(columns: columns, spacing: 0) {
                addTaskButton
                
                ForEach(filteredTasks) { task in
                    Button {
                        toggleSelection(for: task)
                    } label: {
                        ActivityCell(task: task)
                    }
                    .buttonStyle(.plain)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.black, lineWidth: 1)
            )
        }
    }

    private var addTaskButton: some View {
        Button {
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
                                .fill(Color(.systemBackground))
                                .shadow(color: .black, radius: 0, x: 0, y: 6)
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(pendingSelectedTasks) { task in
                    ZStack(alignment: .topTrailing) {
                        ActivityCell(task: task)
                        
                        Button {
                            task.isPendingSelected = false
                            try? context.save()
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
                
                ForEach(0..<emptySelectedSlotCount, id: \.self) { _ in
                    Color.white.opacity(0.35)
                        .frame(maxWidth: .infinity, minHeight: 94)
                        .border(.black, width: 0.5)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.black, lineWidth: 1)
            )
            
            .padding(.top, 8)
        }
    }

    private var emptySelectedSlotCount: Int {
        max(0, maxSelectedTasks - pendingSelectedTasks.count)
    }

    private func proceedText() -> some View {
        Button {
            proceedWithSelectedTasks()
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
        let pendingObjects = Set(pendingSelectedTasks.prefix(maxSelectedTasks).map { ObjectIdentifier($0) })

        for task in tasks {
            let isCommitted = pendingObjects.contains(ObjectIdentifier(task))
            task.isSelected = isCommitted
            task.isPendingSelected = isCommitted
        }

        try? context.save()
    }

    private func toggleSelection(for task: TaskItem) {
        if task.isPendingSelected {
            task.isPendingSelected = false
        } else if pendingSelectedTasks.count < maxSelectedTasks {
            task.isPendingSelected = true
        }

        try? context.save()
    }

    private func syncPendingSelectionFromCommittedSelection() {
        for task in tasks {
            task.isPendingSelected = task.isSelected
        }

        try? context.save()
    }

    private func createStateIfNeeded() {
        if states.isEmpty {
            let state = DailyState()
            context.insert(state)
            try? context.save()
        }
    }
}

private enum EnergyFilter: CaseIterable, Hashable {
    case draining
    case energizing

    var title: String {
        switch self {
        case .draining:
            return "draining"
        case .energizing:
            return "energizing"
        }
    }
}

private struct GridPaperBackground: View {
    var body: some View {
        Canvas { context, size in
            let smallSpacing: CGFloat = 16
            let largeSpacing: CGFloat = 64

            for x in stride(from: 0, through: size.width, by: smallSpacing) {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(Color.blue.opacity(0.08)), lineWidth: 1)
            }

            for y in stride(from: 0, through: size.height, by: smallSpacing) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(Color.blue.opacity(0.08)), lineWidth: 1)
            }

            for x in stride(from: 0, through: size.width, by: largeSpacing) {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(Color.red.opacity(0.08)), lineWidth: 1)
            }

            for y in stride(from: 0, through: size.height, by: largeSpacing) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(Color.red.opacity(0.08)), lineWidth: 1)
            }
        }
        .background(Color.white)
        .ignoresSafeArea()
    }
}

#Preview {
    MarketView()
        .modelContainer(for: [TaskItem.self, DailyState.self], inMemory: true)
}
