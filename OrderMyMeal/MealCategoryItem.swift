//
//  Item.swift
//  OrderMyMeal
//
//  Created by Oleksandr Isaienko on 8/24/24.
//

import Foundation
import SwiftData

@Model
final class MealCategoryItem: Identifiable {
    var id: String
    
    @Attribute(.unique)
    var name: String
    
    @Relationship(deleteRule: .cascade, inverse: \MealItem.mealCategory)
    var mealItems: Array<MealItem> = []
    
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
    }
}
