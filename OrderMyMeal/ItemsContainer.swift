//
//  ItemsContainer.swift
//  OrderMyMeal
//
//  Created by Oleksandr Isaienko on 8/24/24.
//

import Foundation
import SwiftData

actor ItemsContainer {
    
    @MainActor
    static func create(shouldCreateDefaults: inout Bool) -> ModelContainer {
        let schema = Schema([Order.self, SettingsItem.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        if shouldCreateDefaults {
            let settings = SettingsItem(messageHeader: "", messageFooter: "")
            container.mainContext.insert(settings)
            shouldCreateDefaults = false
        }
        return container
    }
}
