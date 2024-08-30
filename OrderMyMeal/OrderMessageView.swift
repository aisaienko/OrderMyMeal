//
//  OrderMessageView.swift
//  OrderMyMeal
//
//  Created by Oleksandr Isaienko on 8/26/24.
//

import SwiftUI
import SwiftData

struct OrderMessageView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Bindable var order: Order
    @State private var orderMessage: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    TextEditor(text: $order.orderMessage)
                        .padding(.horizontal)
                        .navigationTitle("Order Message Content")
                        .multilineTextAlignment(.leading)
                        .textFieldStyle(.roundedBorder)
                }
            }
            Button("Back") {
                dismiss()
            }
            .navigationTitle("Order Message")
        }
    }
}

//#Preview {
//    OrderMessageView()
//}
