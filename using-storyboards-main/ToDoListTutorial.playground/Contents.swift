  
import UIKit
/*:
# ToDo List app Tutorial
   This tutorial is a step-by-step approach to creating a complete app - a ToDo List.  Read each step carefully and make sure you understand as you go.
## Phase 1 - Basic UI Layout
* 1 - Open Xcode and start a new project using *FIle->New->Project*
* 2 - Select the **Single View App** template
* 3 - Make the Product Name `ToDoList` and make sure the Language is **Swift** and the User Interface is **Storyboard**.
* 4 - Go to the *main.storyboard* file and then open the Library (**+** icon)
* 5 - Search for `TableViewController` and drag one onto the canvas.  Ideally, place it to the left of the existing `ViewController` and move the *Entry Point Segue* (-------------->) to it.
* 6 - We will want our app to have a Navigation Bar, so select/highlight the `TableViewController`then click on *Editor->Embed In->Navigation Controller*
* 7 - Add a title to the navigation bar by selecting it then going to the Attributes inspector and adding a Title of  `To Do List`
* 8 - We want a way to add new items to our ToDo List, so in the Library, search for “bar button”, drag a bar button item to the right side of the navigation bar in your `TableViewController`. Select the bar button and change its type from “Custom” to “Add” in the Attributes Inspector. This will change the button’s icon to “+”
* 9 - Since there is already another `ViewController` in the storyboard, let's use it. Click on `ToDo List's` `Add`(`+`) icon, hold down the `control` key and then click-drag a line to the other `View Controller`. From the pop-up menu, you select `Present Modally`.  This creates a Segue that allows the other `View Controller to be launched when the `Add` button is pressed.
* 10  - Since this `View Controller` is a new modality, it will need its own `Navigation Controller`, so embed this View Controller in a Navigation Controller as well.
* 11 - Give this View Controller a Title as well.  We will call it `New Item`
* 12 - Just like before, we want bar button items here as well - put a `Cancel` bar button on the left and a `Save` bar button on the right.
* 13 - The `New Item` View Controller needs a subview.  Drag in a Text Field from the Library and give it `Placeholder` text of `Item Information`
* 14 -  Hit the Run icon and see what happens.
   ## Phase 2 - Adding Code
* 15 - We now need some code files to link to our storyboard.  Using *File->New->File*, we will add 2 files to our project. Choose `Cocoa Touch Class` as the Source. The first one you need to create is `ToDoListTableViewController` and make it a subclass of `UITableViewController`.  The second file is `NewItemViewController` and is a subclass of `UIViewController`
* 16 - **Key Step!**  Go back to your main.storyboard and, for each of the two View Controllers, update the Class field on the Identity Inspector to match the respective files you just added for each.
* 17 - Go back to the `ToDoListTableViewContoller` file you just created.  Go to the bottom (above the final close brace `}`) and cut/paste the following line of code.  This will create a stub for our return from `NewItem` to go:
   */
  @IBAction func returnFromNewItem(segue: UIStoryboardSegue) {}
/*:
* 18 - Go back to the `main.storyboard` and `control-drag` lines from the `Cancel` and `Save`to the `Exit` icon (orange box) at the top of the `NewItemViewController`.  You will notice when you release that the popup menu has the name of the `@IBAction func` you just created.  Select it.  This tells the app that when `Cancel` or `Save` are pressed to call that function.
* 19 - Time to add another file, `File->New->File` but this time create `ToDoItem` class as a subclass of `NSObject`. This is our Data Model. Insert the following code:
*/
  class ToDoItem: NSObject {
      var itemName: String = ""
      var completed: Bool = false
      var creationDate = NSDate()
  }
/*:
* 20 - We will need an Array to store all our ToDos, so add a property to the `ToDoListTableViewController` as follows:
*/
var toDoItems = [ToDoItem]()
/*:
* 21 - Create this method in the ToDoListTableViewController to populate array and then call from `viewDidLoad()`:
*/
  func loadInitialData() {
          let item1 = ToDoItem()
          item1.itemName = "Buy milk"
          self.toDoItems.append(item1)
          let item2 = ToDoItem()
          item2.itemName = "Buy eggs"
          self.toDoItems.append(item2)
  }
/*:
   * 22 - I will explain later more about how `UITableViewControllers` work, but it is critical to tell the system how many sections your table has and how many items the table could have.  So, update the `return` statements of the `tableView` functions in `ToDoListTableViewController` - `numberofSections (return 1)` and `numberofRowsInSection (return self.toDoItems.count)`
   * 23 - Go back to `main.storyboard`, select the `Table View Cell` (under the words "Prototype Cells"), go to Attributes Inspector, and make the `Identifier` property to be `ToDoListProtoCell` and change `Selection` to `None`
   * 24 - We need to add some logic now to our Table View Controller.  Paste in the following and I will explain it later:
   */
  override func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListProtoCell", for: indexPath)
          let tempToDoItem:ToDoItem = self.toDoItems[indexPath.row]
          cell.textLabel?.text = tempToDoItem.itemName
          if (tempToDoItem.completed) {
              cell.accessoryType = UITableViewCellAccessoryType.checkmark
          }
          else {
              cell.accessoryType = UITableViewCellAccessoryType.none
          }
          return cell
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: false)
          let tappedItem:ToDoItem = self.toDoItems[indexPath.row]
          tappedItem.completed = !tappedItem.completed
          tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
  }
/*:
   * 25 - Open a second editor so you have two editors side by side. Put the `NewItemViewController` code on the left, and `main.storyboard` on the right(or vice versa). Hold Control and click/drag from the Text Field and Save Button to inside `NewItemViewController` class to create 2 `@IBOutlets` called `textField` and `saveButton`

   **Caution:** remember to change the connection to *Outlet* in the pop-up window, as the default connection type is *Action*
   * 26 - Create a new property in `NewItemViewController` below the `@IBOutlets`:
*/
var toDoItem = ToDoItem()
/*:
   * 27 - Un-comment the `prepare` function code in `NewItemViewController` and add the following code inside:
   */
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if ((sender as! UIBarButtonItem) != self.saveButton) {
           return
       }
       if ((self.textField.text) != nil) {
           self.toDoItem.itemName = self.textField.text!
           self.toDoItem.completed = false
       }
   }
/*:
   * 28 - Write the `returnFromNewItem` code in `ToDoListTableViewController` to store and display the new item:
   */
  @IBAction func returnFromNewItem(segue: UIStoryboardSegue) {
    let source:NewItemViewController = segue.source as! NewItemViewController
    let item:ToDoItem = source.toDoItem
    if (item.itemName != "") {
        self.toDoItems.append(item)
    }
    self.tableView.reloadData()
  }
/*:
   * 29 - Run it!
   */
