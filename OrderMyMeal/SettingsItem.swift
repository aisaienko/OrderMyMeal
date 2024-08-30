//
//  SettingsItem.swift
//  OrderMyMeal
//
//  Created by Oleksandr Isaienko on 8/27/24.
//

import Foundation
import SwiftData

@Model
final class SettingsItem: Identifiable {
    var id: String
    var messageHeader: String
    var messageFooter: String
    
    init(messageHeader: String = "", messageFooter: String = "") {
        self.id = UUID().uuidString
        self.messageHeader = messageHeader
        self.messageFooter = messageFooter
    }
}
