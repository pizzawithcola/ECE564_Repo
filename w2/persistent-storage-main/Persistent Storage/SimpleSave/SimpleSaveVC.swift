//
//  SimpleSaveVC.swift
//  05_PersistentStorage
//
//  Created by Richard Telford on 2/9/20.
//  Copyright © 2020 Duke Pratt. All rights reserved.
//

import UIKit

class SimpleSaveVC: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var simpleSaveURL: URL = getDocumentsDirectory()
    let simpleSaveFilename = "simpleSave.txt"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.backgroundColor = UIColor.lightGray
        saveButton.layer.cornerRadius = 5
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = UIColor.black.cgColor
        
        cancelButton.backgroundColor = UIColor.lightGray
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor.black.cgColor
        
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 3
        
        simpleSaveURL = getDocumentsDirectory().appendingPathComponent(simpleSaveFilename)
        print("Here is what the URL now looks like: \n")
        print(simpleSaveURL)
    
        var err : Error?
        let filemgr = FileManager.default
        if filemgr.fileExists(atPath: simpleSaveURL.path) {
            let tempStr: String?
            do {
                tempStr = try String(contentsOf: simpleSaveURL, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            } catch let error {
                err = error
                tempStr = nil
            }
            
            if (err != nil) { print(err as Any) }
            
            textField.text = tempStr as String?
        }
        
    }
    
    @IBAction func saveIt(_ sender: AnyObject) {
        
        var err : Error?
        do {
            try textField.text!.write(to: simpleSaveURL, atomically: true, encoding: String.Encoding.utf8)
        } catch let error {
            err = error
        }
        
        if (err != nil) {
            print(err as Any)
        }
    }
    
    @IBAction func returnToBase(_ sender: Any) {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
}



