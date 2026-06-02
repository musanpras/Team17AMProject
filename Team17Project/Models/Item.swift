//
//  Item.swift
//  Team17Project
//
//  Created by Muhammad Sandy Prastyo on 22/05/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

enum Tab {
    case home
    case market
}
