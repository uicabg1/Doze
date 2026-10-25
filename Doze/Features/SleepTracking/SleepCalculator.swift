//
//  SleepCalculator.swift
//
//
//  Created by Gadiel Uicab on 09/09/26.
//

import Foundation

class SleepCalculator {
    let dreamCycleMinutes: Int = 90
    let userDreamCycles: [Int] = [3,4,5,6,7]
    
    /// Calculates suggested wake-up times based on a given bedtime and latency minutes.
    /// - Parameters:
    ///   - bedTime: The date and time when the user goes to sleep.
    ///   - latencyMinutes: The approximate number of minutes it should take for the user to fall asleep.
    /// - Returns: An array of target wake-up dates corresponding to different sleep cycles.
    func calculateWakeUpTimes(from bedTime: Date, latencyMinutes: Int) -> [Date] {
        var results: [Date] = []
        for cycle in userDreamCycles {
            // 1. Calculate total duration in minutes + latencyMinutes
            let totalMinutes: Int = (cycle * dreamCycleMinutes) + latencyMinutes
            // 2. Project time forward into the future
            if let newDate = Calendar.current.date(byAdding: .minute, value: totalMinutes, to: bedTime) {
                // 3. Append generated date to results array
                results.append(newDate)
            }
        }
        return results
    }
    
    /// Calculates suggested bedtimes needed to wake up at a specific target time.
    /// - Parameters:
    ///   - targetWakeTime: The desired time to wake up.
    ///   - latencyMinutes: The approximate number of minutes it should take for the user to fall asleep.
    /// - Returns: An array of suggested bedtime dates going backward in 90-minute cycles.
    func calculateBedTimes(for targetWakeTime: Date, latencyMinutes: Int) -> [Date] {
        var results: [Date] = []
        for cycle in userDreamCycles {
            // 1. Calculate total duration in minutes + latencyMinutes
            let totalMinutes: Int = (cycle * dreamCycleMinutes) + latencyMinutes
            // 2. Project time backward by using a negative value
            if let newDate = Calendar.current.date(byAdding: .minute, value: -totalMinutes, to: targetWakeTime) {
                // 3. Append generated date to results array
                results.append(newDate)
            }
        }
        return results
    }
    
    /// Computes the exact number of sleep cycles completed between bedtime and wake-up time.
    /// - Parameters:
    ///   - bedTime: The date and time the user went to sleep.
    ///   - wakeTime: The date and time the user woke up.
    ///   - latencyMinutes:The approximate number of minutes it should take for the user to fall asleep.
    /// - Returns: The total completed sleep cycles as a Double.
    func calculateCompletedCycles(bedTime: Date, wakeTime: Date, latencyMinutes: Int) -> Double {
        // 1. Measure total elapsed time in seconds
        let diffInSeconds = wakeTime.timeIntervalSince(bedTime)
        // 2. Convert latency to seconds
        let latencyInSeconds = Double(latencyMinutes * 60)
        // 3. Substract latency to obtain the actual time spent sleep
        let actualSleepSeconds = diffInSeconds - latencyInSeconds
        // Protection if latency > bedTime
        guard actualSleepSeconds > 0 else {return 0}
        // 4. Convert seconds to total 90-minute sleep cycles
        let cycleInSeconds = Double(dreamCycleMinutes * 60)
        return actualSleepSeconds / cycleInSeconds
    }
    
    /// Converts a specific number of sleep cycles into total duration in hours.
    /// - Parameter cycles: The total number of 90-minute sleep cycles.
    /// - Returns: The estimated sleep duration formatted in hours.
    func estimatedSleep(cycles: Int) -> Double {
        // Convert total cycle minutes into decimal hours
        return Double(cycles * dreamCycleMinutes) / 60
    }
}
