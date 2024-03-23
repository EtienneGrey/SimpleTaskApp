//
//  TaskApp_SwiftDataApp.swift
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

@main
struct TaskApp_SwiftDataApp: App {
    
    @AppStorage("isFirstTimeLaunch") private var isFirstTimeLaunch: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(TasksContainer.create(shouldCreateDefaults: &isFirstTimeLaunch))
        }
    }
}
