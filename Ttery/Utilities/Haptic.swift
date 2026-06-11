//
//  Haptic.swift
//  Ttery
//
//  Created by Muhammad Sandy Prastyo on 10/06/26.
//

import UIKit

enum Haptic {
    static func light() {
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
    }

    static func medium() {
        UIImpactFeedbackGenerator(style: .medium)
            .impactOccurred()
    }
    
    static func bold() {
        UIImpactFeedbackGenerator(style: .rigid)
            .impactOccurred()
    }

    static func selection() {
        UISelectionFeedbackGenerator()
            .selectionChanged()
    }

    static func success() {
        UINotificationFeedbackGenerator()
            .notificationOccurred(.success)
    }
}
