import UIKit
import SwiftUI
/*:
 ## More on SwiftUI Property Wrappers
 Most of this section is from one of the following:
     [gitconnected](https://levelup.gitconnected.com/state-vs-stateobject-vs-observedobject-vs-environmentobject-in-swiftui-81e2913d63f9) or [en.proft.me](https://en.proft.me/2021/05/22/data-flow-swiftui-state-binding-stateobject)
 ### Overview
  * The challenge in making a SwiftUI app is technically all four of `@State`, `@StateObject`, `@ObservedObject` and `@EnvironmentObject` will superficially “work”.
 * Your app will compile, and you may even get the behaviour you are after even when using the wrong property wrapper for the situation.
 * But, if used incorrectly, you may find your view doesn’t update when your data updates or your data persists for longer than you expect it to, or your data doesn't persist at all.
 ### @State
 * "A property wrapper type that can read and write a value managed by SwiftUI"  (Apple)
 * `@State` variables are owned by the view. SwiftUI ensures that this view is updated whenever the value of the state variable changes. Apple encourages you to mark these **private** to emphasize that a `@State` variable is owned and managed by that view specifically. `@State` binding variables are only in memory for the lifetime of the view.
 * Designed for simple value types - `Int`, `Strings`, etc.
 * Really not designed for more complex types, like custom classes or structs.
 * `@State` works by re-computing the `body` variable of your view any time it updates.  So if you have some State in your view that keeps track of an integer, and you add 1, your State will see this and re-render the view.
 * Something like this will not work if you expect the View to update when `num` changes:
 */
class TestObject {
    var num: Int = 0
}
struct StateTestView: View {
    @State var state = TestObject()
    
    var body: some View {
        VStack {
            Text("State: \(state.num)")
            Button("Increase state", action: {
                state.num += 1
                print("State: \(state.num)")
            })
        }
        .onChange(of: state.num) { newState in
            print("State: \(newState)")
        }
    }
}
/*:
 *  Because `TestObject` is a complex, reference type, the value of `state` itself never changes. While a property of `state` , `num` has changed, the `@State` property wrapper has no idea because it is only watching the variable `state`, not any of its properties. To SwiftUI, because it is only watching `state`, it has no idea that `num` has changed, and so never re-renders the view.
 */
/*:
### @Binding
*  The `@Binding` property wrapper is used for properties that are passed by another view. The view that receives the binding is able to read the bound property, respond to changes made by the parent view, and it has write access to the property.  In other words, `@Binding` creates two-way binding between parent's variable and child's variable.
* Use `@Binding` when you need read- and write access to a property that's owned by a parent view and you're wrapping a value type (struct or enum).
*/
      struct AgreementView: View {
        @Binding var isAgreement: Bool

        var body: some View {
            Image(systemName: isAgreement ? "checkmark.square" : "square")
        }
      }

      struct ContractView: View {
        @State private var isAgreement = true
        @State private var firstName = ""

        var body: some View {
            VStack {
                TextField("Enter your name", text: $firstName)
                Text(firstName)
                Toggle(isOn: $isAgreement) {
                Text("Agree to ...")
                }
                AgreementView(isAgreement: $isAgreement)
            }
        }
      }
/*:
 ### @StateObject
  * "A property wrapper type that instantiates an observable object" (Apple)
*/
class TestObject2: ObservableObject {
    @Published var num: Int = 0
}

struct New: View {
  @StateObject private var testObj = TestObject2()

  var body: some View {
      Text("\(testObj.num)")
  }
}
/*:
 * Whenever any of the @Published properties within the Observable Object change, the view will re-render.
 * In other words, whenever `num` is updated, because that property is @Published, it tells any views who are listening to it (observing it) that the value has changed and it should re-compute its views.
 * The other important thing to note with `@StateObject` is the lifecycle of the object is directly tied to the view. If you enter into your view via a NavigationLink, set the num to 3, go back in the NavigationView and then re-enter your view again, that num will be reset to 0. In fact, the whole TestObject will have been created from scratch.
 */
