//
//  SleepRecordTests.swift
//  DozeTests
//  Using Setup, Act, Assert
//  Created by Gadiel Uicab on 23/09/26.
//

import Testing
import Foundation
import SwiftData
@testable import Doze

struct SleepRecordTests {
    @Test("Instantiate SleepRecord and verify its properties")
    func testSleepRecordInitialization() throws {
        let id = UUID()
        let calendar = Calendar.current
        let bedTime = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 23, hour: 23, minute: 0)))
        let wakeTime = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 24, hour: 7, minute: 0)))
        
        let energyLevel = 3
        let note: String? = nil
        let createdAt = Date()
        let sleepLatencyMinutes: Int = 30
        
        let record = SleepRecord(
            id: id,
            bedTime: bedTime,
            wakeTime: wakeTime,
            energyLevel: energyLevel,
            note: note,
            createdAt: createdAt,
            sleepLatencyMinutes: sleepLatencyMinutes
        )
        
        #expect(record.id == id)
        #expect(record.bedTime == bedTime)
        #expect(record.wakeTime == wakeTime)
        #expect(record.energyLevel == energyLevel)
        #expect(record.note == note)
        #expect(record.createdAt == createdAt)
        #expect(record.sleepLatencyMinutes == sleepLatencyMinutes)
    }
    
    @Test("Pass note=nil && note='Slept very well' into constructor", arguments: [nil, "Slept very well"])
    func testSleepRecordInitWithNote(note: String?) throws {
        let id = UUID()
        let calendar = Calendar.current
        let bedTime = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 23, hour: 23, minute: 0)))
        let wakeTime = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 24, hour: 7, minute: 0)))
        
        let energyLevel = 3
        let createdAt = Date()
        let sleepLatencyMinutes: Int = 30
        
        let record = SleepRecord(
            id: id,
            bedTime: bedTime,
            wakeTime: wakeTime,
            energyLevel: energyLevel,
            note: note, // Swift Testing will inject nil on the 1st run and "Slept very well" on the 2nd
            createdAt: createdAt,
            sleepLatencyMinutes: sleepLatencyMinutes
        )
        
        #expect(record.note == note)
    }
    
    @Test("Instantiate SleepRecord omitting id and createdAt")
    func testDefaultValuesForIDAndCreatedAt() throws {
        let calendar = Calendar.current
        let bedTime = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 23, hour: 23, minute: 0)))
        let wakeTime = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 24, hour: 7, minute: 0)))
        let startDate = Date()
        
        let record1 = SleepRecord(
            bedTime: bedTime,
            wakeTime: wakeTime,
            energyLevel: 3,
            sleepLatencyMinutes: 30
        )
        
        let record2 = SleepRecord(
            bedTime: bedTime,
            wakeTime: wakeTime,
            energyLevel: 3,
            sleepLatencyMinutes: 30
        )
        
        // 1. Verify that id is unique across instances
        #expect(record1.id != record2.id)
        // 2. Verify that createdAt is very close to the current timestamp
        #expect(abs(record1.createdAt.timeIntervalSince(startDate)) < 1.0)
    }
    
    @Test("Compute the durationInHours calculation without latency")
    func testDurationInHoursNoLatency() throws {
        let calendar = Calendar.current
        let bedTime = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 23, hour: 23, minute: 0)))
        let wakeTime = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 24, hour: 6, minute: 0)))
        
        let energyLevel = 6
        let sleepLatencyMinutes = 0
        
        let record = SleepRecord(
            bedTime: bedTime,
            wakeTime: wakeTime,
            energyLevel: energyLevel,
            sleepLatencyMinutes: sleepLatencyMinutes
        )
        
        #expect(record.durationInHours == 7.0)
    }
    
    @Test("Compute the durationInHours calculation with latency")
    func testDurationInHoursWithLatency() throws {
        let calendar = Calendar.current
        let bedTime = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 23, hour: 23, minute: 0)))
        let wakeTime = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 24, hour: 6, minute: 0)))
        
        let energyLevel = 8
        let sleepLatencyMinutes = 30
        
        let record = SleepRecord(
            bedTime: bedTime,
            wakeTime: wakeTime,
            energyLevel: energyLevel,
            sleepLatencyMinutes: sleepLatencyMinutes
        )
        
        #expect(record.durationInHours == 6.5)
    }

    @Test("Edges case")
    func testEdgeCase() throws {
        let calendar = Calendar.current
        let bedTime = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 24, hour: 23, minute: 0)))
        let wakeTime = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 25, hour: 7, minute: 0)))
        
        let energyLevel = 0
        let sleepLatencyMinutes = 480
        
        let record = SleepRecord(
            bedTime: bedTime,
            wakeTime: wakeTime,
            energyLevel: energyLevel,
            sleepLatencyMinutes: sleepLatencyMinutes
        )
        
        #expect(record.durationInHours == 0.0)
    }
    
    @MainActor @Test("Persistence in memory")
    func testPersistance() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true) //ModelConfiguration
        let container = try ModelContainer( //ModelContainer
            for: SleepRecord.self, //Extract the mainContext of the container
            configurations: config //Calls the ModelConfiguration
        )
        
        let id = UUID()
        let calendar = Calendar.current
        let bedTime = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 23, hour: 23, minute: 0)))
        let wakeTime = try #require(calendar.date(from: DateComponents(year: 2026, month: 9, day: 24, hour: 7, minute: 0)))
        
        let energyLevel = 3
        let note: String? = nil
        let createdAt = Date()
        let sleepLatencyMinutes: Int = 30
        
        let record = SleepRecord(
            id: id,
            bedTime: bedTime,
            wakeTime: wakeTime,
            energyLevel: energyLevel,
            note: note,
            createdAt: createdAt,
            sleepLatencyMinutes: sleepLatencyMinutes
        )
        
        let context = container.mainContext //Instance directly of ModelContext (every ModelContainer has a mainContext)
        context.insert(record)
        try context.save()
        
        let descriptor = FetchDescriptor<SleepRecord>()
        let results = try context.fetch(descriptor)
        
        #expect(results.count == 1)
        #expect(results.first?.id == id)
    }
}
