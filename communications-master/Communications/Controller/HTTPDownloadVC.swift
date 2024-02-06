//
//  HTTPDownloadVC.swift
//  Communications
//
//  Created by Richard Telford on 2/16/20.
//  Copyright © 2020 Duke Pratt. All rights reserved.
//

import UIKit

enum HTTPType {
    case completion
    case delegate
}

enum FileSize {
    case small
    case large
}

var httpString = "https://bit.ly/3bHCKki"

class HTTPDownloadVC: UIViewController, URLSessionDownloadDelegate {
    var httpType = HTTPType.completion
    var fileSize = FileSize.small
    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .mediumBackground
        if (fileSize == .large) {
            httpString = "https://upload.wikimedia.org/wikipedia/commons/e/e5/Very_large_array_clouds.jpg"
        }
        
        addbutton()
        
        switch httpType {
            
        case .completion:
            let url = URL(string: httpString)
            let session = URLSession.shared
            /*: downloadTask takes a completion handler which it calls once the download is complete.  Here is what it would look like with just normal closure expression syntax:
             
            let task2 = session.downloadTask(with: url!, completionHandler: {(loc, resp, err) -> Void in "add code here" })
             
                but it is actually easier to read using trailing closure syntax, like this (note - you can only use trailing closure syntax if the last parameter is a closure):
            */
            let task = session.downloadTask(with: url!) {
                loc, resp, err in
                if let loc = loc, let d = try? Data(contentsOf: loc)
                {
                    let im = UIImage(data:d)
                    DispatchQueue.main.async {
                        self.iv.image = im
                    }
                }
            }
            task.resume()
        case .delegate:
            let url = URL(string: httpString)
            let session : URLSession = {
                let config = URLSessionConfiguration.ephemeral
                config.allowsCellularAccess = false
                let session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
                return session
            }()
            let req = URLRequest(url: url!)
            let task = session.downloadTask(with: req)
            task.resume()
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let t = "Downloaded \(100*totalBytesWritten/totalBytesExpectedToWrite)%"
        print(t)
        // add a percentage label to display
        DispatchQueue.main.async {
            self.label.text = t
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask:URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let d = try? Data(contentsOf: location) {
            let im = UIImage(data:d)
            DispatchQueue.main.async {
                self.iv.image = im
            }
        }
    }
    
    func addbutton() {
    
    let endButton = { text -> UIButton in
        let button = UIButton()
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.frame = CGRect(x: 140, y: 500, width: 100, height: 50)
        button.layer.borderColor = UIColor.black.cgColor
        button.isHidden = false
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.setTitle(text, for: UIControl.State())
        button.titleLabel?.font = UIFont(name: "Times New Roman", size: CGFloat(18))
        button.setTitleColor(UIColor.darkText, for: UIControl.State())
        button.setTitleColor(UIColor.darkText, for: .highlighted)
        button.addTarget(self, action: #selector(self.endAction(_:)), for: .touchUpInside)
        return button
    }("End")
    
    self.view.addSubview(endButton)
        
    }
    
    @objc func endAction(_ sender: AnyObject) {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
}
