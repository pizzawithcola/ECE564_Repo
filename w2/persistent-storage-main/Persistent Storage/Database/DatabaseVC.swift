//
//  DatabaseVC.swift
//  05_PersistentStorage
//  Refer to https://github.com/stephencelis/SQLite.swift
//
//  Created by Richard Telford on 2/9/20.
//  Copyright © 2020 Duke Pratt. All rights reserved.
//

import UIKit
import SQLite

class DatabaseVC: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var from: UITextField!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var degree: UITextField!
    
    let sqliteFileName = "dukeperson.sqlite"
    let filemgr = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileURL = getDocumentsDirectory().appendingPathComponent(sqliteFileName)
        if !filemgr.fileExists(atPath: fileURL.path) {
            do {
                let databaseURL = try filemgr.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(sqliteFileName)
                let db = try Connection(databaseURL.path)
                let classroom = Table("CLASSROOM")
                let id = Expression<Int64>("ID")
                let name = Expression<String>("NAME")
                let fromLoc = Expression<String>("FROMLOC")
                let degree = Expression<String>("DEGREE")
                
                try db.run(classroom.create(ifNotExists: true) { t in
                    t.column(id, primaryKey: true)
                    t.column(name)
                    t.column(fromLoc)
                    t.column(degree)
                })
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func saveData(_ sender: AnyObject) {
        let dbName = ((name.text != nil) && (name.text != "") ? name.text! : "<empty>")
        let dbFrom = ((from.text != nil) && (from.text != "") ? from.text! : "<empty>")
        let dbDegree = ((degree.text != nil) && (degree.text != "") ? degree.text! : "<empty>")
        do {
            let databaseURL = try filemgr.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(sqliteFileName)
            let db = try Connection(databaseURL.path)
            let classroom = Table("CLASSROOM")
            let nameCol = Expression<String>("NAME")
            let fromLocCol = Expression<String>("FROMLOC")
            let degreeCol = Expression<String>("DEGREE")
            let insert = classroom.insert(nameCol <- dbName, fromLocCol <- dbFrom, degreeCol <- dbDegree)
            try db.run(insert)
            status.text = "Name Added"
            name.text = ""
            from.text = ""
            degree.text = ""
        } catch {
            status.text = "Failed to add Person. \(error.localizedDescription)"
        }
        
    }
    
    @IBAction func findPerson(_ sender: AnyObject) {
        do {
            let databaseURL = try filemgr.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(sqliteFileName)
            let db = try Connection(databaseURL.path)
            let nameCol = Expression<String>("NAME")
            let fromLocCol = Expression<String>("FROMLOC")
            let degreeCol = Expression<String>("DEGREE")
            let classroom = Table("CLASSROOM").filter(nameCol == ((name.text != nil) && (name.text != "") ? name.text! : "<empty>"))
            var isFound = false
            for user in try db.prepare(classroom) {
                from.text = user[fromLocCol]
                degree.text = user[degreeCol]
                status.text = "Record Found"
                isFound = true
                break
            }
            if !isFound {
                status.text = "Record not found"
                from.text = ""
                degree.text = ""
            }
        } catch {
            status.text = "Error"
            from.text = ""
            degree.text = ""
        }
        
    }
    
    @IBAction func returnToBase(_ sender: Any) {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
}


