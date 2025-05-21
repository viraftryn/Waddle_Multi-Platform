//
//  Notification.swift
//  Waddle
//
//  Created by Vira Fitriyani on 10/05/25.
//

import Foundation
import UserNotifications

#if os(iOS)
import UIKit

class Notification{
    static let shared = Notification()
    private init() {}
    
    // Temporary 1-minute notifications
        func scheduleWaterReminders(for userData: UserData) {
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
    
            for i in 1...userData.intakeFrequency {
                let content = UNMutableNotificationContent()
                content.title = "💧 Time to Hydrate"
                content.body = "Take a sip and shake!"
                content.sound = UNNotificationSound(named: UNNotificationSoundName("waddleNotification.wav"))
    
                // Trigger notification every 60 seconds (1 minute apart) for testing
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i * 60), repeats: false)
    
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
            }
        }
    
    func requestPermission(userData: UserData) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Permission granted? \(granted ? "✅ YES" : "❌ NO")")
            }
            
            if granted {
                DispatchQueue.main.async {
                    self.scheduleWaterReminders(for: userData)
                    userData.hasTappedForCurrentNotification = false
                }
            }
        }
    }
}

#endif

#if os(watchOS)
import WatchKit

class NotificationController: WKUserNotificationInterfaceController {

    @IBOutlet weak var iconImage: WKInterfaceImage!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var subtitleLabel: WKInterfaceLabel!

    override func didReceive(_ notification: UNNotification) {
        let content = notification.request.content

        titleLabel.setText("💧 Time to Hydrate")
        subtitleLabel.setText("Take a sip and shake!")
        iconImage.setImageNamed("notifPict")
    }
}

#endif

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()

    private override init() {}

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        UserData.shared.resetForNewNotification()
        completionHandler([.banner, .sound]) // Show while app is open
    }
}


//    func scheduleTestNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = "🚨 Test Notification"
//        content.body = "This is a test to confirm notifications are working!"
//        content.sound = UNNotificationSound.default
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
//
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Failed to schedule test notification: \(error.localizedDescription)")
//            } else {
//                print("✅ Test notification scheduled in 1 minute")
//            }
//        }
//    }

//    func scheduleWaterReminders(for userData: UserData) {
//        let center = UNUserNotificationCenter.current()
//        center.removeAllPendingNotificationRequests()
//
//        let startHour = 8
//        let endHour = 21
//        let totalMinutes = (endHour - startHour) * 60
//        let frequency = max(userData.intakeFrequency, 1)
//        let interval = totalMinutes / frequency
//
//        for i in 0..<frequency {
//            let minutesFromStart = i * interval
//            let hour = startHour + (minutesFromStart / 60)
//            let minute = minutesFromStart % 60
//
//            var dateComponents = DateComponents()
//            dateComponents.hour = hour
//            dateComponents.minute = minute
//
//            let content = UNMutableNotificationContent()
//            content.title = "💧 Time to Hydrate"
//            content.body = "Hey \(userData.name), take a sip of water!"
//            content.sound = UNNotificationSound(named: UNNotificationSoundName("waddleNotification.wav"))
//
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//            center.add(request)
//        }
//    }
