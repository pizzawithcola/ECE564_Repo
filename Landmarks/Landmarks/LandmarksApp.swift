//
//  LandmarksApp.swift
//  Landmarks
//
//  Created by Jamie on 2024/2/13.
//

import SwiftUI

@main
struct LandmarksApp: App {
    @State private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
        }
    }
}
