//
//  NotificationManagerTests.swift
//  DozeTests
//
//  Created by Gadiel Uicab on 29/09/26.
//

import Testing
import UserNotifications
@testable import Doze

/// Test suite for validating notification category registration, alarm scheduling,
/// cancellation, and response callback handling in `NotificationManager`.
struct NotificationManagerTests {
    let manager = NotificationManager()
    let now = Date()
    
    @Test("Verify the inactive category registry")
    func inactiveCategoryRegistry() async throws {
        let categories = await manager.notificationCenter.notificationCategories()
        
        // Assert that category identifier and embedded action identifier match expected registered values
        #expect(categories.contains(where: {
            $0.identifier == "EVENT_YES_ACTION_CATEGORY" && $0.actions.contains(where: { $0.identifier == "YES_ACTION" })
        }))
    }
    
    @Test("Verifiy the alarm programming")
    func programAlarm() async throws {
        // 1. Request system permissions to allow local notifications
        _ = await manager.askPermission()
        // 2. Schedule wake-up alarm set one hour into the future
        try await manager.scheduleWakeUpNotification(at: now.addingTimeInterval(3600), bedTime: now, sleepLatencyMinutes: 15)
        // 3. Fetch pending notification requests from notification center
        let requests = await manager.notificationCenter.pendingNotificationRequests()
        // 4. Unwrap the expected request or fail test execution if missing
        let request = try #require(requests.first(where: {$0.identifier == "WAKE_UP_ALARM"}))
        
        // 5. Verify category identifier on notification content
        #expect(request.content.categoryIdentifier == "EVENT_YES_ACTION_CATEGORY")
        // 6. Verify latency payload stored in userInfo dictionary
        if let latency = request.content.userInfo["sleepLatencyMinutes"] as? Int {
            #expect(latency == 15)
        }
        // 7. Verify bedtime timestamp stored in userInfo with sub-second precision tolerance
        if let bedTime = request.content.userInfo["bedTime"] as? Date {
            #expect(abs(bedTime.timeIntervalSince(now)) < 1.0)
        }
    }
    
    @Test("Verify the cancelation of notifications")
    func cancelNotifications() async throws {
        // 1. Authorize and schedule a notification request
        _ = await manager.askPermission()
        try await manager.scheduleWakeUpNotification(at: now.addingTimeInterval(3600), bedTime: now, sleepLatencyMinutes: 15)
        // 2. Execute notification cancellation
        await manager.cancelNotifications()
        // 3. Fetch updated pending requests list
        let requests = await manager.notificationCenter.pendingNotificationRequests()
        
        #expect(requests.isEmpty)
    }
    
    @Test("Verify that the callback emits a correct SleepRecord")
    @MainActor
    func testSleepRecordCallbackEmitsRecord() async throws {
        let expectedLatency = 15
        let expectedBedTime = now
        
        // 1. Configure asynchronous confirmation expectation for callback invocation
        await confirmation("The callback must recive YES_ACTION and instance a SleepRecord") { confirmRecord in
            // 2. Attach callback listener and validate properties of emitted SleepRecord
            manager.onSleepRecordConfirmed = { record in
                #expect(record.sleepLatencyMinutes == expectedLatency)
                #expect(record.energyLevel == 3)
                #expect(record.bedTime == expectedBedTime)
                confirmRecord()
            }
            
            // 3. Construct simulated userInfo payload dictionary
            let testUserInfo: [String: Any] = [
                "bedTime": expectedBedTime,
                "sleepLatencyMinutes": expectedLatency
            ]
            
            // 4. Execute processing helper simulating notification interaction
            manager.processNotificationResponse(actionIdentifier: "YES_ACTION", userInfo: testUserInfo)
        }
    }
}
