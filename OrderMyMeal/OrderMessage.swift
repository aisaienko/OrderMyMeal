//
//  OrderMessage.swift
//  OrderMyMeal
//
//  Created by Oleksandr Isaienko on 8/26/24.
//

import Foundation

final class OrderMessage: Observable, Identifiable {
    var text: String
    
    init(text: String) {
        self.text = text
    }
}
