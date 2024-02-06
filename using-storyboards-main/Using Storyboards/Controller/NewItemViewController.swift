//
//  NewItemViewController.swift
//  ToDoList
// 
//  Created by Ric Telford on 1/31/17.
//  Copyright © 2017 rictelford. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    var toDoItem = ToDoItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ((sender as! UIBarButtonItem) != self.saveButton)  {
            return
        }
        if ((self.textField.text) != nil){
            self.toDoItem.itemName = self.textField.text!
            self.toDoItem.completed = false
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
