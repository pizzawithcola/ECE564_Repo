//
//  LandmarksApp.swift
//  Landmarks
//
//  Created by Richard Telford on 2/21/21.
//

import SwiftUI

@main
struct LandmarksApp: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
