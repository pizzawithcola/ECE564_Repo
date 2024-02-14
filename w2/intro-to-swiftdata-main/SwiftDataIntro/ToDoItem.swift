//
//  Item.swift
//  SwiftData+AppDistribution
//
//  Created by Ric Telford on 11/15/23.
//

import UIKit
import SwiftData

@Model
final class ToDoItem: Identifiable, CustomStringConvertible{
    var id: UUID
    var name: String
    var isComplete: Bool
    var description: String {
        let done = self.isComplete ? "\u{2611}" : "\u{2610}"
       return "\(name) \(done)\n"
    }
    init(id: UUID = UUID(), name: String = "", isComplete: Bool = false) {
        self.id = id
        self.name = name
        self.isComplete = isComplete
    }
}
