import SwiftUI

//: # SwiftUI Overview
/*:
 With SwiftUI, Apple is attempting to solve several issues:
 * Have a unified UI Framework across all their platforms that uses a declarative syntax
 * Simplify the programming model, offering a path to migrate from MVC to MVVM pattern
 * MVC
     * Common application design pattern since the 1980s
     * The Controller acts as a go-between for the View and the Model
     * Can lead to a lot of boilerplate code for connecting to View components
     * A lot of logic gets put into the VC, making it bloated and complex
 * MVVM
     * Motivation is to take coding out of the View so that a Designer could create it
     * Clearer dependency model between components and clearer data flow
     * Popular now in JavaScript frameworks
     * Key to this is the “Binding” – a two-way connection the View and the Model that allow each to update a designated value.
     * Disadvantage is that it can be “overkill” for many simple apps, adds complexity

 ![MVC vs MVVM](SUI1.jpg)
 * Components of MVVM
     * Model
         * The data that the application is dealing with
         * Holds the information, but not behaviors or services that manipulate the information (like the font used to display it, etc)
     * View
         * Responsible for the presentation of the data and can manipulate the data to make it more presentable (add fonts, convert time/date formats, etc.)
         * The view manages input (key presses, etc.) which ultimately manipulates properties of the model
         * In MVVM, the view is active. As opposed to a passive view which has no knowledge of the model and is completely manipulated by a controller/presenter
         * The view in MVVM contains behaviors, events, and data-bindings that ultimately require knowledge of the underlying model and viewmodel.
     * ViewModel (also known as the “Binder” in some frameworks)
         * An abstraction of the view exposing public properties and commands.
         * Instead of the controller of the MVC pattern, MVVM has a binder, which automates communication between the view and its bound properties in the view model.  The binder, in SwiftUI, is provided by `@Binding`, `@State` and similar property wrappers.
         * Since the View is active in MVVM, the ViewModel does not require a reference to the View, just bindings to the properties needing update, etc.

 * Apps today do not need to be follow this new vision right away.  It is possible to introduce some Swift UI concepts gradually as the platform stabilizes.
 * SwiftUI works well with UIKit. Apple has defined tools and patterns so that both framework can work together.
## Declaritive Syntax (as stated on Apple's website)
 SwiftUI uses a declarative syntax so you can simply state what your user interface should do.
* For example, you can write that you want a list of items consisting of text fields, then describe alignment, font, and color for each field.
 * Your code is simpler and easier to read than ever before, saving you time and maintenance.
 
 This declarative style even applies to complex concepts like animation.
 * Easily add animation to almost any control and choose a collection of ready-to-use effects with only a few lines of code.
 * At runtime, the system handles all the steps needed to create a smooth movement, and even deals with interruption to keep your app stable.
 */
//: ![Picture of Xcode IDE](SUI2.jpg)

/*:
 ## The User Interface Framework
 * A declarative approach to design UI
 * Replaces the Interface Builder, and artifacts required in the layout (like Constraints)
 * Uses containers (like “VStack”) to define logical relationships between subviews.
 * Introduces the live Canvas - allows for a live updated view of the UI code
 * Changes made to the Canvas also update the code automatically.

 * See *View->ContentView* in this repo for a complete app.  We will come back to this app later.
 */
