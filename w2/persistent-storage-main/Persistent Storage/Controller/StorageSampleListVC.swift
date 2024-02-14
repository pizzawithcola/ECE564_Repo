//
//  StorageSampleListVC.swift
//  05_PersistentStorage
//
//  Created by Richard Telford on 2/9/20.
//  Copyright © 2020 Duke Pratt. All rights reserved.
//

import UIKit

class StorageSampleListVC: UITableViewController {
var objects = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objects.insert("Simple Save", at: 0)
        objects.insert("Simple NotePad", at: 1)
        objects.insert("Database", at: 2)
        objects.insert("JSON", at: 3)
      
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let object = objects[indexPath.row]
               cell.textLabel!.text = object.description
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let pvc = SimpleSaveVC(nibName: "SimpleSaveVC", bundle: nil)
            self.present(pvc, animated:true, completion:nil)
        case 1:
            let pvc = SimpleNotePadVC(nibName: "SimpleNotePadVC", bundle: nil)
            self.present(pvc, animated:true, completion:nil)
        case 2:
            let pvc = DatabaseVC(nibName: "DatabaseVC", bundle: nil)
            self.present(pvc, animated:true, completion:nil)
        case 3:
            let pvc = JSONViewController(nibName: "JSONViewController", bundle: nil)
            self.present(pvc, animated:true, completion:nil)
        default:
            break
        }
        
    }
    
}
