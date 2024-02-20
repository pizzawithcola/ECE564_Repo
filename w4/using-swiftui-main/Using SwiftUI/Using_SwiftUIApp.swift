//
//  Using_SwiftUIApp.swift
//  Using SwiftUI
//
//  Created by Richard Telford on 2/1/23.
//

import SwiftUI

@main
struct ToDoApp: App {
    @StateObject private var modelData = ModelData()
    var body: some Scene {
        WindowGroup {
            ContentView(saveTasks: {
                ModelData.save(tasks: modelData.tasks) { result in
                    if case .failure(let error) = result {
                        fatalError(error.localizedDescription)
                    }
                }
            })
                .environmentObject(modelData)
                .onAppear {
                    ModelData.load { result in
                        switch result {
                        case .failure(let error):
                            fatalError(error.localizedDescription)
                        case .success(let tasks):
                            modelData.tasks = tasks
                        }
                    }
                }
        }
    }
}
