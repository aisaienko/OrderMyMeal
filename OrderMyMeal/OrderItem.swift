//
//  OrderItem.swift
//  OrderMyMeal
//
//  Created by Oleksandr Isaienko on 8/25/24.
//

import Foundation
import SwiftData

@Model
final class OrderItem: Identifiable {
    var id: String
    var name: String
    var amount: String
    var price: Double
    var mealIndex: Int
    var quantity: Int
    var order: Order?
    
    init(name: String, amount: String, price: Double, mealIndex: Int, quantity: Int) {
        self.id = UUID().uuidString
        self.name = name
        self.amount = amount
        self.price = price
        self.mealIndex = mealIndex
        self.quantity = quantity
    }
}
