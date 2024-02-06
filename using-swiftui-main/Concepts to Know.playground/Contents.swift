import UIKit
/*:
 ## Property Wrappers
 * **Property Wrappers** were introduced in Swift 5.1
 * They allow code to be added to a property whenever it is stored or retrieved.
 * From the Swift Language Guide - "A property wrapper adds a layer of separation between code that manages how a property is stored and the code that defines a property. For example, if you have properties that provide thread-safety checks or store their underlying data in a database, you have to write that code on every property."
 * See the sample code below from toptal.com:
 */
class DukePerson {
    @propertyWrapper
    struct Email<Value: StringProtocol> {
        var emailProp: Value?
        init(wrappedValue emailProp: Value?) {
            self.emailProp = emailProp
        }
        var wrappedValue: Value? {
            get {
                return validate(email: emailProp) ? emailProp : nil
            }
            set {
                emailProp = newValue
            }
        }
        
        private func validate(email: Value?) -> Bool {
            guard let email = email else { return false }
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: email)
        }
    }
    
    @Email var email: String?
}
var person = DukePerson()
person.email = "rt113@duke.edu"
print(person.email!)
person.email = "joe"
print(person.email as Any)

/*:
 Note also how this code gives a good example of how to use *Regular Expressions* in Swift/iOS
 */
//:  Here is another example from swiftbysundell.com:
@propertyWrapper struct Capitalized {
    var wrappedValue: String {
        didSet { wrappedValue = wrappedValue.capitalized }
    }
    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue.capitalized
    }
}

struct DukePerson2 {
    @Capitalized var fName: String
    @Capitalized var lName: String
}

var person2 = DukePerson2(fName: "rIc", lName: "telFord")
person2.fName = "riChard"
print(" \(person2.fName) \(person2.lName)")
//: **Question** - what if we didn't provide an initializer - would it still work?

/*:
 ## Combine Framework
 * The **Combine Framework** is also new in Swift 5.
 * From the Apple documentation:
 
 "The Combine framework provides a declarative Swift API for processing values over time. These values can represent many kinds of asynchronous events. Combine declares publishers to expose values that can change over time, and subscribers to receive those values from the publishers.

The Publisher protocol declares a type that can deliver a sequence of values over time. Publishers have operators to act on the values received from upstream publishers and republish them.

At the end of a chain of publishers, a Subscriber acts on elements as it receives them. Publishers only emit values when explicitly requested to do so by subscribers. This puts your subscriber code in control of how fast it receives events from the publishers it’s connected to.

 Several Foundation types expose their functionality through publishers, including Timer, NotificationCenter, and URLSession. Combine also provides a built-in publisher for any property that’s compliant with Key-Value Observing.

 You can combine the output of multiple publishers and coordinate their interaction. For example, you can subscribe to updates from a text field’s publisher, and use the text to perform URL requests. You can then use another publisher to process the responses and use them to update your app.

 By adopting Combine, you’ll make your code easier to read and maintain, by centralizing your event-processing code and eliminating troublesome techniques like nested closures and convention-based callbacks."
 
 * Combine introduced the protocol **ObservableObject** to provide a default implementation of `objectWillChange` for any properties that are `@Published`
 */
