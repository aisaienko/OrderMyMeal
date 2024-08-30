//
//  OrderDetailsView.swift
//  OrderMyMeal
//
//  Created by Oleksandr Isaienko on 8/25/24.
//

import SwiftUI
import SwiftData

struct OrderDetailsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var orderDetails: Order?
    @State private var copyButtonText: String = "Copy To Clipboard"
    @Bindable var order: Order
    private let pasteboard = UIPasteboard.general
    
    var body: some View {
        VStack {
            NavigationStack {
                List {
                    NavigationLink("Generate Message") {
                        NavigationView {
                            VStack {
                                TextEditor(text: $order.orderMessage)
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.leading)
                                    .textFieldStyle(.roundedBorder)
                                Button(action: {
                                    copyToClipboard()
                                }, label: {
                                    Label(copyButtonText, systemImage: "doc.on.doc.fill")
                                        .font(.headline)
                                        .padding()
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue)
                                })
                            }
                            .navigationTitle("OrderMessage")
                        }
                    }
                    Text("Order Date: \(order.timestamp, format: Date.FormatStyle(date: .numeric))")
                    Text("Units: \(String(order.units))")
                    ForEach(order.orderItems.sorted(by: {
                        return $0.mealIndex < $1.mealIndex
                    })) { orderItem in
                        HStack {
                            Text("\(orderItem.mealIndex).")
                            Text(orderItem.name + (orderItem.amount != "" ? "\n" : "") + orderItem.amount + ", ")
                            Spacer()
                            Text("Q: \(orderItem.quantity), ")
                            Text("Units: ")
                            Text((Double(orderItem.quantity) * orderItem.price), format: .number)
                        }
                    }
                }
            }
            Button("Back to orders") {
                dismiss()
            }
        }
        .navigationTitle("Order Details")
    }
    
    func copyToClipboard() {
        pasteboard.string = order.orderMessage
        self.copyButtonText = "Copied!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.copyButtonText = "Copy To Clipboard"
        }
    }
}

#Preview {
    struct Container: View {
        @Query var orders: [Order]
        var body: some View {
            OrderDetailsView(order: orders[0])
        }
    }
    return Container()
        .modelContainer(previewContainer)
}
