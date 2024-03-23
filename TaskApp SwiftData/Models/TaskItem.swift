//
//  TaskItem.swift
//  TaskApp SwiftData
//
//  Created by Etienne Grey on 3/23/24 @ 1:09 PM.
//  Copyright (c) 2024 Etienne Grey. All rights reserved.
//
//  Github: https://github.com/etiennegrey
//  BuyMeACoffee: https://buymeacoffee.com/etiennegrey
//


import Foundation
import SwiftData

@Model
final class TaskItem {
    var title: String
    var timestamp: Date
    var isImportant: Bool
    var completed: Bool
    
    @Relationship(deleteRule: .nullify, inverse: \Category.items)
    var category: Category?
    
    init(title: String = "", timestamp: Date = .now, isImportant: Bool = false, completed: Bool = false) {
        self.title = title
        self.timestamp = timestamp
        self.isImportant = isImportant
        self.completed = completed
    }
}
