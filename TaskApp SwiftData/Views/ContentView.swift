//
//  ContentView.swift
//  TaskApp SwiftData
//
//  Created by Etienne Grey on 3/23/24 @ 1:09 PM.
//  Copyright (c) 2024 Etienne Grey. All rights reserved.
//
//  Github: https://github.com/etiennegrey
//  BuyMeACoffee: https://buymeacoffee.com/etiennegrey
//


import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var context
    @Query private var items: [TaskItem]
    
    @State private var searchQuery = ""
    @State private var isAddItemPresented: Bool = false
    @State private var isAddCategoryPresented: Bool = false
    @State private var taskToEdit: TaskItem?
    
    @State private var selectedSortOption = SortOption.allCases.first!
    
    var filteredItems: [TaskItem] {
        
        //Check To See If Query Is Available
        if searchQuery.isEmpty {
            return items.sort(on: selectedSortOption)
        }
        
        let filteredItems = items.compactMap { item in
            //Filter Non-Nil Task Names
            let titleContainsQuery = item.title.range(of: searchQuery, options: .caseInsensitive) != nil
            
            //Filter Non-Nil Category Names Associated With Task
            let categoryTitleContainsQuery = item.category?.title.range(of: searchQuery, options: .caseInsensitive) != nil
            
            return (titleContainsQuery || categoryTitleContainsQuery) ? item : nil
        }
        
        return filteredItems.sort(on: selectedSortOption)
        
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(filteredItems) { item in
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.title)
                                    .bold()
                                
                                Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))")
                                    .font(.caption)
                                
                                if let category = item.category {
                                    Text(category.title)
                                        .foregroundStyle(Color.blue)
                                        .bold()
                                        .padding(5)
                                        .padding(.horizontal, 5)
                                        .background(Color.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                                }
                                
                            }
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    item.completed.toggle()
                                }
                            }, label: {
                                Image(systemName: "checkmark")
                                    .symbolVariant(.circle.fill)
                                    .foregroundStyle(item.completed ? .green : .gray)
                                    .font(.largeTitle)
                            })
                            .buttonStyle(.plain)
                            
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                
                                withAnimation {
                                    context.delete(item)
                                }
                                
                            } label: {
                                Label("Delete", systemImage: "trash")
                                    .symbolVariant(.fill)
                            }
                            
                            Button {
                                taskToEdit = item
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
                        
                    }
                }
            }
            .navigationTitle("Task List")
            .animation(.easeIn, value: filteredItems)
            .searchable(text: $searchQuery,
                        prompt: "Search Tasks")
            .overlay {
                if filteredItems.isEmpty {
                    ContentUnavailableView.search
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("Add Task") {
                            isAddItemPresented = true
                        }
                        
                        Button("Add Category") {
                            isAddCategoryPresented = true
                        }
                        
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("", selection: $selectedSortOption) {
                            ForEach(SortOption.allCases, id: \.rawValue) { option in
                                Label(option.rawValue.capitalized, systemImage: option.systemImage)
                                    .tag(option)
                            }
                        }
                        
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            
        }
        .sheet(isPresented: $isAddItemPresented) {
            NavigationStack {
                AddItemView()
            }
        }
        .sheet(isPresented: $isAddCategoryPresented) {
            NavigationStack {
                AddCategoryView()
            }
        }
        .sheet(item: $taskToEdit) {
            taskToEdit = nil
        } content: { item in
            NavigationStack {
                UpdateItemView(item: item)
            }
        }
        
    }
}


private extension [TaskItem] {
    
    func sort(on option: SortOption) -> [TaskItem] {
        
        switch option {
        case .title:
            self.sorted(by: { $0.title < $1.title })
        case .date:
            self.sorted(by: { $0.timestamp < $1.timestamp })
        case .category:
            self.sorted(by: {
                guard let firstItemTitle = $0.category?.title,
                      let secondItemTitle = $1.category?.title else { return false}
                
                return firstItemTitle < secondItemTitle
                
            })
        }
    }
}

enum SortOption: String, CaseIterable {
    case title
    case date
    case category
    
    var systemImage: String {
        switch self {
        case .title:
            "textformat.size.larger"
        case .date:
            "calendar"
        case .category:
            "folder"
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: TaskItem.self)
}
