//
//  wordOfTheDayApp.swift
//  wordOfTheDay
//
//  Created by William Ng on 10/20/22.
//

import SwiftUI

@main
struct wordOfTheDayApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
