//
//  OrderMyMealApp.swift
//  OrderMyMeal
//
//  Created by Oleksandr Isaienko on 8/23/24.
//

import SwiftUI
import SwiftData

@main
struct OrderMyMealApp: App {
    
    @AppStorage("isFirstTimeLaunch") private var isFirstTimeLaunch: Bool = true

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // .modelContainer(sharedModelContainer)
        .modelContainer(ItemsContainer.create(shouldCreateDefaults: &isFirstTimeLaunch))
    }
}
