import UIKit
import PlaygroundSupport
import SQLite

/*:
# Overview
* NOTE:  With each weeks repository, there will generally be new concepts introduced other than those related to the topic at hand.  Here are a few to highlight for this weeks repository:
    1. The use of an external **package** file.  This is a great way to add function to your homework / project / etc.  If you go to File->Add Packages you will see some.  Others (like SQLite in this repo) can be reached via URL (https://github.com/stephencelis/SQLite.swift)
    1. The use of a **Storyboard** and **.xib** files.  We will use them in HW2 and HW3.  Let me review quickly.
    1. The use of **Constraints** in the .xib files.  This is another way to do layout of your subviews.  The need for constraints goes away with SwiftUI.
    1. The use of Swift **error handling** (do / try / catch), as in the database section.
    1. The use of **SF Symbols**, as in DatabaseVC.xib (see https://developer.apple.com/sf-symbols/ for more info)
* There are multiple ways to store data from an app
     * Read / Write to a File in the Sandbox
     * SQLite
     * Core Data
     * iCloud
     * External options (Box, Dropbox, etc)
* If data is not required to be shared, just use local storage (sandbox) that is associated with the app (via Read/Write, SQLite, Core Data).
* If you want to share a document, use iCloud, Box, Dropbox, etc.
* If you just need to save user info, you can use the *UserDefaults* object to save all user info between sessions
*/
/*:
# The Sandbox
**See the `SimpleSave` folder in this repo**
* **Sandbox** is the name for the area of storage where an app can store its files.
    * Why do you think they call it a Sandbox?
    * Why can't you just store files anywhere?
* Standard Directories in the Sandbox
     * Documents – set up primarily for doc sharing and backup, so good location for files that you create and want to keep. Backed up / Saved with app.
     * Library - contains Caches sub-directory and Preferences sub-directory
        * Caches – information that you want to persist from session to session but don’t need backing up.
        * Preferences – for Settings info, used by NSUserDefaults.  Backed up / Saved with app.
     * tmp – primarily for temp files, staging, etc
* Folders and Files can be created in any of these directories
* FileManager and URL objects are used to point to folders *(see sample code below)*
* String, Data, Array and Dictionary provide their own methods for writing/reading
* Other objects can create own saved versions by using NSCoder or JSONEncoder serialization.
*/
// Source: hackingwithswift.com
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}
let myFileURL = getDocumentsDirectory().appendingPathComponent("myFile.txt")
/*:
# Document Architecture
 **See the `SimpleNotePad` folder in this repo**
* The UIDocument class provides a standardized object for 3 key common document functions:
     1. Background reading and writing
     1. Autosave
     1. Interfacing with iCloud
* Create an instance of **UIDocument** to represent your document.
     * Use `open` and `save` methods to interact with the document
     * These methods will call the methods below, which you override
* Two key methods to override in order to use:
    * `contents(forType: )` is called when it is time to save a document to disk.
    * `load(fromContents:, ofType:)` is used to load the document from disk
    * Need to convert into/out of Data instance
*/
class MyNotes: UIDocument {
    var userText: String? = "Text From myNotes"
    
    // Called when the file is SAVED, allows for content to be set
    // 'typeName' is set by the system, for example "plain text" is a typeName
    
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
/*:
# SQLite
**See the `Database` folder in this repo**
* SQLite is a public domain embedded SQL database engine that has been ported and included in iOS. See [www.sqlite.org](https://www.sqlite.org)
* Used in numerous built-in Apple apps, such as Mail, Safari and iTunes
* Need to link to libsqlite3.dylib, or for a more user-friendly approach, use 3rd party tool like [SQLite.swift](https://github.com/stephencelis/SQLite.swift)
* Also accessible through command line, `sqlite3.`
* Perfect for row/column type data that needs to be rapidly searched.  Some advantages:
     * Easy to pull out just a subset of the data to save on memory usage
     * Easier to use / learn than Core Data but a good “steppingstone”
* Ideally you should have a working knowledge of SQL already or else the learning curve can be quite steep.
*/
let sqliteFileName = "dukeperson.sqlite"
let filemgr = FileManager.default
let fileURL = getDocumentsDirectory().appendingPathComponent(sqliteFileName)
if !filemgr.fileExists(atPath: fileURL.path) {
    do {
        let databaseURL = try filemgr.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(sqliteFileName)
        let db = try Connection(databaseURL.path)
        let classroom = Table("CLASSROOM")
        let id = Expression<Int64>("ID")
        let name = Expression<String>("NAME")
        let fromLoc = Expression<String>("FROMLOC")
        let degree = Expression<String>("DEGREE")
        
        try db.run(classroom.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(fromLoc)
            t.column(degree)
        })
    } catch {
        print(error.localizedDescription)
    }
}
/*:
# Using JSON
Until recently, the preferred way to save arbitrary objects instances (the state of the instance properties) was to file is using **JSON.**  Prior to having [**JSONEncoder**](https://developer.apple.com/documentation/foundation/jsonencoder) encoding built into iOS, you used something called [**NSKeyedArchiver**](https://developer.apple.com/documentation/foundation/nsakeyedrchiver), which I taught for many years in this class.
 
 ### From JSON.org:
 
 *JSON (JavaScript Object Notation) is a lightweight data-interchange format. It is easy for humans to read and write. It is easy for machines to parse and generate.  JSON is a text format that is completely language independent but uses conventions that are familiar to programmers of the C-family of languages, including C, C++, C#, Java, JavaScript, Perl, Python, and many others. These properties make JSON an ideal data-interchange language.*
 
 ### JSON is built on two structures:
 * A collection of name/value pairs. In various languages, this is realized as an object, record, struct, dictionary, hash table, keyed list, or associative array.
 * An ordered list of values. In most languages, this is realized as an array, vector, list, or sequence.
 ### JSON Usage
 * The value of JSON is for **interchange**.  That is, you can save some information, send it to another program or another person, and they know how to parse it.
 * For true interchange, you need an agreed to grammar - both parties agree to the *semantics* of each element.
 * Quite often, the JSON grammar is NOT the same as what you use internally, so you have to create code to map from one to the other without loss of data.
 * Even if you don't support an element in the JSON, you should be able to handle it without error.
 */
