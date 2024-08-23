//
//  Item.swift
//  OrderMyMeal
//
//  Created by Oleksandr Isaienko on 8/23/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
