//
//  TteryWidgetProvider.swift
//  TteryWidget
//

import WidgetKit

struct TteryWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> TteryWidgetEntry {
        TteryWidgetEntry(date: .now, snapshot: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (TteryWidgetEntry) -> Void) {
        let snapshot = context.isPreview ? .placeholder : WidgetDataStore.load()
        completion(TteryWidgetEntry(date: .now, snapshot: snapshot))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TteryWidgetEntry>) -> Void) {
        let snapshot = WidgetDataStore.load()
        let entry = TteryWidgetEntry(date: .now, snapshot: snapshot)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: .now) ?? .now.addingTimeInterval(1800)
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }
}
