//
//  TteryWidget.swift
//  TteryWidget
//

import SwiftUI
import WidgetKit

@main
struct TteryWidgetBundle: WidgetBundle {
    var body: some Widget {
        TteryWidget()
    }
}

struct TteryWidget: Widget {
    let kind = "TteryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TteryWidgetProvider()) { entry in
            TteryWidgetView(entry: entry)
        }
        .configurationDisplayName("ttery")
        .description("see your energy and what ttery wants to say.")
        .supportedFamilies([.systemSmall])
    }
}
