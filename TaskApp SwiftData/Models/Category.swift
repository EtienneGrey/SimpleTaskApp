//
//  Category.swift
//  TaskApp SwiftData
//
//  Created by Etienne Grey on 3/23/24 @ 2:47 PM.
//  Copyright (c) 2024 Etienne Grey. All rights reserved.
//
//  Github: https://github.com/etiennegrey
//  BuyMeACoffee: https://buymeacoffee.com/etiennegrey
//


import Foundation
import SwiftData

@Model
final class Category {
    
    @Attribute(.unique)
    var title: String
    
    var items: [TaskItem]?
    
    init(title: String = "") {
        self.title = title
    }
    
}

extension Category {
    static var defaults: [Category] {
        [
            .init(title: "Study"),
            .init(title: "Work"),
            .init(title: "Family")
        ]
    }
}
