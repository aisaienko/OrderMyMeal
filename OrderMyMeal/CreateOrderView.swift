//
//  CreateOrderView.swift
//  OrderMyMeal
//
//  Created by Oleksandr Isaienko on 8/25/24.
//

import SwiftUI
import SwiftData

struct CreateOrderView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var mealCategoryItems: [MealCategoryItem]
    @Query private var mealItems: [MealItem]
    @Query var settings: [SettingsItem]
    @State private var isExpanded: Set<String> = []
    @State private var order = Order()
    @State private var selectedItems: [String: Int] = [:]
    @State private var totalUnits : Double = 0
    @State private var sectionUnits : [String: Double] = [:]
    @State private var score: Int = 0
    @State private var buttonText = "Create Order"
    private let pasteboard = UIPasteboard.general

    var body: some View {
        NavigationView {
            VStack {
                Text("Total Units Used: " + String(totalUnits))
                List {
                    ForEach(mealCategoryItems) { mealCategoryItem in
                        Section(isExpanded: Binding<Bool> (
                            get: {
                                return isExpanded.contains(mealCategoryItem.id)
                            },
                            set: { isExpanding in
                                if isExpanding {
                                    isExpanded.insert(mealCategoryItem.id)
                                } else {
                                    isExpanded.remove(mealCategoryItem.id)
                                }
                            })) {
                                ForEach(mealCategoryItem.mealItems.sorted(by: {
                                    return $0.mealIndex < $1.mealIndex
                                }), id: \.self) { mealItem in
                                HStack {
                                    Text(String(mealItem.mealIndex) + ".").foregroundStyle(.red)
                                    Text(mealItem.name + (mealItem.amount != "" ? "\n" : "") + mealItem.amount)
                                    Text(String(mealItem.price)).padding(5).background(.yellow).clipShape(Circle())
                                    Spacer()
                                    Text((selectedItems[mealItem.id] ?? 0), format: .number).padding(5).background(.green)
                                    Button("Add meal", systemImage: "plus", action: {
                                        selectedItems[mealItem.id] = (selectedItems[mealItem.id] ?? 0) + 1
                                        totalUnits += mealItem.price
                                        
                                        sectionUnits[mealCategoryItem.id] = (sectionUnits[mealCategoryItem.id] ?? 0) + mealItem.price
                                    }).labelStyle(.iconOnly).buttonStyle(.borderless)
                                    Button("Remove meal", systemImage: "minus", action: {
                                        if (selectedItems[mealItem.id] ?? 0) > 1 {
                                            selectedItems[mealItem.id] = (selectedItems[mealItem.id] ?? 0) - 1
                                        } else {
                                            selectedItems[mealItem.id] = nil
                                        }
                                        if totalUnits >= mealItem.price {
                                            totalUnits -= mealItem.price
                                        } else {
                                            totalUnits = 0
                                        }
                                        
                                        if (sectionUnits[mealCategoryItem.id] ?? 0) >= mealItem.price {
                                            sectionUnits[mealCategoryItem.id] = (sectionUnits[mealCategoryItem.id] ?? 0) - mealItem.price
                                        } else {
                                            sectionUnits[mealCategoryItem.id] = 0
                                        }
                                    }).labelStyle(.iconOnly).buttonStyle(.borderless).disabled(selectedItems[mealItem.id] == nil)
                                }.listRowBackground(selectedItems[mealItem.id] != nil ? Color.green : Color(.clear))
                            }
                        } header: {
                            Text(mealCategoryItem.name + " (" + String((sectionUnits[mealCategoryItem.id] ?? 0)) + " Units)").font(.headline).foregroundStyle(.brown)
                        }
                    }
                }.listStyle(.sidebar)
                Button(buttonText) {
                    withAnimation {
                       modelContext.insert(order)
                        order.timestamp = .now
                        order.units = totalUnits
                        mealItems.forEach { mealItem in
                            if selectedItems[mealItem.id] != nil {
                                let item = OrderItem(name: mealItem.name, amount: mealItem.amount, price: mealItem.price, mealIndex: mealItem.mealIndex, quantity: (selectedItems[mealItem.id] ?? 0))
                                order.orderItems.append(item)
                            }
                        }
                        var messageHeader: String = ""
                        var messageFooter: String = ""
                        
                        settings.forEach { settingItem in
                            messageHeader += settingItem.messageHeader
                            messageFooter += settingItem.messageFooter
                        }
                        order.generateMessage(messageHeader: messageHeader, messageFooter: messageFooter)
                        copyToClipboard()
                        try? modelContext.save()
                    }
                    dismiss()
                }
            }
        }
    }
    
    func copyToClipboard() {
        pasteboard.string = self.order.orderMessage
        self.buttonText = "Copied To Clipboard!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.buttonText = "Create Order"
        }
    }
}

#Preview {
    struct Container: View {
        var body: some View {
            CreateOrderView()
        }
    }
    return Container()
        .modelContainer(previewContainer)
}
