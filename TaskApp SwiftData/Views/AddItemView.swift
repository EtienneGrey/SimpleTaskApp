//
//  AddItemView.swift
//  TaskApp SwiftData
//
//  Created by Etienne Grey on 3/23/24 @ 1:12 PM.
//  Copyright (c) 2024 Etienne Grey. All rights reserved.
//
//  Github: https://github.com/etiennegrey
//  BuyMeACoffee: https://buymeacoffee.com/etiennegrey
//


import SwiftUI
import SwiftData

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @Query private var categories: [Category]
    
    @State private var item = TaskItem()
    @State private var selectedCategory: Category?
    
    
    var body: some View {
        
        List {
            Section("Task Title") {
                TextField("Name", text: $item.title)
            }
            
            Section("General") {
                DatePicker("Date", selection: $item.timestamp)
                Toggle("Is Important?", isOn: $item.isImportant)
            }
            
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
            
            Section {
                Button("Create Task") {
                    withAnimation {
                        save()
                        dismiss()
                    }
                }
                .disabled(item.title.isEmpty)
                
            }
            
        }
        .navigationTitle("Add A Task")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    dismiss()
                }
                
            }
            ToolbarItem(placement: .primaryAction) {
                Button("Done") {
                    save()
                    dismiss()
                }
                .disabled(item.title.isEmpty)
            }
        }
    }
}

private extension AddItemView {
    
    func save() {
        context.insert(item)
        item.category = selectedCategory
        selectedCategory?.items?.append(item)
    }
    
}

#Preview {
    AddItemView()
        .modelContainer(for: TaskItem.self)
}
