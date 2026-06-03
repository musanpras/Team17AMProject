//
//  TaskItemDefaults.swift
//  Team17Project
//
//  Created by Imelda Damayanti on 02/06/26.
//

import Foundation

extension TaskItem{
    static var defaultTasks: [TaskItem] {
        [
//            draining
            TaskItem(title: "work", energyImpact: 15, isDraining: true, icon: "💼"),
            TaskItem(title: "cook", energyImpact: 10, isDraining: true, icon: "🍳"),
            TaskItem(title: "study", energyImpact: 12, isDraining: true, icon: "📚"),
            TaskItem(title: "laundry", energyImpact: 8, isDraining: true, icon: "🫧"),
            TaskItem(title: "exercise", energyImpact: 10, isDraining: true, icon: "🏋🏻‍♂️"),
            TaskItem(title: "social media", energyImpact: 5, isDraining: true, icon: "💬"),
            
//            energizing
            TaskItem(title: "shower", energyImpact: 5, isDraining: false, icon: "🚿"),
            TaskItem(title: "snack", energyImpact: 3, isDraining: false, icon: "🍪"),
            TaskItem(title: "meal", energyImpact: 5, isDraining: false, icon: "🍽️"),
            TaskItem(title: "game", energyImpact: 10, isDraining: false, icon: "🎮"),
            TaskItem(title: "read", energyImpact: 7, isDraining: false, icon: "📖"),
            TaskItem(title: "art", energyImpact: 12, isDraining: false, icon: "🎨"),
            TaskItem(title: "socialize", energyImpact: 10, isDraining: false, icon: "🕺🏽"),
            TaskItem(title: "music", energyImpact: 5, isDraining: false, icon: "💿"),
            TaskItem(title: "sleep", energyImpact: 15, isDraining: false, icon: "😴"),
            
            
            TaskItem(title: "shower", energyImpact: 5, isDraining: false, icon: "🚿"),
            TaskItem(title: "snack", energyImpact: 3, isDraining: false, icon: "🍪"),
            TaskItem(title: "meal", energyImpact: 5, isDraining: false, icon: "🍽️"),
            TaskItem(title: "game", energyImpact: 10, isDraining: false, icon: "🎮"),
            TaskItem(title: "read", energyImpact: 7, isDraining: false, icon: "📖"),
            TaskItem(title: "art", energyImpact: 12, isDraining: false, icon: "🎨"),
            TaskItem(title: "socialize", energyImpact: 10, isDraining: false, icon: "🕺🏽"),
            TaskItem(title: "music", energyImpact: 5, isDraining: false, icon: "💿"),
            TaskItem(title: "sleep", energyImpact: 15, isDraining: false, icon: "😴")
            
           
        ]
    }
    
}
