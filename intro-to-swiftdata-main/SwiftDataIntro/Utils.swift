//
//  Utils.swift
//  SwiftData+AppDistribution
//
//  Created by Ric Telford on 11/15/23.
//

import UIKit
import SwiftData
var tasks = ["Buy groceries", "Finish homework", "Go for a run", "Walk the Dog", "Make dinner", "Get gas", "Clean the bathroom", "Prepare for book club"]

class Container {
    static var sharedModelContainer: ModelContainer = {
        do {
            return try ModelContainer(for: ToDoItem.self)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}

func generateRandomTodoItem() -> ToDoItem {
    let xx = tasks.count
    if (xx == 0) {
        return ToDoItem(name: "NO MORE TODOS!", isComplete: true)
    }
    let randomIndex = Int.random(in: 0..<tasks.count)
    let randomTask = tasks[randomIndex]
    tasks.remove(at: randomIndex)
    let randomComplete = Int.random(in: 0...2)
    var complete = false
    if randomComplete < 1 {complete = true}
    return ToDoItem(name: randomTask, isComplete: complete)
}

