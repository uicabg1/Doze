//
//  SleepRecord.swift
//  Doze
//
//  Created by Gadiel Uicab on 23/09/26.
//

import SwiftData
import Foundation

@Model
class SleepRecord {
    @Attribute(.unique) var id: UUID = UUID()
    var bedTime: Date
    var wakeTime: Date
    var energyLevel: Int
    var note: String?
    var createdAt: Date = Date()
    var sleepLatencyMinutes: Int
    var durationInHours: Double {
        return ((wakeTime.timeIntervalSince(bedTime) / 60) - Double(sleepLatencyMinutes)) / 60
    }
    
    init(
        id: UUID = UUID(),
        bedTime: Date,
        wakeTime: Date,
        energyLevel: Int,
        note: String? = nil,
        createdAt: Date = Date(),
        sleepLatencyMinutes: Int
    ) {
        self.id = id
        self.bedTime = bedTime
        self.wakeTime = wakeTime
        self.energyLevel = energyLevel
        self.note = note
        self.createdAt = createdAt
        self.sleepLatencyMinutes = sleepLatencyMinutes
    }
}
