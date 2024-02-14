//
//  DataModel.swift
//  Using JSON
//
//  Created by Richard Telford on 1/23/23.
//

import UIKit

class ToDoList {
    //static: the property of the class
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let shared = ToDoList()

    private let ArchiveURL = DocumentsDirectory.appendingPathComponent("ToDoJSONFile")
    private var todoList = [ToDoItem]()
    
    func list() -> String {
        var outputString = ""
        let priorities = ["Critical:", "Important:", "Normal:  ", "Low:    "]
        for xx in 0...self.todoList.count-1 {
            outputString = outputString + "\(xx+1). \(priorities[self.todoList[xx].priority.rawValue-1])\t \(self.todoList[xx].itemName)\n"
        }
        return outputString
    }
    
    func append(_ item:ToDoItem) {
        self.todoList.append(item)
    }
    
    func saveJSON() -> String? {
        var outputData = Data()
        let encoder = JSONEncoder()
        var json:String? = nil
        if let encoded = try? encoder.encode(self.todoList) {
            json = String(data: encoded, encoding: .utf8)
            outputData = encoded
            do {
                try outputData.write(to: ArchiveURL)
            } catch let error as NSError {
                print (error)
                return nil
            }
            return json
        }
        else { return nil }
    }
    
    func loadJSON() -> String? {
        let decoder = JSONDecoder()
        var todoItems = [ToDoItem]()
        let tempData: Data
        
        do {
            tempData = try Data(contentsOf: ArchiveURL)
        } catch let error as NSError {
            print(error)
            return nil
        }
        if let decoded = try? decoder.decode([ToDoItem].self, from: tempData) {
            todoItems = decoded
            self.todoList = todoItems
        }

        return String(data: tempData, encoding: .utf8)
    }
}
