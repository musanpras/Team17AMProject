//
//  Tab.swift
//  Team17Project
//

import Foundation

enum Tab: CaseIterable {
    case home
    case market
    case settings

    var index: Int {
        switch self {
        case .home: return 0
        case .market: return 1
        case .settings: return 2
        }
    }
}
