//
//  RESTExampleVC.swift
//  Communications
//
//  Created by Richard Telford on 2/17/20.
//  Copyright © 2020 Duke Pratt. All rights reserved.
//

import UIKit
var savePost = [String:AnyObject]()
class RESTExampleVC: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var IDField: UITextField!
    @IBOutlet weak var UserIDField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var bodyField: UITextView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var convertButton: UIButton!
    
    var session = URLSession(configuration: URLSessionConfiguration.ephemeral)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .mediumBackground
        addbutton()
    }
    
    @IBAction func RESTCall(_ sender: Any) {
        self.view.endEditing(true)
        let input = textField.text
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/" + input!)
        let httprequest = URLSession.shared.dataTask(with: url!){ (data, response, error) in
            if error != nil
            {
                print("error calling GET on /posts/")
            }
            else
            {
                do {
                    let post = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                    
                    savePost = post as [String:AnyObject]
                    print(savePost)
                    if let postID = post["id"] as? Int
                    {
                        DispatchQueue.main.async {
                            self.IDField.text = String(postID)
                        }
                    }
                    if let postTitle = post["title"] as? String
                    {
                        DispatchQueue.main.async {
                            self.titleField.text = postTitle
                        }
                    }
                    if let postUserID = post["userId"] as? Int
                    {
                        DispatchQueue.main.async {
                            self.UserIDField.text = String(postUserID)
                        }
                    }
                    if let postBody = post["body"] as? String
                    {
                        DispatchQueue.main.async {
                            self.bodyField.text = postBody
                        }
                    }
                } catch let error {
                    print("json error: \(error)")
                }
            }
            
        }
        httprequest.resume()
    }
    
    @IBAction func convertToJSON(_ sender: Any) {
        do {
            let jsonOutput = try JSONSerialization.data(withJSONObject: savePost, options: JSONSerialization.WritingOptions.prettyPrinted)
            textView.text = String(data: jsonOutput, encoding: String.Encoding.utf8)! as String
        } catch let error {
            print("json error: \(error)")
        }
    }
    
    func addbutton() {
        
        callButton.backgroundColor = UIColor.mediumBackground
        callButton.layer.cornerRadius = 10
        callButton.layer.borderWidth = 2
        callButton.layer.borderColor = UIColor.black.cgColor
        callButton.isHidden = false
        callButton.titleLabel?.textAlignment = .center
        callButton.titleLabel?.font = UIFont(name: "Times New Roman", size: CGFloat(18))
        callButton.setTitleColor(UIColor.darkText, for: UIControl.State())
        callButton.setTitleColor(UIColor.darkText, for: .highlighted)
        
        convertButton.backgroundColor = UIColor.mediumBackground
        convertButton.layer.cornerRadius = 10
        convertButton.layer.borderWidth = 2
        convertButton.layer.borderColor = UIColor.black.cgColor
        convertButton.isHidden = false
        convertButton.titleLabel?.textAlignment = .center
        convertButton.titleLabel?.font = UIFont(name: "Times New Roman", size: CGFloat(18))
        convertButton.setTitleColor(UIColor.darkText, for: UIControl.State())
        convertButton.setTitleColor(UIColor.darkText, for: .highlighted)
        
        
        let endButton = UIButton(text: "End", color: .darkText, back: .mediumBackground, fName: "American Typewriter", fSize: 14)
        endButton.addTarget(self, action: #selector(self.endAction(_:)), for: .touchUpInside)
        endButton.frame = CGRect(x: 140, y: 370, width: 100, height: 50)
        self.view.addSubview(endButton)
        
    }
    
    @objc func endAction(_ sender: AnyObject) {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
}

