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
            TaskItem(title: "work", energyImpact: 1, isDraining: true, icon: "💼"),
            TaskItem(title: "cook", energyImpact: 2, isDraining: true, icon: "🍳"),
            TaskItem(title: "study", energyImpact: 3, isDraining: true, icon: "📚"),
            TaskItem(title: "laundry", energyImpact: 2, isDraining: true, icon: "🫧"),
            TaskItem(title: "exercise", energyImpact: 2, isDraining: true, icon: "🏋🏻‍♂️"),
            TaskItem(title: "social media", energyImpact: 2, isDraining: true, icon: "💬"),
            
//            energizing
            TaskItem(title: "shower", energyImpact: 2, isDraining: false, icon: "🚿"),
            TaskItem(title: "snack", energyImpact: 2, isDraining: false, icon: "🍪"),
            TaskItem(title: "meal", energyImpact: 2, isDraining: false, icon: "🍽️"),
            TaskItem(title: "game", energyImpact: 2, isDraining: false, icon: "🎮"),
            TaskItem(title: "read", energyImpact: 2, isDraining: false, icon: "📖"),
            TaskItem(title: "art", energyImpact: 2, isDraining: false, icon: "🎨"),
            TaskItem(title: "socialize", energyImpact: 2, isDraining: false, icon: "🕺🏽"),
            TaskItem(title: "music", energyImpact: 2, isDraining: false, icon: "💿"),
            TaskItem(title: "sleep", energyImpact: 2, isDraining: false, icon: "😴"),
            
            
            TaskItem(title: "shower", energyImpact: 2, isDraining: false, icon: "🚿"),
            TaskItem(title: "snack", energyImpact: 2, isDraining: false, icon: "🍪"),
            TaskItem(title: "meal", energyImpact: 2, isDraining: false, icon: "🍽️"),
            TaskItem(title: "game", energyImpact: 2, isDraining: false, icon: "🎮"),
            TaskItem(title: "read", energyImpact: 2, isDraining: false, icon: "📖"),
            TaskItem(title: "art", energyImpact: 2, isDraining: false, icon: "🎨"),
            TaskItem(title: "socialize", energyImpact: 2, isDraining: false, icon: "🕺🏽"),
            TaskItem(title: "music", energyImpact: 2, isDraining: false, icon: "💿"),
            TaskItem(title: "sleep", energyImpact: 2, isDraining: false, icon: "😴")
            
           
        ]
    }
    
}
