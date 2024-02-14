//
//  ViewController.swift
//  Communications
//
//  Created by Richard Telford on 2/16/20.
//  Copyright © 2020 Duke Pratt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var httpDCButtonText = "HTTP Download with Completion Handler"
    var httpDDButtonText = "HTTP Download with Delegate Method"
    var httpDLButtonText = "HTTP Download of Large File"
    var httpRESTButtonText = "HTTP REST API Calls"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .mediumBackground
        addButtons()
    }
    
    @objc func buttonHandler(_ sender: AnyObject) {
        var textString = ""
        if let label = sender.titleLabel {
            if let text = label?.text {
                textString = text
            } else {return}
        } else {return}
        switch textString {
        case httpDCButtonText:
            let hdvc = HTTPDownloadVC(nibName: "HTTPDownloadVC", bundle: nil)
            hdvc.httpType = .completion
            self.present(hdvc, animated: true, completion: nil)
        case httpDDButtonText:
            let hdvc = HTTPDownloadVC(nibName: "HTTPDownloadVC", bundle: nil)
            hdvc.httpType = .delegate
            self.present(hdvc, animated: true, completion: nil)
        case httpDLButtonText:
            let hdvc = HTTPDownloadVC(nibName: "HTTPDownloadVC", bundle: nil)
            hdvc.httpType = .delegate
            hdvc.fileSize = .large
            self.present(hdvc, animated: true, completion: nil)
        case httpRESTButtonText:
            let hdvc = RESTExampleVC(nibName: "RESTExampleVC", bundle: nil)
            self.present(hdvc, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func addButtons() {
        let httpDCButton = UIButton(text: httpDCButtonText, color: .black, back: .lightBackground, fName: "American Typewriter", fSize: 14)
        httpDCButton.addTarget(self, action: #selector(self.buttonHandler(_:)), for: .touchUpInside)
        httpDCButton.frame = CGRect(x: 50, y: 100, width: 100, height: 100)
        self.view.addSubview(httpDCButton)
        
        let httpDDButton = UIButton(text: httpDDButtonText, color: .black, back: .lightBackground, fName: "American Typewriter", fSize: 14)
        httpDDButton.addTarget(self, action: #selector(self.buttonHandler(_:)), for: .touchUpInside)
        httpDDButton.frame = CGRect(x: 200, y: 100, width: 100, height: 100)
        self.view.addSubview(httpDDButton)
        
        let httpDLButton = UIButton(text: httpDLButtonText, color: .black, back: .lightBackground, fName: "American Typewriter", fSize: 14)
        httpDLButton.addTarget(self, action: #selector(self.buttonHandler(_:)), for: .touchUpInside)
        httpDLButton.frame = CGRect(x: 50, y: 250, width: 100, height: 100)
        self.view.addSubview(httpDLButton)
        
        let httpRESTButton = UIButton(text: httpRESTButtonText, color: .black, back: .lightBackground, fName: "American Typewriter", fSize: 14)
        httpRESTButton.addTarget(self, action: #selector(self.buttonHandler(_:)), for: .touchUpInside)
        httpRESTButton.frame = CGRect(x: 200, y: 250, width: 100, height: 100)
        self.view.addSubview(httpRESTButton)
    }
}
