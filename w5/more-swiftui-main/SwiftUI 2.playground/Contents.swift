
/*:
 ## Some highlights of the Apple Tutorial
 ### DataModel
 * What is the ObservableObject?
 * The .load method has some interesting aspects
    * Generic
    * Bundle
 ### LandmarksApp.swift
 * What is the StateObject?
 * Where is the EnvironmentObject defined and how passed?
 ### Tab View
 * Setting up a Tab View is very similar to a Storyboard
 * TabView is the struct used to set up the tab bar at the bottom.
 * The initialization of the TabView contains the Views that will be managed from the Tab Bar.
 * Each View in the TabView has a “.tabItem” property which describes what appears in the Tab Bar - Text and/or Image (ContentView.swift)
### List View
 * Making a table view is as easy as using a “List” view object, passing it the array of data. Lists work with *identifiable* data. You can make your data *identifiable* in one of two ways:
    * by passing along with your data a key path to a property that uniquely identifies each element
    * by making your data type conform to the `Identifiable` protocol. (see Landmark.swift)
         * "Use the `Identifiable` protocol to provide a stable notion of identity to a class or value type. For example, you could define a `User` type with an `id` property that is stable across your app and your app's database storage.  You could use the `id` property to identify a particular user even if other data fields change, such as the user's name." (from: Apple Docs)
 * As opposed to having the concept of “Sections” of a Table View, it seems the preferred approach is to imbed Lists in Lists, or in the case of the SwiftUI Tutorial, to have Scrollable Stacks inside of a List. ( See Landmark.swift contains the data model for the “sections” of  list items (Categories))
 * Computed Variables are also a technique for defining items in a List (See line 15 of LandmarkList.swift)
 * `ForEach` is a way to set up each item in the Array (See line 27 of LandmarkList.swift)
 ### Navigation View
 * Embedding in a NavigationView is like that in code / storyboard.  I noticed the default Title type is the “Large” option, which you can use in code as well.  (see CategoryHome.swift)
 * *Navigation Link* is the structure which acts as a segue in SwiftUI
 * Contains a “destination” parameter which is the View to show next
 * Essentially does a “show” – pushes onto the Navigation stack, Back button appears. (See Line 28 of LandmarkList or Line 24 of CategoryRow.swift)
 * For arbitrary View Controllers (for example, existing UIKit View Controller), there is a protocol to follow, `UIViewControllerRepresentable`
 * Requires “make” and “update” methods to interface with SwiftUI
 * Also allows for a “Coordinator” object to handle delegate messages.
 * See a simple example at [this site](https://medium.com/@Johannes_Nevels/presenting-uiviewcontrollers-in-swiftui-22388616a24c)
 ## Other Views
 * There are number of view objects to explore, for example “Toggle”. (see LandmarkList.swift)
 * Check out the Xcode Library ('+') for more examples
 */

