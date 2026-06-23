//
//  WidgetMessageProvider.swift
//  TteryShared
//

import Foundation

enum WidgetMessageProvider {
    
    static func title(
        activeTaskTitle: String?,
        selectedTaskCount: Int,
        greetingVariant: Int
    ) -> String {
        if let activeTaskTitle, !activeTaskTitle.isEmpty {
            return "just checking in..."
        }

        if selectedTaskCount > 0 {
            return "yo, it's ttery!"
        }

        return greetingVariant == 1 ? "ttery here." : "ttery says hello"
    }
    
    static func body(
        activeTaskTitle: String?,
        selectedTaskCount: Int,
        greetingVariant: Int
    ) -> String {
        if let activeTaskTitle, !activeTaskTitle.isEmpty {
            return "done with \(activeTaskTitle) yet?"
        }

        if selectedTaskCount > 0 {
            return "i'm bored, let's do something"
        }

        return greetingVariant == 1
            ? "what's been up this past hour?"
            : "how are you doing?"
    }
}
