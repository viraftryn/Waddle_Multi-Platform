//
//  MascotViewModel.swift
//  Waddle
//
//  Created by Vira Fitriyani on 15/05/25.
//

import SwiftUI

class MascotViewModel: ObservableObject {
    @Published var mascotState: MascotState = .onTap
    private var userData: UserData
    private var timer: Timer?
    
    init(userData: UserData) {
        self.userData = userData
        updateMascotState()
    }
    
    func updateMascotState() {
        if userData.currentProgress >= userData.intakeFrequency {
            mascotState = .goalAchieved
            goToSleepMode()
        } else if userData.currentProgress == 0 || !userData.hasTappedForCurrentNotification {
            mascotState = .onTap
        } else {
            mascotState = .afterTap
        }
    }

    
    func handleTap() {
        guard mascotState == .onTap, !userData.hasTappedForCurrentNotification else { return }
        userData.incrementProgress()
        mascotState = userData.currentProgress >= userData.intakeFrequency ? .goalAchieved : .afterTap
        if mascotState == .goalAchieved {
            goToSleepMode()
        }
    }
    
    private func goToSleepMode() {
        timer? .invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [weak self] _ in self? .mascotState = .sleep
        }
    }
}
