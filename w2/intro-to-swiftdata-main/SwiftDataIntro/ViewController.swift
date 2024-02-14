//
//  ViewController.swift
//  SwiftDataIntro
//
//  Created by Ric Telford on 1/24/24.
//

import UIKit
import SwiftData

class ViewController: UIViewController {

    let context = Container.sharedModelContainer.mainContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = addItem()
        print(addItem())
    }
    
    @IBAction func add(_ sender: Any) {
        
    }
    
    func addItem() -> String {
        let todo = generateRandomTodoItem()
        context.insert(todo)
        try? context.save()
        let todos = FetchDescriptor<ToDoItem>(
            predicate: #Predicate { $0.name != "" }
            )
        var output = ""
        var xx = 1
        let list = try? context.fetch(todos)
        if (list != nil) {
            for item in list! {
                output = output + "\(xx)." + item.description + "\n"
                xx += 1
            }
        }
        return(output)
    }

}

