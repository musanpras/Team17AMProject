//
//  WidgetSyncService.swift
//  Team17Project
//

import Foundation
import WidgetKit

enum WidgetSyncService {
    static let widgetKind = "TteryWidget"

    static func update(
        currentEnergy: Int,
        maxEnergy: Int,
        activeTaskTitle: String?,
        selectedTaskCount: Int,
        greetingVariant: Int = TaskReminderNotificationManager.shared.number
    ) {
        let snapshot = WidgetSnapshot(
            currentEnergy: currentEnergy,
            maxEnergy: maxEnergy,
            activeTaskTitle: activeTaskTitle,
            selectedTaskCount: selectedTaskCount,
            greetingVariant: greetingVariant
        )
        WidgetDataStore.save(snapshot)
        WidgetCenter.shared.reloadTimelines(ofKind: widgetKind)
    }

    static func update(
        from dailyState: DailyState?,
        activeTaskTitle: String?,
        selectedTaskCount: Int
    ) {
        update(
            currentEnergy: dailyState?.currentEnergy ?? 0,
            maxEnergy: dailyState?.maxEnergy ?? 100,
            activeTaskTitle: activeTaskTitle,
            selectedTaskCount: selectedTaskCount
        )
    }
}
