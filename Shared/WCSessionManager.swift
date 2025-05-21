//
//  WCSessionManage.swift
//  Waddle
//
//  Created by Vira Fitriyani on 17/05/25.
//

import Foundation
import WatchConnectivity

class WCSessionManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WCSessionManager()

    private var isUpdatingFromRemote = false
    private var lastSentData: [String: Any] = [:]
    private var sessionActivated = false

    override private init() {
        super.init()
        activateSession()
    }

    private func activateSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    // MARK: iOS to watchOS
    #if os(iOS)
    func sendUserDataToWatch(userData: UserData) {
        guard WCSession.default.isReachable else { return }
        guard !isUpdatingFromRemote else { return }

        let data: [String: Any] = [
            "userName": userData.name,
            "userGender": userData.gender,
            "userWeight": userData.weight,
            "userHeight": userData.height,
            "userActivity": userData.activityState,
            "userFrequency": userData.intakeFrequency,
            "userCurrentProgress": userData.currentProgress
        ]

        guard
            data["userName"] as? String != lastSentData["userName"] as? String ||
            data["userGender"] as? String != lastSentData["userGender"] as? String ||
            data["userWeight"] as? Double != lastSentData["userWeight"] as? Double ||
            data["userHeight"] as? Double != lastSentData["userHeight"] as? Double ||
            data["userActivity"] as? String != lastSentData["userActivity"] as? String ||
            data["userFrequency"] as? Int != lastSentData["userFrequency"] as? Int ||
            data["userCurrentProgress"] as? Int != lastSentData["userCurrentProgress"] as? Int
        else { return }
        
        lastSentData = data

        do {
            try WCSession.default.updateApplicationContext(data)
            print("✅ iOS → watchOS: Application context updated")
        } catch {
            print("❌ iOS → watchOS: Failed to update application context: \(error)")
        }
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            self.isUpdatingFromRemote = true

            let userData = UserData.shared
            userData.name = applicationContext["userName"] as? String ?? ""
            userData.gender = applicationContext["userGender"] as? String ?? ""
            userData.weight = applicationContext["userWeight"] as? Double ?? 0
            userData.height = applicationContext["userHeight"] as? Double ?? 0
            userData.activityState = applicationContext["userActivity"] as? String ?? ""
            userData.intakeFrequency = applicationContext["userFrequency"] as? Int ?? 8
            userData.currentProgress = applicationContext["userCurrentProgress"] as? Int ?? 0

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isUpdatingFromRemote = false
            }
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    #endif

    // MARK: watchOS to iOS
    #if os(watchOS)
    func sendUserDataToPhone(userData: UserData) {
        guard WCSession.default.isReachable else { return }
        guard !isUpdatingFromRemote else { return }

        let data: [String: Any] = [
            "userName": userData.name,
            "userGender": userData.gender,
            "userWeight": userData.weight,
            "userHeight": userData.height,
            "userActivity": userData.activityState,
            "userFrequency": userData.intakeFrequency,
            "userCurrentProgress": userData.currentProgress
        ]

        guard
            data["userName"] as? String != lastSentData["userName"] as? String ||
            data["userGender"] as? String != lastSentData["userGender"] as? String ||
            data["userWeight"] as? Double != lastSentData["userWeight"] as? Double ||
            data["userHeight"] as? Double != lastSentData["userHeight"] as? Double ||
            data["userActivity"] as? String != lastSentData["userActivity"] as? String ||
            data["userFrequency"] as? Int != lastSentData["userFrequency"] as? Int ||
            data["userCurrentProgress"] as? Int != lastSentData["userCurrentProgress"] as? Int
        else { return }
        
        lastSentData = data

        do {
            try WCSession.default.updateApplicationContext(data)
            print("✅ watchOS → iOS: Sent user data")
        } catch {
            print("❌ watchOS → iOS: Failed to send user data: \(error)")
        }
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            self.isUpdatingFromRemote = true

            let userData = UserData.shared
            userData.name = applicationContext["userName"] as? String ?? ""
            userData.gender = applicationContext["userGender"] as? String ?? ""
            userData.weight = applicationContext["userWeight"] as? Double ?? 0
            userData.height = applicationContext["userHeight"] as? Double ?? 0
            userData.activityState = applicationContext["userActivity"] as? String ?? ""
            userData.intakeFrequency = applicationContext["userFrequency"] as? Int ?? 8
            userData.currentProgress = applicationContext["userCurrentProgress"] as? Int ?? 0

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isUpdatingFromRemote = false
            }
        }
    }
    #endif

    // MARK: - Common
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WCSession activated with state: \(activationState.rawValue)")
        sessionActivated = true
    }
}

