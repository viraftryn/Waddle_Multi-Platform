//
//  Waddle_WatchKit_AppApp.swift
//  Waddle WatchKit App Watch App
//
//  Created by Vira Fitriyani on 10/05/25.
//

import SwiftUI
import WatchConnectivity

@main
struct Waddle_WatchKit_App_Watch_AppApp: App {
    @StateObject var userData = UserData.shared
    
    init() {
        _ = WCSessionManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(userData)
        }
    }
}
