//
//  Item.swift
//  OrderMyMeal
//
//  Created by Oleksandr Isaienko on 8/24/24.
//

import Foundation
import SwiftData

@Model
final class MealItem: Identifiable {
    var id: String
    var name: String
    var amount: String
    var price: Double
    var mealIndex: Int
    
//    @Relationship(deleteRule: .nullify, inverse: \MealCategoryItem.mealItems)
    var mealCategory: MealCategoryItem?
    
    init(mealIndex: Int, name: String, amount: String, price: Double) {
        self.id = UUID().uuidString
        self.name = name
        self.amount = amount
        self.price = price
        self.mealIndex = mealIndex
    }
}
