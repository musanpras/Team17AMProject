//
//  EnergyFilter.swift
//  Ttery
//
//  Extracted from MarketView.swift during MVVM refactoring.
//

import Foundation

enum EnergyFilter: CaseIterable, Hashable {
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
