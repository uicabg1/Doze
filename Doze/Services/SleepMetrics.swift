//
//  SleepMetrics.swift
//  Doze
//
//  Created by Gadiel Uicab on 24/09/26.
//

import Foundation

    class SleepMetrics {
    func averageEnergyLevel(records: [SleepRecord]) -> Double { // $0 -> Shorthand argument name of first value = 0.0
        return records.isEmpty ? 0.0 : records.reduce(0.0, { $0 + Double($1.energyLevel) }) / Double(records.count)
    }
    
    func averageSleepDuration(records: [SleepRecord]) -> Double {
        return records.isEmpty ? 0.0 : records.reduce(0.0, { $0 + $1.durationInHours }) / Double(records.count)
    }
    
    func averageSleepLatency(records: [SleepRecord]) -> Double {
        return records.isEmpty ? 0.0 : records.reduce(0.0, { $0 + Double($1.sleepLatencyMinutes) }) / Double(records.count)
    }
    
    func logForDay(date: Date, in records: [SleepRecord]) -> SleepRecord? {
        return records.first(where: { Calendar.current.isDate($0.bedTime, inSameDayAs: date) })
    }
    
    func allLogs(records: [SleepRecord]) -> [SleepRecord] {
        return records.sorted(by: { $0.bedTime > $1.bedTime} )
    }
}
