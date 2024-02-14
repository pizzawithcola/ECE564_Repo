//:# Using Storyboards
//:## First, a review of Views and ViewControllers
/*: ### Views
 * `UIView` is an object that manages the content for a rectangular area on the screen.
    * As needed, it will draw the contents of that rectangle
    * It is a subclass of `UIResponder`.
 */
/*:
  * Callout(Question):
  Why `UIResponder`?
 */
/*:

 * The *View Hierarchy* is the way views are organized. A view can have multiple subviews but only one super view.
    * `UIView.superview` and `.subviews` properties (`.subviews` is an array of objects in back to front order)
    * `isDescendantOfView:` method allows you to check
    * `addSubview` makes one view a subview of another
    * `removeFromSuperview` takes a subview out
 * `UIWindow` is a subclass of `UIView`
    * Provides the basic container for the app's views.
    * iOS usually only has 1 view per window, unless you attach an external screen.
    * Contains `rootViewController` property which points to the initial View Controller to load
### View Properties
 * Views are “painted” in order – superview view first, then the subviews in the order they were defined
 * Views have several properties.  For example:
    * `frame` – position of its rectangle within its superview’s coordinate system (origin top left)
    * `bounds` – the rectangle of a view in its own coordinates
    * `center` – position of the view’s center in the superview’s coordinate system (from center and bounds you can infer frame)
    * `hidden` – true or false
    * `alpha` – 0 to 1 (level of transparency)
 * There are several convenience methods (such as `convertRect:fromView`) that help in calculating points, rectangles, etc.
 * In the Interface Builder, Views are represented as "View" objects which are .xib files.  (See **Example.xib**)
 ### View Controller
 * A view controller is where all the action happens in an iOS program
    * Controls the interaction with the user and the interaction with the data model (**MVC architecture**)
    * `UIViewController` is made to be subclassed, so generally all instances are subclasses of this.
 * A view controller manages a single view and its subviews
    * The `.view` property points to the view it manages.
    * The view’s .`next` property points to the view controller
 * Responsible for view creation/deletion, animation and state management
 * The root view controller manages the top `UIView`
    * `rootViewController` of the `UIWindow`
    * Responsible for rotation of interface and manipulation of status bar
 * All other VCs are subordinate to the root through tree structure, either:
    * Parentage – A VC that contains another VC.  **Container View Controller**
    * Presentation – A VC presents another VC.  **Modal**
 */
/*:
   * Callout(Question):
   Which of these did we use in HW2 and HW3?
*/
/*:
### View Controller Setup
 * Initially, a ViewController has no view.  Postpones that until required, when asked for `.view` property
    * `.view` is a **lazy** variable - *created using a function you specify only when that variable is first requested*
    * Check `.isViewLoaded` to know
 * When loaded, `viewDidLoad` is called.  This is a key time to add code in preparation
    * The .view property now points to the view
    * You can now modify contents of the view, add subviews, etc.
    * The view is NOT yet part of interface, so can’t rely on dimensions, for example
 */
 import UIKit
 import PlaygroundSupport

 class MyViewController : UIViewController {
     override func loadView() {
         let view = UIView()
         view.backgroundColor = .white
         self.view = view
     }
     override func viewDidLoad() {
         let label = UILabel()
         label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
         label.text = "Hello World!"
         label.textColor = .black
         view.addSubview(label)
     }
 }
/*:
### Container View Controllers
 * A container (parent) View Controller manages transitions through a series of “child” view controllers.
 * Container view controllers are a way to combine the content from multiple view controllers into a single user interface.
 * Each type of Container View Controller manages its “children” in a distinct way to create a user interface design
 * Examples of container view controllers include:
    * `UINavigationController`
    * `UITabBarController`
    * `UIPageViewController`
 * A Navigation Controller takes over the top part of the View to display a Navigation Bar.
 * A Tab Bar Controller represents each child as an icon on a Tab Bar
 * A Page View Controller allows you to swipe through each child like a book
 * Tab and Page access their children in an *array*.  Navigation uses a *stack*.
 * Let's look at the Health app that is in the Simulator
 */
