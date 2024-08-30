//
//  MealItemsPreviewContainer.swift
//  OrderMyMeal
//
//  Created by Oleksandr Isaienko on 8/25/24.
//

import Foundation
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    let schema = Schema([MealCategoryItem.self, Order.self, SettingsItem.self])
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: configuration)
    let categories = MealItemsJSONDecoder.decode(from: "DefaultMealsList")
    var testItemsToAdd: [MealItem] = []
    var maxNumberOfTestItems: Int = 10
    var testItemsNumber: Int = 0
    if categories.isEmpty == false {
        categories.forEach { categoryItem in
            let category = MealCategoryItem(name: categoryItem.name)
            container.mainContext.insert(category)
            categoryItem.mealItems.forEach {mealItem in
                let item = MealItem(mealIndex: mealItem.mealIndex, name: mealItem.name, amount: mealItem.amount, price: mealItem.price)
                category.mealItems.append(item)
                if (testItemsNumber < maxNumberOfTestItems) {
                    testItemsToAdd.append(item)
                    testItemsNumber += 1
                }
            }
            try? container.mainContext.save()
        }
    }
    let order = Order()
    container.mainContext.insert(order)
    order.timestamp = .now
    testItemsToAdd.forEach { mealItem in
        let item = OrderItem(name: mealItem.name, amount: mealItem.amount, price: mealItem.price, mealIndex: mealItem.mealIndex, quantity: 1)
        order.orderItems.append(item)
        order.units += mealItem.price
    }
    order.generateMessage()
    try? container.mainContext.save()
    let settings = SettingsItem(messageHeader: "Test header message", messageFooter: "Test footer message")
    container.mainContext.insert(settings)
    
    return container
}()
