//
//  JSONViewController.swift
//  Persistent Storage
//
//  Created by Ric Telford on 9/5/23.
//

import UIKit

class JSONViewController: UIViewController {
    var myToDoList = ToDoList.shared

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var todoList: UITextView!
    @IBOutlet weak var jsonOutput: UITextView!
    @IBOutlet weak var todoItem: UITextField!
    @IBOutlet weak var todoPriority: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialData()
        self.todoList.text = myToDoList.list()
        saveButton.backgroundColor = .yellow
    }
    
    func loadInitialData() {
        if let json = myToDoList.loadJSON() {
            jsonOutput.text = json
        } else {
            var item1 = ToDoItem()
            item1.itemName = "Mail Package"
            item1.completed = false
            item1.creationDate = Date()
            item1.priority = .Critical
            myToDoList.append(item1)
            
            var item2 = ToDoItem()
            item2.itemName = "Buy Lottery Ticket"
            item2.completed = false
            item2.creationDate = Date()
            item2.priority = .Important
            myToDoList.append(item2)
            
            if let json = myToDoList.saveJSON() {
                jsonOutput.text = json
            }
        }
    }
    @IBAction func savePushed(_ sender: Any) {
        if let iName = todoItem.text, let pri = todoPriority.text {
            let priority = Int(pri)
            let priorities = [Priority.Critical, Priority.Important, Priority.Normal, Priority.Low]
            let newItem = ToDoItem(itemName: iName, priority: priorities[priority!-1] , completed: false, created: Date())
            myToDoList.append(newItem)
        }
        if let json = myToDoList.saveJSON() {
            self.jsonOutput.text = json
        }
        self.todoList.text = myToDoList.list()
    }
}
