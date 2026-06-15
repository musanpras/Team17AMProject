//
//  EnergyFilter.swift
//  Team17Project
//

import Foundation

enum EnergyFilter: CaseIterable, Hashable {
    case energizing
    case draining

    static let displayOrder: [EnergyFilter] = [.energizing, .draining]

    var title: String {
        switch self {
        case .draining: return "draining"
        case .energizing: return "energizing"
        }
    }

    var icon: String {
        switch self {
        case .draining: return "arrowshape.down.fill"
        case .energizing: return "arrowshape.up"
        }
    }

    func matches(_ task: TaskItem) -> Bool {
        switch self {
        case .draining: return task.isDraining
        case .energizing: return !task.isDraining
        }
    }
}
