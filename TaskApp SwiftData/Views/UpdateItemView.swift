//
//  UpdateItemView.swift
//  TaskApp SwiftData
//
//  Created by Etienne Grey on 3/23/24 @ 1:44 PM.
//  Copyright (c) 2024 Etienne Grey. All rights reserved.
//
//  Github: https://github.com/etiennegrey
//  BuyMeACoffee: https://buymeacoffee.com/etiennegrey
//


import SwiftUI
import SwiftData

struct UpdateItemView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Query private var categories: [Category]
    
    @State private var selectedCategory: Category?
    
    @Bindable var item: TaskItem
    
    var body: some View {
        
        List {
            Section("Task Title") {
                TextField("Name", text: $item.title)
            }
            Section("General") {
                DatePicker("Date", selection: $item.timestamp)
                Toggle("Is Important?", isOn: $item.isImportant)
            }
            
            Section("Categories") {
                if categories.isEmpty {
                    ContentUnavailableView("No Categories", systemImage: "archivebox")
                } else {
                    
                    Picker("", selection: $selectedCategory) {
                        
                        ForEach(categories) { category in
                            
                            Text(category.title)
                                .tag(category as Category?)
                            
                        }
                        
                        Text("None")
                            .tag(nil as Category?)
                        
                    }
                    .labelsHidden()
                    .pickerStyle(.inline)
                }
            }
            
            Section {
                Button("Update Task") {
                    item.category = selectedCategory
                    withAnimation {
                        dismiss()
                    }
                }
            }
        }
        .onAppear() {
            selectedCategory = item.category
        }
        .navigationTitle("Update Task")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    dismiss()
                }
                
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button("Done") {
                    item.category = selectedCategory
                    dismiss()
                }
                .disabled(item.title.isEmpty)
            }
        }
    }
}


