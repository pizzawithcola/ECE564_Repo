//
//  ViewController.swift
//  Swift and Xcode
//
//  Created by Ric Telford on 8/27/23.
//

import UIKit

class ViewController: UIViewController {
    let imageView = UIImageView(image: UIImage(named: "duke.jpg"))
    let inputField = UITextField()
    let totalLabel = UILabel()
    let totalAmount = UILabel()
    let addButton = UIButton()
    let subButton = UIButton()
    let multButton = UIButton()
    let divButton = UIButton()
    let outputView = UITextView()
    
    /*  Other options
    let mySegmented = UISegmentedControl()
    let mySwitch = UISwitch()
    let myStepper = UIStepper()
    let mySlider = UISlider()
    let myPicker = UIPickerView()
    */
    override func viewDidLoad() {
        let view = self.view!
        view.backgroundColor = .white
        
        imageView.frame = CGRect(x: 0, y:50, width:400, height:750)
        imageView.alpha = 0.3
        view.addSubview(imageView)
        
        inputField.frame = CGRect(x: 50, y: 170, width:180, height: 70)
        inputField.font = UIFont(name: "Courier", size: 30.0)
        inputField.backgroundColor = .yellow
        inputField.alpha = 0.8
        view.addSubview(inputField)
        
        totalLabel.frame = CGRect(x: 50, y: 270, width:200, height: 50)
        totalLabel.text = "Total:"
        totalLabel.textColor = .black
        totalLabel.font = UIFont(name: "Courier", size: 30.0)
        view.addSubview(totalLabel)
        
        totalAmount.frame = CGRect(x: 180, y: 270, width:200, height: 50)
        totalAmount.font = UIFont(name: "Courier", size: 30.0)
        totalAmount.text = "0"
        view.addSubview(totalAmount)
        
        addButton.frame = CGRect(x: 250, y: 150, width:50, height: 50)
        addButton.backgroundColor = .blue
        addButton.layer.cornerRadius = 10
        addButton.titleLabel?.numberOfLines = 0
        addButton.titleLabel?.textAlignment = .center
        addButton.titleLabel?.lineBreakMode = .byWordWrapping
        addButton.setTitle("+", for: UIControl.State())
        addButton.titleLabel?.font = UIFont(name: "Courier", size: CGFloat(40))
        addButton.setTitleColor(UIColor.black, for: .highlighted)
        addButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        view.addSubview(addButton)
        
        subButton.frame = CGRect(x: 310, y: 150, width:50, height: 50)
        subButton.backgroundColor = .blue
        subButton.layer.cornerRadius = 10
        subButton.titleLabel?.numberOfLines = 0
        subButton.titleLabel?.textAlignment = .center
        subButton.titleLabel?.lineBreakMode = .byWordWrapping
        subButton.setTitle("-", for: UIControl.State())
        subButton.titleLabel?.font = UIFont(name: "Courier", size: CGFloat(40))
        subButton.setTitleColor(UIColor.black, for: .highlighted)
        subButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        view.addSubview(subButton)
        
        multButton.frame = CGRect(x: 250, y: 210, width:50, height: 50)
        multButton.backgroundColor = .blue
        multButton.layer.cornerRadius = 10
        multButton.titleLabel?.numberOfLines = 0
        multButton.titleLabel?.textAlignment = .center
        multButton.titleLabel?.lineBreakMode = .byWordWrapping
        multButton.setTitle("*", for: UIControl.State())
        multButton.titleLabel?.font = UIFont(name: "Courier", size: CGFloat(40))
        multButton.setTitleColor(UIColor.black, for: .highlighted)
        multButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        view.addSubview(multButton)
        
        divButton.frame = CGRect(x: 310, y: 210, width:50, height: 50)
        divButton.backgroundColor = .blue
        divButton.layer.cornerRadius = 10
        divButton.titleLabel?.numberOfLines = 0
        divButton.titleLabel?.textAlignment = .center
        divButton.titleLabel?.lineBreakMode = .byWordWrapping
        divButton.setTitle("/", for: UIControl.State())
        divButton.titleLabel?.font = UIFont(name: "Courier", size: CGFloat(40))
        divButton.setTitleColor(UIColor.black, for: .highlighted)
        divButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        view.addSubview(divButton)
        
        outputView.frame = CGRect(x: 50, y: 350, width:300, height: 400)
        outputView.backgroundColor = .yellow
        outputView.alpha = 0.8
        view.addSubview(outputView)
    }
    
    @objc func buttonPressed(_ sender: AnyObject){
        var outputViewInfo = String()
        var tally = Int()
        var enteredData = Int()
        var textString = ""
        outputViewInfo = outputView.text
        if let label = sender.titleLabel {
            if let text = label?.text {
                textString = text
            } else {return}
        } else {return}
        tally = Int(totalAmount.text!)!
        if let temp = inputField.text {
            if let temp2 = Int(temp) {
                enteredData = temp2
            }
        }
        switch textString {
        case "+":
            tally = tally + enteredData
        case "-":
            tally = tally - enteredData
        case "*":
            tally = tally * enteredData
        case "/":
            tally = tally / enteredData
        default:
            print("didnt")
        }
        totalAmount.text = String(tally)
        inputField.text = ""
        outputView.text = outputViewInfo + "\n" + String(tally)
    }

}

