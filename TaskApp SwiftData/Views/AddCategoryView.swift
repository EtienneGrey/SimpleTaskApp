//
//  AddCategoryView.swift
//  TaskApp SwiftData
//
//  Created by Etienne Grey on 3/23/24 @ 1:59 PM.
//  Copyright (c) 2024 Etienne Grey. All rights reserved.
//
//  Github: https://github.com/etiennegrey
//  BuyMeACoffee: https://buymeacoffee.com/etiennegrey
//


import SwiftUI
import SwiftData



struct AddCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var title: String = ""
    @Query private var categories: [Category]
    
    var body: some View {
        
        List {
            Section("Category Title") {
                TextField("Enter title here", text: $title)
                Button("Add Category") {
                    withAnimation {
                        let category = Category(title: title)
                        modelContext.insert(category)
                        category.items = []
                        title = ""
                    }
                }
                .disabled(title.isEmpty)
            }
            
            Section("Categories") {
                
                if categories.isEmpty {
                    ContentUnavailableView("No Categories", systemImage: "archivebox")
                } else {
                    ForEach(categories) { category in
                        Text(category.title)
                            .swipeActions {
                                Button(role: .destructive) {
                                    withAnimation {
                                        modelContext.delete(category)
                                        
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                    }
                    
                }
            }
            
        }
        .navigationTitle("Add Category")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Dismiss")
                })
            }
        }
        
    }
}

#Preview {
    NavigationStack {
        AddCategoryView()
            .modelContainer(for: Category.self)
    }
}