/*:
   * Callout(Question):
   What type of Controller is shown at the bottom of the Health app?
*/
/*:
 ### Example Container - Navigation Controller
 * Navigation controllers manage a navigation bar, and a stack of view controllers.
 * Each view controller can customize the appearance of the navigation bar through its navigation item.
 * When view controllers are pushed onto and popped off the stack, the navigation controller updates the navigation bar and view appropriately.
 * By default, the left button in the navigation bar is “Back” – pops the stack.
 * See the *Apple Settings app** for a good examples of a User Interface built on a Navigation Controller
 *  A navigation bar (`UINavigationBar`) is a horizontal bar displaying a center title and a right button.
   * The right button moves forward in the navigation stack.
   * When you navigate into next interface, a back button appears on the left.  Goes to previous stack item – backItem.
 * A stack is maintained of navigation items – `UINavigationItem`
 * The bar almost always used with a navigation controller, `UINavigationController` to form a navigation interface.
 * The buttons you see on the Navigation Bar are `UIBarButtonItem`. There are 3 types:
     * System button – predefined types
     * Basic bar item – image, title
     * Custom bar button item – `init(customView:)`
 * A navigation interface can optionally have a toolbar at bottom.
      * `UIToolbar` set through the VC’s toolbar property.
 * If the Navigation Controller is the top-level controller, it is responsible for rotation behavior.  To handle, another object needs to be the UINavigationControllerDelegate and implement appropriate methods.

*/
/*:
   * Callout(Question):
   In Health.app, use the Browse tab to get to "Activity->Active Energy".  You have just used a Navigation interface.  What bar button do you see on this page?
*/
//: ## Storyboards
//: ### Overview
/*:
* Storyboards are composed of **Scenes**, analogous to the concept of storyboards used in moviemaking
    * Each scene represents a View Controller with a View.
    * Scenes are connected by segues, which we will talk about later.
    * Xcode outline view shows the hierarchy when editing the storyboard
    * Each view is essentially an archived object.  At runtime, the code objects are instantiated and configured with the properties set with the inspectors.
    * You may be able to go `Editor->Arrange` to change the order of subviews on a view
* The Size Class specifies the horizontal and vertical space available in the display (bottom of canvas)
* Auto Layout Icons add constraints to views on the canvas (Align, Pin, Resolve Issues)
*/
//: ### View Controllers on the Storyboard
/*:
* The object library has a set of visual objects that represent different types of  `ViewControllers`
* These visual objects represent the View Controller **but need to be linked to your View Controller class file in the Identity Inspector.**
* You also will need to connect your IB visual objects to your code using `IBAction` and `IBOutlet`
 * An action is a piece of code that is linked to an event that can occur in your app.
    * `@IBAction func funcName(segue: UIStoryboardSegue) {}`
* An outlet provides a way to reference storyboard interface objects from code.
    * `@IBOutlet weak var textField: UITextField!`
* Use Control-Drag to make the connection
*/
//: ### Transitions in ViewControllers
/*:
 * A key element of an iOS app is transitioning between View Controllers – “handing off” control to a new View Controller which then puts up a new View.
 * There are 2 basic ways to transition:
     * present, as in `self.present(pvc, animated:true, completion:nil)`
       * Formerly called a “modal” view, a presented VC is one that an action must be taken before going back to main flow.
       * Used when you want to present a view that is outside of the current “container” view controller and requires the user to take an action and then the VC is dismissed.
     * show, as in `self.show(svc, sender: self)`
           * Tells the ”container” view controller (Nav, Tab, etc) which VC to display next.
           * The container decides how best to present that VC in the context of the current display.
           * If there is no container VC, then behaves as a `present`
 * When you `present` a VC, you can control the *Transition* and the *Presentation*
 * If you use these in a show, they have no effect
 * 4 Transitions  – such as `.flipHorizontal` and `.coverVertical`
 * 5 Presentations  – such as `.popover` (a rectangle over part of the previous View), `.pageSheet` (covers the previous View except a small part at the top) and `.fullScreen` (entireley covers the previous View)
 * Not all options work with all devices!
*/
/*:
   * Callout(Question):
   Which of the Presentation Styles is the default, based on what you saw in your HW2?
*/
//: ### Transitions in a Storyboard - Segues
/*:
 * Use **Segues** to define the flow of your app's interface in a Storyboard.
    * A segue defines a transition between two view controllers in your app's storyboard file.
    * The starting point of a segue is the button, table row, or gesture recognizer that initiates the segue.
    * The end point of a segue is the view controller you want to display.
 * The main four segues are as follows:
    * **Relationship**.  Represents a parent / child relationship of a container view controller
    * **Show**. A show segue pushes new content on top of the current view controller stack if inside a container VC. Adds a back button to the view.
    * **Present**. Presents another controller modally, requiring a user to perform an operation on the presented controller before returning to the main flow of the app. A modal view controller isn’t added to a navigation stack and there are several transitions and presentation modes available.
    * **Unwind**. An unwind segue moves backward through one or more segues to return the user to an existing instance of a view controller. You use unwind segues to implement reverse navigation.
 * Others include “Show detail” (mostly used in iPad apps),  “Popover” (smaller view overlaying view) and Custom (define your own by subclassing UIStoryboardSegue).
*/
//: ### Table View / ViewController on the Storyboard
/*:
 * `UITableView` coordinates with a data source and delegate to display a scrollable list of rows. Each row in a table view is a `UITableViewCell` object.
    * It is a vertically scrolling `UIScrollView` containing a single column of rectangular cells, `UITableViewCell`
    * The cells are selectable and generally navigate the user to another View Controller
    * The rows can be grouped into sections, and the sections can optionally have headers and footers.
    * The user can edit a table by inserting, deleting, and reordering table cells.
 * `UITableViewController` manages a `UITableView`, automatically creating an instance with the correct dimensions and resizing mask
   * Acts as the table view's delegate and data source.
   * Provides toggling of editing modes.
*/
//: ### Table View Cells
/*:
 * Table Views are built on-demand as the user scrolls
    * Requires a data source and a delegate, which are often the same object.
    * Cell objects are reused when needed, via a reuse identifier
 * A position in the table is specified by means of an index path (`NSIndexPath`), the section number and row number
    * Receive a `tableView:cellForRowAtIndexPath` and respond with the right `UITableViewCell`
 * There are 4 built-in cell styles – UITableViewCellStyle
   * `.Default` – text label with an optional image
   * `.Value1` – two text labels side-by-side and optional image
   * `.Value2` – two text labels side-by-side no image
   * `.Subtitle` – two text labels, one above other and optional image
*/

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
