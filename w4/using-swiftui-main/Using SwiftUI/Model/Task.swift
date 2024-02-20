//
//  Task.swift
//  ToDo
//
//  Created by Anshu Dwibhashi on 6/2/22.
//

import Foundation

struct Task: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var description: String
    var isDone: Bool
    var lastModified: Date
}
