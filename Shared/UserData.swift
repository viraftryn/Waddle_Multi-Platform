//
//  UserData.swift
//  Waddle
//
//  Created by Vira Fitriyani on 10/05/25.
//

import Foundation

class UserData: ObservableObject {
    static let shared = UserData()
    private let userDefaults = UserDefaults(suiteName: "group.com.ExperienceChallenge.Waddle")!

    @Published var currentProgress: Int {
        didSet {
            userDefaults.set(currentProgress, forKey: "userCurrentProgress")
            sync()
        }
    }

    @Published var name: String {
        didSet {
            userDefaults.set(name, forKey: "userName")
        }
    }

    @Published var gender: String {
        didSet {
            userDefaults.set(gender, forKey: "userGender")
        }
    }

    @Published var weight: Double {
        didSet {
            userDefaults.set(weight, forKey: "userWeight")
        }
    }

    @Published var height: Double {
        didSet {
            userDefaults.set(height, forKey: "userHeight")
        }
    }

    @Published var activityState: String {
        didSet {
            userDefaults.set(activityState, forKey: "userActivity")
        }
    }

    @Published var intakeFrequency: Int {
        didSet {
            userDefaults.set(intakeFrequency, forKey: "userFrequency")
            sync()
        }
    }

    @Published var hasTappedForCurrentNotification: Bool = false

    private init() {
        if CommandLine.arguments.contains("-resetUserDefaults") {
            print("Resetting UserDefaults")
            userDefaults.removePersistentDomain(forName: "group.com.ExperienceChallenge.Waddle")
        }

        userDefaults.register(defaults: [
            "userFrequency": 8,
            "userCurrentProgress": 0
        ])

        // Load data
        name = userDefaults.string(forKey: "userName") ?? ""
        gender = userDefaults.string(forKey: "userGender") ?? ""
        weight = userDefaults.double(forKey: "userWeight")
        height = userDefaults.double(forKey: "userHeight")
        activityState = userDefaults.string(forKey: "userActivity") ?? ""
        intakeFrequency = userDefaults.integer(forKey: "userFrequency")
        currentProgress = userDefaults.integer(forKey: "userCurrentProgress")

        // Initial sync after load
        DispatchQueue.main.async {
            self.sync()
        }
    }

    // Sync user data between iOS and watchOS
    private func sync() {
        #if os(iOS)
        WCSessionManager.shared.sendUserDataToWatch(userData: self)
        #elseif os(watchOS)
        WCSessionManager.shared.sendUserDataToPhone(userData: self)
        #endif
    }

    var isComplete: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !gender.isEmpty &&
        weight > 0 &&
        height > 0 &&
        !activityState.isEmpty &&
        intakeFrequency >= 8
    }

    func incrementProgress() {
        DispatchQueue.main.async {
            self.currentProgress += 1
            self.hasTappedForCurrentNotification = true
        }
    }

    func resetForNewNotification() {
        DispatchQueue.main.async {
            self.hasTappedForCurrentNotification = false
        }
    }

    var progressRatio: Double {
        intakeFrequency > 0 ? Double(currentProgress) / Double(intakeFrequency) : 0
    }

    func calculateWaterIntakeML() -> Int {
        guard weight > 0 else { return 0 }

        let pounds = weight * 2.205
        var base = gender == "Male" ? pounds * 0.67 : pounds * 0.5

        switch activityState {
        case "Low Intensity 🐌": base += 6
        case "Medium Intensity ⚙️": base += 12
        case "High Intensity 🏃‍♂️": base += 24
        default: break
        }

        let ml = (base + 12) * 29.574
        return Int(ml)
    }
}