/*:
### JSON Example:

`{"languages": ["Swift", "C", "C++"], "role": "Professor", "DUID": 0664541, "gender": "male", "wherefrom": "Chatham County, NC", "firstname": "Ric", "lastname": "Telford","email": "ric.telford@duke.edu"}`

## The Codable Protocol
* In Swift 4, Apple introduced 3 new protocols – `Encodable`, `Decodable` and `Codable`.
* The `Codable` Protocol is essentially just the combination of the other two and all we will use here.
* An object type that can convert itself into and out of some external representation, such as JSON.
* If your object type (class, struct, enum) only contains properties that are already Codable (String, Int, Double, URL, Data, Bool), then making the object type Codable is simple.
* Then, various encoders and decoders can be written to convert your object.  JSONEncoder and JSONDecoder are examples of this.
* There are ways to further tailor your encoding, but I will leave that for you to explore.  A good place to look is on this [Apple Developer webpage](https://developer.apple.com/documentation/foundation/archives_and_serialization/using_json_with_custom_types).  It also has a Playground you can download.

*/
/*:
## Sample App for Saving and Retrieving JSON
* As you saw last week, the code below is what iOS view objects look like when created in code.
*/
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
   override func loadView() {
       let view = UIView()
       view.backgroundColor = .yellow
       let myLabel = UILabel()
       let myTextField = UITextField()
       let myButton = UIButton()
       let mySegmented = UISegmentedControl()
       let mySwitch = UISwitch()
       let myStepper = UIStepper()
       let mySlider = UISlider()
       let myPicker = UIPickerView()
       myLabel.frame = CGRect(x: 50, y: 270, width:200, height: 20)
       myLabel.text = "Duke University"
       myLabel.textColor = .black
       view.addSubview(myLabel)
       
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
/*:
* There is also a built-in tool in Xcode that allows for visual creation of View objects.  It is called the **Interface builder**.
* As you can see, the default *Storyboard* template has a `ViewController` file and a `main` file.
* `ViewController` is where you put the code that bridges between the **Model** and the **View**
* You should have global functions, data structures, data model/db code, etc *in files other than* `ViewController`.  Try to avoid making huge `ViewController` files by only keeping code in there that needs to be a property or method of `ViewController` object.
* `main` is actually a Storyboard, but has a View object ready to go (right now a blank canvas)
* In the Interface Builder, you can drag/drop View objects onto the canvas and then link them to your View Controller.
### ToDoItem View and ViewController
* The sample app here is a one-page app that allows you to create and list todos.  The text field, buttons and text view objects were dragged and dropped onto the canvas.
* Once you have view objects, you can create linkages to them called **@IBActions** and **@IBOutlets**.
    * `@IBAction` An action is a piece of code that is linked to an event that can occur in your app.  `@IBAction func funcName(segue: UIStoryboardSegue)`
   * `@IBOutlet` An outlet provides a way to reference storyboard interface objects from code. `@IBOutlet weak var textField: UITextField!`
   * Control-drag from your object to a view controller file and it creates this stub code to link between a View and a ViewController
* With actions and objects, you add the code to a ViewController to interface with the View objects and with the data model.
*/

 //Present the view controller in the Live View window
 PlaygroundPage.current.liveView = MyViewController()

