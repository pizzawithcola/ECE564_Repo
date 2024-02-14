//
//  ToDoListTableViewController.swift
//  ToDoList
// 
//  Created by Ric Telford on 1/31/17.
//  Copyright © 2017 rictelford. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {

    var toDoItems = [ToDoItem]()
    
    func loadInitialData() {
        let item1 = ToDoItem()
        item1.itemName = "Buy Milk"
        self.toDoItems.append(item1)
        let item2 = ToDoItem()
        item2.itemName = "Buy Eggs"
        self.toDoItems.append(item2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.toDoItems.count
    }
    
    @IBAction func returnFromNewItem(segue: UIStoryboardSegue) {
        let source:NewItemViewController = segue.source as! NewItemViewController
        let item:ToDoItem = source.toDoItem
        if (item.itemName != "") {
            self.toDoItems.append(item)
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListProtoCell", for: indexPath)
        
        let tempToDoItem:ToDoItem = self.toDoItems[indexPath.row]
        cell.textLabel?.text = tempToDoItem.itemName
        if (tempToDoItem.completed) {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let tappedItem:ToDoItem = self.toDoItems[indexPath.row]
        tappedItem.completed = !tappedItem.completed
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
    }
}
