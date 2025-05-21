//
//  AppRoute.swift
//  Waddle
//
//  Created by Vira Fitriyani on 10/05/25.
//

import Foundation

enum AppRoute: Hashable {
    case name
    case gender
    case weightHeight
    case activityState
    case intakeFrequency

    case mainPage
    case profilePage
    
    case homeWatch
    case infoWatch
}

enum MascotState {
    case onTap
    case afterTap
    case goalAchieved
    case sleep
}

