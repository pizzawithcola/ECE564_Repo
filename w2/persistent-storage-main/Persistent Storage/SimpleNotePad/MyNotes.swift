//
//  MyNotes.swift
//  SimpleNotePad
//
//  Created by Ric Telford on 7/9/15.
//  Copyright (c) 2015 Ric Telford. All rights reserved.
//

import UIKit

class MyNotes: UIDocument {
    var userText: String? = "Text From myNotes"
    
    // Called when the file is SAVED, allows for content to be set
    override func contents(forType typeName: String) throws -> Any {
        if let content = userText {
            let length = content.lengthOfBytes(using: String.Encoding.utf8)
            return Data(bytes: content, count: length)
        }
        else {
            return Data()
        }
    }
    
    // Called when the file is LOADED - sends content of file as "contents"
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let userContent = contents as? Data {
            userText = String(bytes: userContent, encoding: .utf8)
        } else {
            print("Problem with loading file")
        }
    }
}
