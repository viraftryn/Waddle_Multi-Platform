//
//  AppIntent.swift
//  Waddle
//
//  Created by Vira Fitriyani on 23/05/25.
//

import AppIntents

struct LogProgressIntent: AppIntent, ProvidesDialog {
    var value: Never?
    
    
    static var title: LocalizedStringResource = "Log Progress"
    static var description = IntentDescription("Log a progress manually using Siri.")
    
    static var parameterSummary: some ParameterSummary {
        Summary("Log water progress")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult{
        let userData = UserData.shared
        
        if userData.hasTappedForCurrentNotification {
            return .result(
                dialog: "You've already logged hydration for this notification. Wait for the next one!"
            )
        }
        
        userData.incrementProgress()
        return .result(dialog: "Nice! I've already added a sip to your progress.")
    }
}

