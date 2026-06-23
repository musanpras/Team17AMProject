//
//  TteryWidgetEntry.swift
//  TteryWidget
//

import WidgetKit

struct TteryWidgetEntry: TimelineEntry {
    let date: Date
    let snapshot: WidgetSnapshot
    
    var header: String {
        WidgetMessageProvider.title(
            activeTaskTitle: snapshot.activeTaskTitle,
            selectedTaskCount: snapshot.selectedTaskCount,
            greetingVariant: snapshot.greetingVariant
        )
    }

    var message: String {
        WidgetMessageProvider.body(
            activeTaskTitle: snapshot.activeTaskTitle,
            selectedTaskCount: snapshot.selectedTaskCount,
            greetingVariant: snapshot.greetingVariant
        )
    }
}
