//
//  Item.swift
//  OrderMyMeal
//
//  Created by Oleksandr Isaienko on 8/23/24.
//

import Foundation

@Observable class Basket: ObservableObject {
    var isExpanded: Set<UUID> = []
    var totalUnits: Double
    var categories : [Category]
    
    init(totalUnits: Double = 0) {
        self.totalUnits = totalUnits
        let decodedCategories: [MealCategoriesResponse] = MealItemsJSONDecoder.decode(from: "DefaultMealsList")
        var categoryItems: [Category] = []
        if decodedCategories.isEmpty == false {
            decodedCategories.forEach { categoryItem in
                var products: [Product] = []
                categoryItem.mealItems.forEach {mealItem in
                    let product = Product(name: mealItem.name, price: mealItem.price, mealIndex: mealItem.mealIndex, amount: mealItem.amount)
                    products.append(product)
                }
                let category = Category(name: categoryItem.name, index: categoryItem.index, products: products)
                categoryItems.append(category)
            }
        }
        self.categories = categoryItems
    }
    
    func updateOrder(order: Order, settings: SettingsItem) {
        order.timestamp = .now
        order.units = self.totalUnits
        categories.forEach { category in
            category.products.forEach { product in
                if product.quantity > 0 {
                    let item = OrderItem(name: product.name, amount: product.amount, price: product.price, mealIndex: product.mealIndex, quantity: product.quantity)
                    order.orderItems.append(item)
                }
            }
        }
        var messageHeader: String = ""
        var messageFooter: String = ""
        
        messageHeader += settings.messageHeader
        messageFooter += settings.messageFooter
        order.generateMessage(messageHeader: messageHeader, messageFooter: messageFooter)
    }
    
}

@Observable class Category: ObservableObject, Identifiable {
    let id: UUID
    let index: Int
    let name: String
    let products: [Product]
    var totalPrice: Double
    
    init(name: String, index: Int, products: [Product] = []) {
        var categoryPrice: Double = 0
        self.id = UUID()
        self.name = name
        self.index = index
        self.products = products
        products.forEach { product in
            categoryPrice += product.isSelected ? (Double(product.quantity) * product.price) : 0
        }
        self.totalPrice = categoryPrice
    }
}

@Observable class Product: ObservableObject, Identifiable {
    let id: UUID
    let name: String
    let price: Double
    let amount: String
    let mealIndex: Int
    var isSelected: Bool
    var quantity: Int
    
    init(name: String, price: Double, mealIndex: Int, amount: String = "", isSelected: Bool = false, quantity: Int = 0) {
        self.id = UUID()
        self.name = name
        self.price = price
        self.mealIndex = mealIndex
        self.amount = amount
        self.isSelected = isSelected
        self.quantity = quantity
    }
}



