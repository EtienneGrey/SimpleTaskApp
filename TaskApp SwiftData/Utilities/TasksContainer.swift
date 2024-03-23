//
//  TasksContainer.swift
//  TaskApp SwiftData
//
//  Created by Etienne Grey on 3/23/24 @ 3:34 PM.
//  Copyright (c) 2024 Etienne Grey. All rights reserved.
//
//  Github: https://github.com/etiennegrey
//  BuyMeACoffee: https://buymeacoffee.com/etiennegrey
//


import Foundation
import SwiftData

actor TasksContainer {
    
    @MainActor
    static func create(shouldCreateDefaults: inout Bool) -> ModelContainer {
        let schema = Schema([TaskItem.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        
        if shouldCreateDefaults {
            Category.defaults.forEach { container.mainContext.insert($0) }
            shouldCreateDefaults = false
        }
        
        return container
    }
    
}
