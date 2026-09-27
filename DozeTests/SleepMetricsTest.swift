//
//  SleepMetricsTests.swift
//  DozeTests
//
//  Created by Gadiel Uicab on 24/09/26.
//

import Testing
import Foundation
import SwiftData
@testable import Doze

struct SleepMetricsTest {
    let emptyArr = [SleepRecord]()
    let metrics = SleepMetrics()
    let calendar = Calendar.current
    let now = Date()
    
    private func makeRecord(
        bedTime: Date = Date(),
        durationInHours: Double = 8.0,
        energyLevel: Int = 5,
        sleepLatencyMinutes: Int = 15
    ) -> SleepRecord {
        let totalSeconds = (durationInHours * 3600.0) + (Double(sleepLatencyMinutes) * 60.0)
        let wakeTime = bedTime.addingTimeInterval(totalSeconds)
        
        return SleepRecord(
            bedTime: bedTime,
            wakeTime: wakeTime,
            energyLevel: energyLevel,
            sleepLatencyMinutes: sleepLatencyMinutes
        )
    }
    
    @Test("Base Case: Array is Empty")
    func emptyArray() {
        #expect(metrics.averageEnergyLevel(records: emptyArr) == 0.0)
        #expect(metrics.averageSleepDuration(records: emptyArr) == 0.0)
        #expect(metrics.averageSleepLatency(records: emptyArr) == 0.0)
        #expect(metrics.logForDay(date: now, in: emptyArr) == nil)
        #expect(metrics.allLogs(records: emptyArr).isEmpty)
    }
    
    @Test("Happy Path: Given the array with values must return the correct calculation")
    func happyPath() {
        let records = [
            makeRecord(durationInHours: 7.0, energyLevel: 2, sleepLatencyMinutes: 10),
            makeRecord(durationInHours: 9.0, energyLevel: 4, sleepLatencyMinutes: 20)
        ]
        
        #expect(metrics.averageEnergyLevel(records: records) == 3.0)
        #expect(metrics.averageSleepDuration(records: records) == 8.0)
        #expect(metrics.averageSleepLatency(records: records) == 15.0)
    }
    
    @Test("Coincidence same day different hour")
    func situationA() throws {
        let date1 = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 25, hour: 23, minute: 00)))
        let date2 = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 25, hour: 8, minute: 00)))
        let records = [
            makeRecord(bedTime: date1),
            makeRecord(bedTime: date2)
        ]
        
        let dateToSearch = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 25, hour: 14, minute: 00)))
        let result = try #require(metrics.logForDay(date: dateToSearch, in: records))
        
        #expect(result.bedTime == records[0].bedTime)
    }
    
    @Test("No coincidence")
    func situationB() throws {
        let date1 = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 25, hour: 23, minute: 00)))
        let date2 = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 25, hour: 8, minute: 00)))
        let records = [
            makeRecord(bedTime: date1),
            makeRecord(bedTime: date2)
        ]
        
        let dateToSearch = try #require(calendar.date(from: DateComponents(year: 2026, month: 8, day: 4, hour: 2, minute: 00)))
        let result = metrics.logForDay(date: dateToSearch, in: records)
        
        #expect(result == nil)
    }
    
    @Test("Cronologic order while allLogs is used")
    func cronoLogicOrder() throws {
        let date1 = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 25, hour: 8, minute: 00)))
        let date2 = try #require(calendar.date(from: DateComponents(year: 2026, month: 8, day: 4, hour: 6, minute: 00)))
        let date3 = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 25, hour: 22, minute: 00)))
        let date4 = try #require(calendar.date(from: DateComponents(year: 2025, month: 4, day: 7, hour: 12, minute: 00)))
        let date5 = try #require(calendar.date(from: DateComponents(year: 2026, month: 8, day: 4, hour: 6, minute: 30)))
        let records = [
            makeRecord(bedTime: date1),
            makeRecord(bedTime: date2),
            makeRecord(bedTime: date3),
            makeRecord(bedTime: date4),
            makeRecord(bedTime: date5)
        ]
        
        let result = metrics.allLogs(records: records)
        
        #expect(result[0].bedTime > result[1].bedTime)
        #expect(result[1].bedTime > result[2].bedTime)
        #expect(result[2].bedTime > result[3].bedTime)
        #expect(result[3].bedTime > result[4].bedTime)
    }
}
