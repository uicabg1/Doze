//
//  NotificationManager.swift
//  Doze
//
//  Created by Gadiel Uicab on 27/09/26.
//

import Foundation
import UserNotifications

/// Manages local notifications, user authorization requests, interactive notification categories,
/// and schedules or cancels wake-up alerts for the application
class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    
    /// Callback closure executed when the user confirms waking up via the interactive notification action
    /// Passes the newly constructed `SleepRecord` back to the listener
    var onSleepRecordConfirmed: ((SleepRecord) -> Void)?
    
    /// Initializes the `NotificationManager`, configures itself as the system notification delegate,
    /// and registers interactive notification categories
    override init() {
        // 1. Initialize NSObject base class
        super.init()
        // 2. Assign self as delegate to capture user interactions with notifications
        notificationCenter.delegate = self
        // 3. Register interactive categories and actions with the system
        interactiveNotifications()
    }
    
    /// Requests permission from the user to display local alerts and play notification sounds
    /// - Returns: A Boolean value indicating whether authorization was granted by the user (`true`) or denied/failed (`false`)
    func askPermission() async -> Bool { // Async use when some function is going to take long time to confirm
        do {
            // 1. Request alert and sound permissions from UNUserNotificationCenter
            let authorized = try await notificationCenter.requestAuthorization(options: [.alert, .sound])
            // 2. Return authorization status
            return authorized
        } catch {
            // 3. Catch and log system errors if request fails
            print("System error while asking permission: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Configures and registers interactive notification categories and action buttons with the system
    func interactiveNotifications() {
        // 1. Create action button for wake-up confirmation
        let button = UNNotificationAction.init(
            identifier: "YES_ACTION",
            title: "Si, ya me levante",
            options: .foreground
        )
        
        // 2. Create notification category containing the action button
        let eventCategory = UNNotificationCategory.init(
            identifier: "EVENT_YES_ACTION_CATEGORY",
            actions: [button],
            intentIdentifiers: [],
            options: []
        )
        
        // 3. Register category with the notification center
        notificationCenter.setNotificationCategories([eventCategory])
    }
    
    /// Delegate method invoked by iOS when a user interacts with a delivered notification or action button.
    /// - Parameters:
    ///   - center: The notification center delivering the response
    ///   - response: The user's response object containing action identifiers and notification payload
    ///   - completionHandler: A completion block to execute once response handling is finished
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // 1. Extract action identifier and userInfo dictionary from notification payload
        let actionID = response.actionIdentifier
        let userInfo = response.notification.request.content.userInfo as? [String : Any] ?? [:]
        // 1.1 Delegate the process to the notification helper
        processNotificationResponse(actionIdentifier: actionID, userInfo: userInfo)
        // 2. Check if user pressed the confirmation action button ("YES_ACTION")
        if actionID == "YES_ACTION" {
            // 3. Safely unwrap metadata passed in userInfo payload
            if let sleepLatencyMinutes = userInfo["sleepLatencyMinutes"] as? Int,
               let bedTime = userInfo["bedTime"] as? Date {
                    // 4. Instantiate a new SleepRecord using payload data and current timestamp as wakeTime
                    let sleepRecord = SleepRecord(
                        bedTime: bedTime,
                        wakeTime: Date(),
                        energyLevel: 3,
                        note: nil,
                        sleepLatencyMinutes: sleepLatencyMinutes
                    )
                
                    // 5. Trigger callback listener passing the created SleepRecord
                    onSleepRecordConfirmed?(sleepRecord)
                }
        }
        // 6. Call system completion handler to signal processing completion
        completionHandler()
    }
    
    /// Schedules a local wake-up notification for a specific target time with attached metadata
    /// - Parameters:
    ///   - wakeTime: The target date and time when the wake-up alarm should trigger
    ///   - bedTime: The date and time when the user planned to go to sleep
    ///   - sleepLatencyMinutes: The estimated latency in minutes it takes for the user to fall asleep
    /// - Throws: An error if adding the notification request to `UNUserNotificationCenter` fails
    func scheduleWakeUpNotification(at wakeTime: Date, bedTime: Date, sleepLatencyMinutes: Int) async throws {
        // 1. Create mutable notification content and attach metadata payload to userInfo
        let notificationContent = UNMutableNotificationContent()
        notificationContent.userInfo = ["bedTime": bedTime, "sleepLatencyMinutes": sleepLatencyMinutes]
        // 2. Configure category identifier, message body, and default sound
        notificationContent.categoryIdentifier = "EVENT_YES_ACTION_CATEGORY"
        notificationContent.body = "Ya estás despierto?"
        notificationContent.sound = .default
        
        // 3. Extract hour and minute components from target wakeTime
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeTime)
        // 4. Create calendar notification trigger (non-repeating)
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        // 5. Package notification request with unique identifier, content, and calendar trigger
        let notificationRequest = UNNotificationRequest(identifier: "WAKE_UP_ALARM", content: notificationContent, trigger: notificationTrigger)
        
        // 6. Schedule notification request with system notification center
        try await notificationCenter.add(notificationRequest)
    }
    
    /// Cancels all pending local notification requests scheduled by the application
    func cancelNotifications() {
        // 1. Remove all pending notification requests from notification center
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    /// Processes notification action response metadata and triggers the confirmation callback if applicable.
    /// - Parameters:
    ///   - actionIdentifier: The identifier of the action triggered by the user.
    ///   - userInfo: The payload dictionary containing sleep metadata (`bedTime`, `sleepLatencyMinutes`).
    func processNotificationResponse(actionIdentifier: String, userInfo: [String: Any]) {
        // 1. Verify if action matches the expected YES_ACTION
        if actionIdentifier == "YES_ACTION" {
            // 2. Unpack metadata using optional binding and downcasting
            if let sleepLatencyMinutes = userInfo["sleepLatencyMinutes"] as? Int,
               let bedTime = userInfo["bedTime"] as? Date {
                
                // 3. Create the SleepRecord model
                let sleepRecord = SleepRecord(
                    bedTime: bedTime,
                    wakeTime: Date(),
                    energyLevel: 3,
                    note: nil,
                    sleepLatencyMinutes: sleepLatencyMinutes
                )
                
                // 4. Trigger callback safely via optional chaining
                onSleepRecordConfirmed?(sleepRecord)
            }
        }
    }
}
