/*:
 Once again we are in a Playground viewing the lecture notes, but this time it is a special type of Playground that allows for UI viewing.  You need to import `PlaygroundSupport` to do this.
  */
import UIKit
import PlaygroundSupport
let view = UIView()
/*:
# Xcode
* Xcode is the Integrated Development Environment (IDE) used for Apple development.  This is the development environment for any type of project (iOS, macOS, etc) on an Apple device.
* For detailed information on using Xcode, select `Help->Xcode Help` or go to the information on [Apple Help site](https://help.apple.com/xcode/mac/current/#/devc8c2a6be1)
 */
//: ![Picture of Xcode IDE](Xcode.jpg)
/*:
 ## 1. Editor Area
* Code editing and interface design pane
* Jump bar across the top allows another way to navigate
* Multiple edit windows can be open as well as various assistant editors
* The editor pane can also be split to show the Version editor
* The entire project view can be tabbed as well (File->New->Tab)
* Secondary windows can be used for projects or editor panes
 */
/*:
 ## 2. Navigator Area
### There are 9 views in Navigator pane, selectable via the icons
 * Project (Cmd-1) – basic navigation through the files
 * Source Control (Cmd-2) - list of Git branches and remotes
 * Symbol (Cmd-3) – all names (classes, structs, etc)
 * Search (Cmd-4) – finds text globally in project / headers
 * Issue (Cmd-5) – warnings and errors in your project
 * Test (Cmd-6) – files outside your app to test your app
 * Debug (Cmd-7) – manages your debug session
 * Breakpoint (Cmd-8) – lists all breakpoints
 * Log (Cmd-9) – view all logged events

 Filter bar at bottom filters results
 */
/*:
 ## 3. Inspector Area
 * Use the Inspector Area to view and edit information for an object that you have selected in the navigator or editor area.
 * Consists of a set of "inspectors" that are object dependent - not all are applicable to all objects
    * File inspector (Cmd-Opt-1)
    * History inspector (Cmd-Opt-2)
    * Quick Help (Cmd-Opt-3)
    * Identity (Cmd-Opt-4)
    * Attributes (Cmd-Opt-5)
    * Size (Cmd-Opt-6)
    * Connections (Cmd-Opt-7)
 */
/*:
## 4. Debug area
  * Debug mode is entered whenever a breakpoint is set in the code and the code is run
 * Debug consists of two sub-panes – the list of variables in use and the debug I/O window
   * Either can be collapsed from view
   * The debug toolbar controls stepping through the code, navigating through the code
   * The I/O window shows output from the program /debugger and allows commands to be input
 * Variable window has icons to get a Quick View of a variable and to Print Description in I/O window
 */
/*:
 # Finding information in Xcode
* Control-click in the Xcode UI
* Search bar in Help pulldown
* Programming Guides (online)
* Documentation and API Reference (Shift-Cmd-O)
* Quick Help (Option-click)
* Sample Code
* AND OF COURSE…
    * Google
    * stackoverflow.com
*/
/*:
## Glossary of Terms and Types
* **Project** – a repository for all the files, resources, and information required to build one or more software products. A project contains all the elements used to build your products and maintains the relationships between those elements.
* **Workspace** -  an Xcode document that groups projects and other documents so you can work on them together. A workspace can contain any number of Xcode projects, plus any other files you want to include
* **Scheme** - defines a collection of targets to build, a configuration to use when building, and a collection of tests to execute.
* **Target** - specifies a product to build and contains the instructions for building the product from a set of files in a project or workspace
 * **Group** – folders for organizing files and information in a project view (not the same as the folder structure on disk)
*/
/*:
### Inside the Project Folder
 * When a project is created, a template folder is copied for the type of project chosen and created on disk
 * The contents of the project folder should never be edited directly
 * The project should only be managed via the Project Navigator
 * The view of the Project in the Navigator **does not** correspond directly to the disk version
 * Folders in the Project Navigator are called “Groups” and may or may not correspond to disk folders (like “Supporting Files” for example)
 *.storyboard and .xib files contain the UI view of your project
 * Images.xcassets is an asset catalog of additional assets for the project (like the icons)
 * The root project icon represents the meta-data for the project and allows you to edit project and target settings
 */
/*:
 To start a project in Xcode, you go `File->New->Project`.  Let's do that now using a Storyboard as the UI Builder
 ## Simple Project
* File->New->Project
* We are going to choose "App" template in the iOS box as the platform since that is what we will use for the first homework assignment
* We will call it SimpleApp
* Choose "Storyboard" for now as the Interface, not "SwiftUI"
* Make sure the language is "Swift"
* Use "edu.duke.yournetid" as the Organization Identifier
* You can UNCHECK "core data" and "tests".
* You should check "Create Git repo" when you save unless you plan to do that later on your own.
* Add the following code to the "ViewDidLoad()" method inside the ViewController class:
 */
