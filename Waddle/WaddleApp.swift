//
//  WaddleApp.swift
//  Waddle
//
//  Created by Vira Fitriyani on 10/05/25.
//

import SwiftUI
import WatchConnectivity
import AppIntents

@main
struct WaddleApp: App {
    @StateObject var userData = UserData.shared
    
    init() {
        _ = WCSessionManager.shared
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        Notification.shared.requestPermission(userData: UserData.shared)
//        AppShortcutsProvider.registerAppShortcuts()
    }
    
    var body: some Scene {
        WindowGroup {
            WelcomePage()
                .environmentObject(userData)
        }
    }
}
