//
//  Siri.swift
//  Waddle
//
//  Created by Vira Fitriyani on 23/05/25.
//

import AppIntents

struct ShortcutProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
            AppShortcut(
                intent: LogProgressIntent(),
                phrases: ["Add one progress in \(.applicationName)"],
                shortTitle: "Log water",
                systemImageName: "drop.fill"
            )
    }
}