/*:
 ## Getting Started with SwiftUI
 * First, lets take a look at this very helpful [website](https://goshdarnswiftui.com/)
 * There is an online Apple tutorial - [here](https://developer.apple.com/tutorials/swiftui/)
 * To really grasp SwiftUI, plese do some / all of the tutorial.
    * *Chapter 1 - SwiftUI Essentials* section would be 1 - 2 hours.  You should at least do this before doing any of the SwiftUI Homework Assignments.
    * The entire tutorial is probably closer to 5 hours.
 * There are also numerous other tutorials, examples on the various iOS tech sites, like [raywenderlich.com](https://www.raywenderlich.com/)
 * To get started, File->New->Project->App and select “SwiftUI” as the interface.  This uses a template that departs from the old way of handling UIWindow, etc. in AppDelegate and SceneDelegate.
 * You can be in "Live" mode, meaning it will stay “live” as you code and you can instantly see the results, or you can be in "Selectable" mode, which allows you to edit.
 * You can also test *Variants* and *Device Settings*
 * Objects are structs and so they don’t subclass, they rely on protocols to define them.
 * An **app** follows the “App” protocol and contains a “body” property which follows the “Scene” protocol
 * A **view** follows the “View” protocol and contains a “body” property which follows the “View” protocol
 * Objects are “command-click”-able, allowing you to get a context pop-up.
 * Use of things like .properties / .methods and the Assets.xcassets folder make much of the app development similar to what you are used to.
 * You will notice there is a “SwiftUI View” template when you add files to the project.  Use this to create your Views.
 * Import of other Frameworks is the same.
 ## @State
 * You use the **@State** *property wrapper* to designate properties of the view you wish to alter.
 * @State takes the place of much of the code formerly done in a View Controller
     - **Example:** *A user slides a UISwitch on the screen*\
     **In UIKIT:** \
     triggers a "Value Changed" event \
     add code in ViewController to handle "value changed" \
     update properties as needed \
     reload screen if needed \
     **With @State and SwiftUI:** \
     add an @State property for the Toggle isOn Property 
 * SwiftUI uses the @State property wrapper to allow us to modify values inside a struct, which would normally not be allowed because structs are value types.
 * When we put @State before a property, we effectively move its storage out from our struct and into shared storage managed by SwiftUI
 * @State should be used with simple struct types such as `String`, `Int`, and arrays.
 * If you are not sharing the @State property with other views, it is good practice to make it `private`
 * To share an @State property across Views, the other Views can use @Binding.
 * **@State** properties are then managed by SwiftUI, and when they change the View is automatically refreshed.
 * Using a $ in front creates a  **binding** between the property and where it is used.  For example, `TextField` requires a binding as the value for the `text` parameter.
 ## @Binding
 * You use the **@Binding** property wrapper to give another View access to a @State property.
 * Think of it like a pointer in C.  You are not passing the value, you are passing a reference to that value so it can be read to / written to by another View.
 * Remember, @Binding is a property wrapper so just a set of code that manages the access to the @State property.  
 * The following is from /medium.com/@nikhil.vinod/
*/
struct HornButton: View  {
  @Binding var hornPlayedCount: Int

  var body: some View {
      Button("\(hornPlayedCount) times") {
      hornPlayedCount += 1
      }
  }
}

struct CarView: View  {
  @State private var hornCount: Int = 0

  var body: some View {
      Text("Your car has honked: ")
      HornButton(hornPlayedCount: $hornCount)
  }
}
/*:
 ## Combine Framework Object
 * ObservableObject (see ModelData.swift)
     * “A type of object with a publisher that emits before the object has changed.”
     * Introduced with the `Combine` framework in iOS
     * Similar to @State, but for external objects not private properties.
     * The @Published attribute allows changes to the data to be sent to subscribers of that data.
     * The @StateObject attribute is then used in your app to initialize the model object
 ## SwiftUI Objects
 * @StateObject (see Using_SwiftUIApp.swift)
     * A property wrapper that instantiates an observable object
     * Create a state object in a ``SwiftUI/View``, ``SwiftUI/App``, or ``SwiftUI/Scene`` by applying the `@StateObject` attribute to a property
    * SwiftUI creates a new instance of the object only once for each instance of the structure that declares the object. When published properties of the observable object change, SwiftUI updates the parts of any view that depend on those properties
 * @ObservedObject
     * "Whichever view is the first to create your object must use @StateObject, to tell SwiftUI it is the owner of the data and is responsible for keeping it alive. All other views must use @ObservedObject, to tell SwiftUI they want to watch the object for changes but don’t own it directly.”
     * In other words, if you are creating the instance of the `ObservableObject` in your View, use @StateObject.  If you are passed an `ObserveableObject`, you would use @ObservedObject or @EnvironmentObject.
 * @EnvironmentObject (see Using_SwiftUIApp and ContentView)
     * A property wrapper type or **View** method that supplies an `ObservableObject` to a View subhierarchy.
     * An environment object invalidates the current view whenever the observable object changes
     * If you declare a property as an environment object, be sure to set a corresponding model object on an ancestor view by calling its `View/environmentObject(_:)` modifier.
     * The object can be read by any child by using `@EnvironmentObject`.
 */
