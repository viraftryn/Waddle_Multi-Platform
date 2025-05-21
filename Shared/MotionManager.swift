//
//  MotionManager.swift
//  Waddle
//
//  Created by Vira Fitriyani on 11/05/25.
//

import SwiftUI
import CoreMotion

#if os(iOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#endif

class MotionManager: ObservableObject {
    
    private var motion = CMMotionManager()
    private var timer: Timer?
    private let userData: UserData
    
    private let sipKey = "sipCount"
    private let periodKey = "lastShakePeriodIndex"
    private let dateKey = "lastResetDate"

    @Published var sipCount: Int = UserDefaults.standard.integer(forKey: "sipCount")
    @Published var showShakeAlert = false
    @Published var shakeAlertMessage = ""

    private var lastShakePeriodIndex: Int = UserDefaults.standard.integer(forKey: "lastShakePeriodIndex")
    
    private let resetInterval: TimeInterval = 150 // 2.5 minutes
//    private let startHour = 8
//    private let endHour = 21

    var maxSips: Int {
        max(userData.intakeFrequency, 8)
    }

    init(userData: UserData) {
        self.userData = userData
            checkIfShouldReset()
            startMotionUpdates()
    }
    
    // MARK: - Reset Logic
    private func checkIfShouldReset() {
        let now = Date()
        let lastReset = UserDefaults.standard.object(forKey: dateKey) as? Date ?? .distantPast

        // Reset if more than 2 minutes have passed since last reset
        if now.timeIntervalSince(lastReset) > resetInterval {
            sipCount = 0
            userData.currentProgress = 0
            userData.resetForNewNotification()
            lastShakePeriodIndex = getCurrentPeriodIndex() - 1
            
            // Persist reset values
            UserDefaults.standard.set(sipCount, forKey: sipKey)
            UserDefaults.standard.set(lastShakePeriodIndex, forKey: periodKey)
            UserDefaults.standard.set(now, forKey: dateKey)

            print("Reset triggered on app launch.")
            }
        }
    
    // MARK: - Motion Detection
    func startMotionUpdates() {
        guard motion.isAccelerometerAvailable else { return }
        
        motion.accelerometerUpdateInterval = 0.2
        motion.startAccelerometerUpdates()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in self.checkIfShouldReset()
            
            guard let data = self.motion.accelerometerData else { return }
            let acceleration = data.acceleration
            let vector = sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z)
            let threshold = 2.3
            
            if vector > threshold && self.sipCount < self.maxSips {
                DispatchQueue.main.async {
                    self.handleShakeIfNeeded(frequency: self.maxSips)
                }
            }
        }
    }
    
    // Shake Temporary 1-Minute
    func getCurrentPeriodIndex() -> Int {
        Int(Date().timeIntervalSince1970 / 60) // One period = one minute
    }
    
    func handleShakeIfNeeded(frequency: Int) {
        let currentPeriod = getCurrentPeriodIndex()

        if currentPeriod != lastShakePeriodIndex {
            sipCount += 1
            userData.currentProgress += 1
            lastShakePeriodIndex = currentPeriod
            userData.hasTappedForCurrentNotification = false

            // Save both to UserDefaults
            UserDefaults.standard.set(sipCount, forKey: sipKey)
            UserDefaults.standard.set(lastShakePeriodIndex, forKey: periodKey)

            triggerHapticFeedback()

        } else {
            if !userData.hasTappedForCurrentNotification {
                shakeAlertMessage = "Oops! You’ve already add progress during this period. Please wait for the next notification."
                showShakeAlert = true
                print("Shake ignored. Already used in period: \(currentPeriod)")
                userData.hasTappedForCurrentNotification = true
            }
        }
    }
    
    private func triggerHapticFeedback() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            generator.impactOccurred()
        }
        #elseif os(watchOS)
        WKInterfaceDevice.current().play(.success)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            WKInterfaceDevice.current().play(.success)
        }
        #endif
    }


    deinit {
        motion.stopAccelerometerUpdates()
        timer?.invalidate()
    }
}

// Reset Daily
//            let calendar = Calendar.current
//            let today = calendar.startOfDay(for: Date())
//            let lastReset = UserDefaults.standard.object(forKey: dateKey) as? Date ?? .distantPast
//            let lastResetDay = calendar.startOfDay(for: lastReset)
//
//            if today > lastResetDay {
//                sipCount = 0
//                lastShakePeriodIndex = -1
//                UserDefaults.standard.set(sipCount, forKey: sipKey)
//                UserDefaults.standard.set(lastShakePeriodIndex, forKey: periodKey)
//                UserDefaults.standard.set(Date(), forKey: dateKey)
//            }

//    func getCurrentPeriodIndex(frequency: Int, startHour: Int = 8, endHour: Int = 21) -> Int? {
//        let calendar = Calendar.current
//        let now = Date()
//        let components = calendar.dateComponents([.hour, .minute], from: now)
//
//        guard let hour = components.hour, let minute = components.minute else { return nil }
//
//        let totalMinutes = (endHour - startHour) * 60
//        let interval = totalMinutes / frequency
//        let currentMinutes = (hour - startHour) * 60 + minute
//
//        guard currentMinutes >= 0 && currentMinutes < totalMinutes else { return nil }
//
//        return currentMinutes / interval
//    }

//    func handleShakeIfNeeded(frequency: Int) {
//        guard let currentPeriod = getCurrentPeriodIndex(frequency: frequency, startHour: startHour, endHour: endHour) else { return }
//
//        if currentPeriod != lastShakePeriodIndex {
//            sipCount += 1
//            lastShakePeriodIndex = currentPeriod
//
//            // Save both to UserDefaults
//            UserDefaults.standard.set(sipCount, forKey: sipKey)
//            UserDefaults.standard.set(lastShakePeriodIndex, forKey: periodKey)
//
//            // Haptic feedback
//            let generator = UIImpactFeedbackGenerator(style: .heavy)
//            generator.prepare()
//            generator.impactOccurred()
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//                generator.impactOccurred()
//            }
//
//        } else {
//            print("Oh no! shake has already been used for this period (\(currentPeriod))")
//            shakeAlertMessage = "Oops! You’ve already shaken during this period. Please wait for the next notification to shake again."
//            showShakeAlert = true.
//        }
//    }