/*:
 ### @ObservedObject
 * "A property wrapper type that subscribes to an observable object and invalidates a view whenever the observable object changes." (Apple)
 * This is almost the same as an @StateObject, except it makes no mention of instantiation, or creation, of your variable. That’s because @ObservedObject is used to keep track of an object that has already been created, probably using @StateObject.
 * `@ObservedObject` is to be used when you want to pass an **Observable Object** from one view to another view. You have already instantiated the Observable Object using `@StateObject` in the parent view, and now you want a child view to have access to the data. But, you don’t want to recreate the object again. This won’t retain any of the data within the object - instead, you want to pass the existing Observable Object down to the child, and this is done through @ObservedObject, through a NavigationLink like this:
 */
       NavigationLink("To child", destination: ChildView(observedObject: stateObject))
/*:
 * And then, the child view accesses the object like this:
 */
      struct ChildView: View {
          @ObservedObject var observedObject: TestObject
     
          var body: some View {
              VStack {
                  Text("ObservedObject: \(observedObject.num)")
                  Button("Increase observedObject", action: {
                      observedObject.num += 1
                      print("ObservedObject \(observedObject.num)")
                  })
              }
          }
      }
/*:
 ### @EnvironmentObject
 * `@EnvironmentObject` is for those scenarios where you need to use an `ObservableObject` but the views aren’t direct parent/child pairs. You may want to use a piece of data on the home view, and also deep within a settings menu, but you don’t want (or need) every view in between to know about that data — that would make for some messy code.
 * There are two parts to using `@EnvironmentObject`:
    * You need to create an object to use. After you create it, you then need to attach it to a view for all child views to have access to it.
*/
     @main
     struct TestApp: App {
         @StateObject var environmentObject = TestObject()
         var body: some Scene {
             WindowGroup {
                 ContentView().environmentObject(environmentObject)
             }
         }
     }
/*:
* To use the object in any view that is within ContentView , you do this:
 */
     @EnvironmentObject var environmentObject: TestObject
/*:
* This is exactly like you would use @ObservedObject, except this time we are expecting it to be in the environment, as opposed to directly passed from the parent.
 * The way `@EnvironmentObject` works is when called within a view, it looks from an object of that type in the environment (in other words, from any parent above it that has specified an environmentObject), and then lets you use it. It does this at run time, as opposed to at compile-time, so if you haven’t set up your environment object properly, *your app will crash when it goes to use it.*
 * The other point to note is `@EnvironmentObject` looks for an object of that type. This means you can’t define more than one environment object in the same view tree with the same type.
 
 ### Using both @ObservedObject and @EnvironmentObject
 */
    @main
     struct Mail: App {
         @StateObject private var model = MailModel()
         var body: some Scene {
             WindowGroup {
                 MailViewer()
                 .environmentObject(model) // Passed through the environment.
             }
             Settings {
                 SettingsView(model: model) // Passed as an observed object.
             }
      }
     }

/*:
 ### @Environment
 * SwiftUI exposes a collection of values to your app’s views in an `EnvironmentValues` structure. To read a value from the structure, declare a property using the *Environment* property wrapper and specify the value’s key path. For example, you can read the current locale:
 
          @Environment(\.locale) var locale: Locale
 
*  Use the property you declare to dynamically control a view’s layout. SwiftUI automatically sets or updates many environment values, like `pixelLength`, `scenePhase`, or `locale`, based on device characteristics, system state, or user settings. For others, like `lineLimit`, SwiftUI provides a reasonable default value. You can set or override some values using the environment(_:_:) view modifier:
 
         MyView()
             .environment(\.lineLimit, 2)
 
 
 
 ## The Library of Views and Modifiers
 * When editing a SwiftUI file in Xcode, the Library is a good source of information
 * The first two tabs cover all the View objects and the Modifiers
 * Here is an overview taxonomy of both:
 ![Library](Library.jpg)
 */
