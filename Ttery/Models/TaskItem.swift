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

    init(
        title: String,
        energyImpact: Int,
        isDraining: Bool,
        icon: String,
        isSelected: Bool = false,
        isPendingSelected: Bool = false
    ) {
        self.title = title
        self.energyImpact = energyImpact
        self.isDraining = isDraining
        self.icon = icon
        self.isSelected = isSelected
        self.isPendingSelected = isPendingSelected
    }
}
