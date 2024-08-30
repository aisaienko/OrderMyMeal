//
//  SettingsView.swift
//  OrderMyMeal
//
//  Created by Oleksandr Isaienko on 8/27/24.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Query private var settingsItems: [SettingsItem]
    
    var body: some View {
        VStack {
            NavigationStack {
                ForEach (settingsItems) { settingsItem in
                    VStack {
                        Form {
                            Section(header: Text("Message Header")) {
                                TextEditor(text: Bindable(settingsItem).messageHeader)
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.leading)
                                    .textFieldStyle(.roundedBorder)
                            }
                            Section(header: Text("Message Footer")) {
                                TextEditor(text: Bindable(settingsItem).messageFooter)
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.leading)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                    }
                }
                Button("Back to orders") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    struct Container: View {
        var body: some View {
            SettingsView()
        }
    }
    return Container()
        .modelContainer(previewContainer)
}
