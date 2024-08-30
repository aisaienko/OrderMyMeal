//
//  Item.swift
//  OrderMyMeal
//
//  Created by Oleksandr Isaienko on 8/23/24.
//

import Foundation

final class Basket {
    var totalUnits: Double
    var sectionUnits : [String: Double] = [:]
    var categories : [MealCategoriesResponse]
    
    init(totalUnits: Double = 0) {
        self.totalUnits = totalUnits
        self.categories = MealItemsJSONDecoder.decode(from: "DefaultMealsList")
        
    }
    
}




