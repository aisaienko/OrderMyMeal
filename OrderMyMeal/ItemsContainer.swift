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
        let schema = Schema([Order.self, MealCategoryItem.self, SettingsItem.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        if shouldCreateDefaults {
            let categories = MealItemsJSONDecoder.decode(from: "DefaultMealsList")
            if categories.isEmpty == false {
                categories.forEach { categoryItem in
                    let category = MealCategoryItem(name: categoryItem.name)
                    container.mainContext.insert(category)
                    categoryItem.mealItems.forEach {mealItem in
                        let item = MealItem(mealIndex: mealItem.mealIndex, name: mealItem.name, amount: mealItem.amount, price: mealItem.price)
                        category.mealItems.append(item)
                    }
                    try? container.mainContext.save()
                }
            }
            let settings = SettingsItem(messageHeader: "", messageFooter: "")
            container.mainContext.insert(settings)
            shouldCreateDefaults = false
        }
        return container
    }
}
