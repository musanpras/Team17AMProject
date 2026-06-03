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
    @Query private var tasks: [TaskItem]
    @Query private var states: [DailyState]
    
    private let maxSelectedTasks = 4
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 4)
    
    var dailyState: DailyState? {
        states.first
    }
    
    var selectedTasks: [TaskItem] {
        Array(tasks.filter { $0.isSelected }.prefix(maxSelectedTasks))
    }
    
    private var energyValue: Double {
        guard let dailyState, dailyState.maxEnergy > 0 else { return 0 }
        return Double(dailyState.currentEnergy) / Double(dailyState.maxEnergy)
    }
    
    private var mascotEnergy: String {
        switch energyValue {
        case ..<0.25: return "tired"
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
        
        ZStack {
            Image("backgroundImage")
                .resizable()
                .padding(.top, 10)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    header
                    mascotSection
                    energyBar
                    selectedTaskGrid
                }
                .padding(.horizontal, 30)
                .padding(.top, 36)
                .padding(.bottom, 110)
            }
        }
        .onAppear {
            createStateIfNeeded()
        }
    }
    
    private var header: some View {
        ZStack(alignment: .leading) {
            
            VStack(spacing: 8) {

                Text(activeTask != nil ? activeTask!.title : "pick a task.")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.black)
                
                Text("focus with [mascot]")
                    .font(.system(size: 14))
                    .strikethrough()
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity)
            if hasActiveTask{
                
                HStack{
                    
                
                    Button {
                        if let task = activeTask {
                            task.isSelected = false
                            try? context.save()
                            activeTask = nil
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
                    
                    Spacer()
                    
                    
                    Button {
                        if let task = activeTask {
                            complete(task)
                            task.isSelected = false
                            try? context.save()
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
        }
    }
    
    private var mascotSection: some View {
        ZStack(alignment: .leading) {
            
            Image(mascotEnergy)
                .resizable()
                .scaledToFit()
                .frame(width: 170, height: 310)
                .frame(maxWidth: .infinity)
            
            VStack {
                Spacer()
                    .frame(height: 48)
                SpeechBubble()
                    .fill(.white)
                    .shadow(color: .black, radius: 0, x: 0, y: 4)
                    .overlay(
                        SpeechBubble()
                            .stroke(.black, lineWidth: 1)
                    )
                    .overlay(
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("good job on doing")
                                    .font(.system(size: 12))
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                                    .frame(width: 18)
                            }
                            HStack {
                                Text("assignments today")
                                    .font(.system(size: 13, weight: .bold))
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                                    .frame(width: 18)
                            }
                        }
                            .foregroundStyle(.black)
                            .padding(0)
                    )
                    .frame(width: 134, height: 54)
                Spacer()
            }
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
            .offset(x: -20)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var selectedTaskGrid: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black, radius: 0, x: 0, y: 8)
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(selectedTasks) { task in
                    Button {
//                        complete(task)
                        activeTask = (activeTask?.id == task.id) ? nil : task
                    } label: {
                        ActivityCell(task: task)
                    }
                    .buttonStyle(.plain)
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
            .padding(.top, 6)
        }
    }
    
    private var hasActiveTask: Bool {
        activeTask != nil
    }
    
    private var emptySelectedSlotCount: Int {
        max(0, maxSelectedTasks - selectedTasks.count)
    }
    
    func complete(_ task: TaskItem) {
        
        guard let state = dailyState else { return }
        
        if task.isDraining {
            state.currentEnergy -= task.energyImpact
        } else {
            state.currentEnergy += task.energyImpact
        }
        
        state.currentEnergy = max(
            0,
            min(state.currentEnergy, state.maxEnergy)
        )
        
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

private struct HomeGridPaperBackground: View {
    var body: some View {
        Canvas { context, size in
            let smallSpacing: CGFloat = 16
            let largeSpacing: CGFloat = 80
            
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


private struct SpeechBubble: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius: CGFloat = 8
        let tailWidth: CGFloat = 18
        let tailHeight: CGFloat = 10
        
        path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - radius - tailWidth, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - tailWidth, y: rect.minY + radius),
            control: CGPoint(x: rect.maxX - tailWidth, y: rect.minY)
        )
        path.addLine(to: CGPoint(x: rect.maxX - tailWidth, y: rect.midY - tailHeight))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY - tailHeight - 10))
        path.addLine(to: CGPoint(x: rect.maxX - tailWidth, y: rect.midY + 2))
        path.addLine(to: CGPoint(x: rect.maxX - tailWidth, y: rect.maxY - radius))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - tailWidth - radius, y: rect.maxY),
            control: CGPoint(x: rect.maxX - tailWidth, y: rect.maxY)
        )
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY - radius),
            control: CGPoint(x: rect.minX, y: rect.maxY)
        )
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + radius, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )
        
        return path
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [TaskItem.self, DailyState.self], inMemory: true)
}
