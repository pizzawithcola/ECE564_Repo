//: [Previous](@previous)

import UIKit

//:Here are 3 different way to initialize a `UIButton:`
//:1. Initialize inline in code - a lot of code, a lot of cut and paste if you want to have several buttons
let myButton1 = UIButton()
myButton1.backgroundColor = UIColor.cyan
myButton1.frame = CGRect(x: 200, y: 100, width: 100, height: 100)
myButton1.setTitle("Press Here", for: .normal)
//: 2. Create an initalizing function - cleaner inline code, harder to tweak if you want to customize some buttons
let myButton2 = initMyButton(text: "Press Here", x: 200, y: 100, width: 100, height: 100)

func initMyButton(text: String, x: Int, y: Int, width: Int, height: Int) -> UIButton {
   let button = UIButton()
   button.backgroundColor = UIColor.cyan
   button.frame = CGRect(x: x, y: y, width: width, height: height)
   button.setTitle(text, for: .normal)
   return button
}
//:3.  Use a closure expression - neater code, easy to tweak, easy to create a code snippet
let myButton3 = { text, x, y, width, height -> UIButton in
   let button = UIButton()
   button.backgroundColor = UIColor.cyan
   button.frame = CGRect(x: x, y: y, width: width, height: height)
   button.setTitle(text, for: .normal)
   return button
}("Press Here", 200, 100, 100, 100)



//: [Next](@next)
