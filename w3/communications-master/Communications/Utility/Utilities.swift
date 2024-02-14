//
//  Utilities.swift
//
//
//  Created by Richard Telford on 2/1/21.
//  Copyright © 2021 ECE564. All rights reserved.
//

import UIKit

let avatar = UIImage(named: "duke.jpg")

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

extension CGRect {
    var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}

extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIColor {
    static let lightBackground = UIColor.init(red: 010/255, green: 208/255, blue: 255/255, alpha: 1)
    static let darkBackground = UIColor.init(red: 001/255, green: 33/255, blue: 105/255, alpha: 1)
    static let mediumBackground = UIColor.init(red: 187/255, green: 199/255, blue: 164/255, alpha: 1)
    static let lightText = UIColor.init(red: 235/255, green: 250/255, blue: 249/255, alpha: 1)
    static let darkText = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
}

extension UITextField {
    convenience init(place: String, color: UIColor, back: UIColor, fName: String, fSize: Int) {
        self.init()
        self.textColor = color
        self.backgroundColor = back
        self.layer.cornerRadius = 10
        self.placeholder = place
        self.setLeftPaddingPoints(10)
        self.font = UIFont(name: fName, size: CGFloat(fSize))
        self.autocorrectionType = .no
    }
}

extension UIButton {
    convenience init(text: String, color: UIColor, back: UIColor, fName: String, fSize: Int) {
        self.init()
        self.backgroundColor = back
        self.layer.cornerRadius = 20
        self.isHidden = false
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.setTitle(text, for: UIControl.State())
        self.titleLabel?.font = UIFont(name: fName, size: CGFloat(fSize))
        self.setTitleColor(color, for: UIControl.State())
        self.setTitleColor(UIColor.red, for: .highlighted)
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

public extension UIImage {
    func copy(newSize: CGSize, retina: Bool = true) -> UIImage? {
        // In next line, pass 0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
        // Pass 1 to force exact pixel size.
        UIGraphicsBeginImageContextWithOptions(
            /* size: */ newSize,
            /* opaque: */ false,
            /* scale: */ retina ? 0 : 1
        )
        defer { UIGraphicsEndImageContext() }

        self.draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIAlertController {
    //Set background color of UIAlertController - from StackOverflow
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
}
