//
//  model.swift
//  Team17Project
//
//  Created by Muhammad Sandy Prastyo on 26/05/26.
//

import SwiftData
import Foundation

@Model
class TaskItem {

    var title: String
    var energyImpact: Int
    var isDraining: Bool
    var icon: String
    var isSelected: Bool
    var isPendingSelected: Bool = false
    var pendingSelectionCount: Int = 0
    var selectedCount: Int = 0
    

    init(
        title: String,
        energyImpact: Int,
        isDraining: Bool,
        icon: String,
        isSelected: Bool = false,
        isPendingSelected: Bool = false,
        pendingSelectionCount: Int = 0,
        selectedCount: Int = 0
    ) {
        self.title = title
        self.energyImpact = energyImpact
        self.isDraining = isDraining
        self.icon = icon
        self.isSelected = isSelected
        self.isPendingSelected = isPendingSelected
        self.pendingSelectionCount = pendingSelectionCount
        self.selectedCount = selectedCount
    }
}
