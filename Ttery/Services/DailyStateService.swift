//
//  DailyStateService.swift
//  Team17Project
//

import SwiftData

struct DailyStateService {
    let modelContext: ModelContext

    func ensureExists(in states: [DailyState]) {
        guard states.isEmpty else { return }
        modelContext.insert(DailyState())
        save()
    }

    func save() {
        try? modelContext.save()
    }
}
