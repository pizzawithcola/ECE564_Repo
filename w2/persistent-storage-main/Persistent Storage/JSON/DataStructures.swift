//
//  DataStructures.swift
//  Using JSON
//
//  Created by Richard Telford on 1/23/23.
//

import UIKit

enum Priority : Int, Codable {
    case Critical = 1
    case Important = 2
    case Normal = 3
    case Low = 4
}

struct ToDoItem: Codable, CustomStringConvertible {
    
    var itemName: String = ""
    var priority: Priority = .Low
    var completed: Bool = false
    var creationDate = Date()
    
    var description: String {
        self.itemName
    }
    
    init(){}
    
    init(itemName: String, priority: Priority, completed:Bool, created: Date) {
        self.itemName = itemName
        self.priority = priority
        self.completed = completed
        self.creationDate = created
    }
}
