import UIKit
import PlaygroundSupport

/*:
 # The Library and Code Snippets
 ## The Library
 The `+` icon (The **Library**) at the top right of Xcode is not just for objects used in storyboards and .xibs.  Depending on the context of where you press it (file type in editor), it can also show you libraries of Code Snippets, Media and Colors. The Library is used to assist in creating your code.  The tabs in the Library vary on context, but some of them are:
   * Media - the list of media (images, video) in your Assets folder
   * Colors - the list of colors in your Assets folder
   * Symbols - the list of symbols (icon like) in the system
   * Views - code templates for SwiftUI Views
   * Modifiers - code templates for SwiftUI Modifiers
   * Code Snippets - code templates for various Swift or other code chunks
 
 ## Code Snippets
Today we will just look at code snippets.  You can take chunks of code you use a lot and make a snippet.  Just select the block of code you want, click the second mouse button, and choose "create code snippet" from the popup.  From then on you can just drag and drop from the selection of code snippets.

For example, the block of code below between the START and STOP comment lines is a snippet I use to create a button.  After dropping it in, I just need to add the line `var myButtonText = "Press Here` and then create the `func` for the `buttonHandler(_:)`
 
 The nice thing with this approach, by the way, is that you can use the same `buttonHandler` function to handle a number of buttons just by building a `switch` statement based on the text in the button!
 
 */
class MyViewController : UIViewController {
    
    var myButtonText = "Press Here"
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        // START
        let myButton = { text, x, y, w, h -> UIButton in
            let button = UIButton()
            button.backgroundColor = UIColor.cyan
            button.layer.cornerRadius = 30
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
            button.frame = CGRect(x: x, y: y, width: w, height: h)
            button.layer.frame = button.frame.insetBy(dx: -5,dy: -5)
            button.isHidden = false
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.setTitle(text, for: UIControl.State())
            button.titleLabel?.font = UIFont(name: "Times New Roman", size: CGFloat(18))
            button.setTitleColor(UIColor.black, for: UIControl.State())
            button.setTitleColor(UIColor.black, for: .highlighted)
            button.addTarget(self, action: #selector(self.buttonHandler(_:)), for: .touchUpInside)
            return button
        }(myButtonText, 200, 100, 100, 100)
        view.addSubview(myButton)
        // STOP
        
        self.view = view
    }
    
    @objc func buttonHandler(_ sender: AnyObject) {
        var textString = ""
        if let label = sender.titleLabel {
            if let text = label?.text {
                textString = text
            } else {return}
        } else {return}
        switch textString {
        case myButtonText:
            print("called")
        default:
            return
        }
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

