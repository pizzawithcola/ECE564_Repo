//
//  SimpleNotePadVC.swift
//  05_PersistentStorage
//
//  Created by Richard Telford on 2/9/20.
//  Copyright © 2020 Duke Pratt. All rights reserved.
//

import UIKit

class SimpleNotePadVC: UIViewController {
    
    @IBOutlet weak var noteView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var document: MyNotes?
    var documentURL: URL?
    let simpleNotePadFilename = "SimpleNotePad.txt"
    
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
        
        noteView.layer.borderColor = UIColor.black.cgColor
        noteView.layer.borderWidth = 3
        
        documentURL = getDocumentsDirectory().appendingPathComponent(simpleNotePadFilename)
        
        document = MyNotes(fileURL: documentURL!)
        
        let filemgr = FileManager.default
        if filemgr.fileExists(atPath: documentURL!.path) {
            document?.open(completionHandler: {(success: Bool) -> Void in
                if success {
                    print("File open OK")
                    self.noteView.text = self.document?.userText
                } else {
                    print("Failed to open file")
                }
            })
        } else {
            document?.save(to: documentURL!, for: .forCreating,completionHandler: {(success: Bool) -> Void in
                if success {
                    print("File created OK")
                }
                else {
                    print("Failed to create file")
                }
            })
        }
    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        self.noteView.resignFirstResponder()
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveDocument(_ sender: AnyObject) {
        self.noteView.resignFirstResponder()
        saveIt(noteView.text)
    }
    
    func saveIt(_ saveString : String) {
        document?.userText = saveString
        document?.save(to: documentURL!, for: .forOverwriting, completionHandler: {(success: Bool) -> Void in
            if success {
                print("File overwrite OK")
            } else {
                print("File overwrite failed")
            }
        })
    }
    
}

