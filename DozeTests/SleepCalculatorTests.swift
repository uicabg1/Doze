//
//  SleepCalculatorTests.swift
//  DozeTests
//
//  Created by Gadiel Uicab on 22/09/26.
//

import Testing
import Foundation
@testable import Doze

struct SleepCalculatorTests {

    let calculator = SleepCalculator()
    let latencyMinutes = 15

    // 1. Test for calculateWakeUpTimes
    @Test("Calculation of wake-up times")
    func testCalculateWakeUpTimes() throws {
        let bedTime = Date()
        let wakeUpTimes = calculator.calculateWakeUpTimes(from: bedTime, latencyMinutes: latencyMinutes)

        #expect(!wakeUpTimes.isEmpty, "The list of calculated times should not be empty.")
        #expect(wakeUpTimes.count == 5, "It should generate 5 time options.")
    }

    // 2. Test for calculateBedTimes
    @Test("Calculation of times to go to sleep")
    func testCalculateBedTimes() throws {
        let targetWakeTime = Date()
        let bedTimes = calculator.calculateBedTimes(for: targetWakeTime, latencyMinutes: latencyMinutes)

        #expect(!bedTimes.isEmpty, "The list of sleep times should not be empty.")
        #expect(bedTimes.count == 5, "It should generate 5 time options.")
    }

    // 3. Test for calculateCompletedCycles
    @Test("Calculation of completed cycles between two dates")
    func testCalculateCompletedCycles() throws {
        let bedTime = Date()
        // Simulates 465 minutes elapsed (3 cycles of 90 min = 270 min + 15 min latency = 285 min total -> let's test 4.5 hrs + latency)
        // 3 cycles * 90 min + 15 min latency = 285 minutes
        let wakeTime = bedTime.addingTimeInterval(TimeInterval(285 * 60))

        let completedCycles = calculator.calculateCompletedCycles(bedTime: bedTime, wakeTime: wakeTime, latencyMinutes: latencyMinutes)

        #expect(completedCycles == 3.0, "It should calculate exactly 3 completed cycles.")
    }

    // 4. Test for estimatedSleep
    @Test("Conversion of cycles to estimated hours")
    func testEstimatedSleep() throws {
        let cycles = 4 // 4 cycles * 90 min = 360 min = 6.0 hours
        let estimatedHours = calculator.estimatedSleep(cycles: cycles)

        #expect(estimatedHours == 6.0, "4 cycles of 90 minutes should equal 6.0 hours.")
    }
}