let label = UILabel()
label.frame = CGRect(x: 100, y: 270, width:400, height: 50)
label.text = "Duke University"
label.textColor = .blue
label.font = UIFont(name: "GillSans", size: 30)
view.addSubview(label)
//: * Hit the triangle to compile and run the code
/*:
# The iOS app - MVC and MVVM
 * The traditional iOS application pattern is
*MVC*
– Model, View, Control
 * *Model* represents the data that persists in your application
 * *View* is the user interface that display / accept data
 * *Control* is the “glue” between the presentation of the views and interactions with data model
In an iOS or OS X application, the Control function is handled in something called a *View Controller*
 * Xcode 11 introduced the concept of **SwiftUI** as the way to create your Views (User Interface).
 * **SwiftUI** has a *declarative syntax* - you focus more on what you want your code to do, not how it is implemented.
 * SwiftUI apps follow an **MVVM** pattern - Model, View, ViewModel
 * We will discuss **SwiftUI** later in the semester
 */
/*:
 # Data Model
* A data model holds information about your application’s objects and the graph of how objects relate to each other.
* A good application has the data model separate from the view of the data.  That is, you can change the views into how the data is presented without changing the underlying model.
* Data can be managed, for example, in classes and structures, or pre-defined structure types (Arrays and Dictionaries).
* Data is then persisted in files, databases, on a server, etc.
* iOS offers many ways to create and manage a data model, including the new `SwiftData` framework which we will discuss next week.
*/
/*:
# Views
* *View* object – `UIView` class instance
    *  Displays a particular type of content in a rectangle on the Window
    *  If you use a Storyboard, the base View is represented visually in the Interface Builder.
    *  Otherwise, you use the view property of the ViewController to add your subViews.
    *  A view can contain any number of subviews which appear on the view
* UIKit provides a set of pre-made views that can be grouped into the following categories
   * Content
   * Collections
   * Controls
   * Bars
   * Input
    * Containers
    * Modal
 * Some examples of the pre-made views:
 */
let myLabel = UILabel()
let myTextField = UITextField()
let myButton = UIButton()
let mySegmented = UISegmentedControl()
let mySwitch = UISwitch()
let myStepper = UIStepper()
let mySlider = UISlider()
let myPicker = UIPickerView()
/*:
 # View Controllers
* Where most of the code in a non-SwiftUI app goes – it manages the view objects.
* Each View/content hierarchy requires its own view controller,  `UIViewController`
* Used for interfacing with data model and transitions between views
* Xcode provides a capabilitiy called **Storyboards** and **xib files** which allow you to visually create your Views.
* If you use a Storyboard, you connect  to the ViewController via *actions* and *outlets*
    *  An action is a piece of code that is linked to an event that can occur in your app.  `@IBAction func funcName(segue: UIStoryboardSegue)`
    *  An outlet provides a way to reference storyboard interface objects from code. Control-drag from your object to a view controller file and it creates `@IBOutlet weak var textField: UITextField!`
* Let's look at typical code structure in a Playground.
*/
class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .lightGray

        let label = UILabel()
        label.frame = CGRect(x: 50, y: 270, width:200, height: 20)
        label.text = "Duke University"
        label.textColor = .black
        view.addSubview(label)
        
        myButton.frame = CGRect(x: 50, y: 400, width:200, height: 50)
        myButton.backgroundColor = .blue
        myButton.layer.cornerRadius = 10
        myButton.isHidden = false
        myButton.titleLabel?.numberOfLines = 0
        myButton.titleLabel?.textAlignment = .center
        myButton.titleLabel?.lineBreakMode = .byWordWrapping
        myButton.setTitle("Button", for: UIControl.State())
        myButton.titleLabel?.font = UIFont(name: "Times New Roman", size: CGFloat(18))
        myButton.setTitleColor(UIColor.white, for: UIControl.State())
        myButton.setTitleColor(UIColor.red, for: .highlighted)
        myButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        view.addSubview(myButton)
        
        let imageView = UIImageView(image: UIImage(named: "duke.jpg"))
        imageView.frame = CGRect(x: 20, y:50, width:200, height:200)
        view.addSubview(imageView)
        
        self.view = view
    }
    @objc func buttonPressed(){
        print("called")
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
/*:
 ## Tips and Tricks
 There are many times the app will not work exactly as you want / expect but rest assured there are ways to make an app do whatever you want - you just need to figure it out.  I recommend asking the question on Google and most probably it will take you to a stackoverflow answer.  Here is an example of something I got from stackoverflow:
 * "How do I put space in front of the text inside a UITextLabel?"
 */
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
/*:
 # Compile, Link, Run, Debug
 Let's take a  look at the code in this Project.
 * Go to "ViewController.swift".
 * Let's take a look at the code
 * Hit the black triangle icon top left to compile, link and run
 * Add the following two lines at the end of ViewDidLoad():
 var test:Int?
 print(test!)
 * Hit the black triangle again
 * We will now set a breakpoint to show you how to debug
 */
