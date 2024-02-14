//: [Previous](@previous)
import UIKit
//:# Initializers
//:* *Initialization* is the process of preparing an instance of a class, structure, or enumeration for use. This process involves **setting an initial value for each stored property on that instance** and performing any other setup or initialization that is required before the new instance is ready for use.
//:* You implement this initialization process by defining
//:*initializers*
//:, which are like special methods that can be called to create a new instance of a particular type. Unlike Objective-C initializers, Swift initializers do not return a value. Their primary role is to ensure that new instances of a type are correctly initialized before they are used for the first time.
//:* Instances of
//:**class**
//: types can also implement a
//:*deinitializer*
//:, which performs any custom cleanup just before an instance of that class is deallocated.
//: ### Working with initializers
//: Probably the easiest place to start is to look at the object type "Int".
//: It is a 64 bit signed integer, as you can see when you use the .min and .max functions.
Int.min
Int.max
//: The most common way to initialize is just to assign a value to a constant or variable.  In this case, the initializer is done for you "under the covers."
let num : Int = 5
//: As mentioned above, the default initializer is just a set of parentheses.  Notice this sets the value to zero.
let val = Int()
//: You can always call the Int initializer with an Int value, but this seems somewhat unnecessary since it can be done under the covers.  But, it shows that one of the initializers for Int is to pass a parameter that is an Int.
let digit = Int(5)
//: A better example is the ability to pass a string as the parameter of an initializer.  This initializer returns an Optional(Int) as it could fail, as you can see in the print statements below.
let value = Int("5")
print(value ?? "It failed")
let failedInt = Int("Hi")
print(failedInt ?? "It failed")
//: There is an initializer that takes a Float as the parm.
let ordinal = Int(5.423234)
//: And there are a few others as well, including one that takes a string and then a radix parm.  This returns an Optional as well.
let base10 = Int("5", radix: 10)
print(base10 ?? "It failed")
let base2 = Int("10100", radix: 2)
print(base2 ?? "It failed")
//: OK, so that is a simple example of initializers and hopefully you get the idea that any object type can have any number of initializers.  When you use an iOS class for example, you should always study what the syntax is for the various initializers so you know how to create an instance of that class.  Here is just one example.  There are a few ways to initialize the NSDate objects.  The default one of course, and then there is an example where you can pass it a Double (which is an NSTimeInterval in seconds) and a sinceDate and it creates an NSDate instance of that date/time.  You can always Command-click or Option-click on the name of the object type to see the header info or class reference, respectively.
let dateParm = NSDate()
let date = NSDate(timeInterval: 113343.33498, since: dateParm as Date)
//: Now let's put this to the test by creating our own object.  We will create a Class called "Pet" and a subclass of "Horse"
class Pet {
    var legs : Int = 4
    var name : String = "none"
    
    init() {}
    
    init(legs: Int, name: String)
    {
        self.legs = legs
        self.name = name
    }
}

class Horse : Pet {
    var breed : String = ""
    init(name: String, breed: String) {
        self.breed = breed
        super.init(legs: 4, name: name)
    }
}

let Minnie = Pet()
print("The cat's name is: \(Minnie.name)")

let Rose = Horse(name: "Rose", breed: "Quarterhorse")
print("The horse's name is \(Rose.name)")

//:# Protocols
//: * A protocol defines a “blueprint” of methods, properties and other requirements that suit a particular task or piece of functionality.
//: * The protocol is then adapted by an object to provide an implementation of the protocol.
//: * The compiler enforces the blueprint – if you declare you follow a protocol, you need to implement all of it.
//: * One of the pre-defined Protocols in Swift is `CustomStringConvertible`.  This is used to present a *textual representation of this instance.*  That is, no matter what the object type is, you can represent it as a String.  The actual definition of the protocol looks like this:
/*:
    public protocol CustomStringConvertible {
        var description: String { get }
    }
*/
//: * Some examples:
struct Point: CustomStringConvertible {
            let x: Int, y: Int
            var description: String {
                return "The point is (\(x), \(y))"
            }
}

let p = Point(x: 21, y: 30)
let s = String(describing: p)
print(s)

class Pets: CustomStringConvertible {
    var name: String
    var description : String {
        return "This is \(self.name)."
    }
    init(name: String) {
        self.name = name
    }
}

class Dog: Pets {
    var type = "Dog"
    var breed = "Pug"
    override var description : String {
        return "This is \(self.name).  He is a \(self.type)"
    }
}

let myDog = Dog(name: "Brier")
print(myDog.description)
print(myDog)

public protocol MySelf {
    var iAm: String { get }
}

class Cat: Pets, MySelf {
    var type = "Cat"
    override var description : String {
        return "This is \(self.name).  He is a \(self.type)"
    }
    var iAm: String {
        return "I am a \(self.type)"
    }
}

let myCat = Cat(name: "Kenny")
myCat.iAm

/*:
 # More on Optionals
 Optionals say either “there is a value, and it equals x” or “there isn’t a value at all”. Using optionals is similar to using nil with pointers in Objective-C, but they work for any type, not just classes. Not only are optionals safer and more expressive than nil pointers in Objective-C, they are at the heart of many of Swift’s most powerful features.” *Excerpt From: Apple Inc. “The Swift Programming Language (Swift 3 Beta).” iBooks.*
 */
var addrLineOne: String     // uninitialized var of type "String"
// print(addrLineOne)

var addrLineTwo: String?    // uninitialized var of type "Optional"
print(addrLineTwo as Any)
addrLineTwo = "Joy"
print(addrLineTwo as Any)
//: If we want to now force the actual type and value into a variable, we do that with the **!** . This is called *forced unwrapping*
var testx = addrLineTwo!

var addrLineThree:  Optional<String>   // the "un-sugared" version of Optional

addrLineOne = "101 Science Drive"
//addrLineTwo = "ATTN: Ric Telford"

//:If you don't give a value to an Optional, it is automatically set to nil and thus giving it a value.  This is of use when defining a structure, for example, and you don't want to use initializers.

struct Cow {
    var breed: String?
    var name: String?
}

var ruby = Cow()
print(ruby.breed as Any)
ruby.breed = "Holstein"
let newStuff: String = ruby.breed!
//: Another good example of why Optionals are important are when function calls fail.  Many functions will just return an Optional that you can test later.  For example, the `Int` object has an initializer that accepts a String.  If the String can not be converted to an Int, an Optional is returned.

let firstTry = Int("123")
let secondTry = Int("test")

//:### Optionals and if statements
//: You can use an if statement to find out whether an optional contains a value by comparing the optional against nil. You perform this comparison with the “equal to” operator (==) or the “not equal to” operator (!=). If an optional has a value, it is considered to be “not equal to” nil. Once you’re sure that the optional does contain a value, you can access its underlying value by adding an exclamation mark (!) to the end of the optional’s name. The exclamation mark effectively says, “I know that this optional definitely has a value; please use it.” This is known as forced unwrapping of the optional’s value” *Excerpt From: Apple Inc. “The Swift Programming Language (Swift 3 Beta).” iBooks.*
print(addrLineOne)
if (addrLineTwo != nil) {
    print(addrLineTwo!)}            // forced unwrapping

//:### Optional binding with if let
//: You use optional binding to find out whether an optional contains a value, and if so, to make that value available as a temporary constant or variable. Optional binding can be used with if and while statements to check for a value inside an optional, and to extract that value into a constant or variable, as part of a single action *Excerpt From: Apple Inc. “The Swift Programming Language (Swift 3 Beta).” iBooks.*

addrLineThree = "Office Fitz 3405"
if let outputLine = addrLineThree {   // optional binding
    print(outputLine)
}
else {
    print("addrLineThree has no value")
}
//: You can always set an Optional var back to nil
var optionalInt: Int?
optionalInt = 42
optionalInt = nil
print(optionalInt as Any)

/*:
* Sometimes it is clear from a program’s structure that an optional will always have a value, after that value is first set.
* In these cases, it is useful to remove the need to check and unwrap the optional’s value every time it is accessed, because it can be safely assumed to have a value all of the time.
 * These kinds of optionals are defined as *implicitly unwrapped optionals*.
 * You write an implicitly unwrapped optional by placing an *exclamation mark* (String!) rather than a question mark (String?) after the type that you want to make optional.
 * **You can think of an implicitly unwrapped optional as giving permission for the optional to be unwrapped automatically whenever it is used. Rather than placing an exclamation mark after the optional’s name each time you use it, you place an exclamation mark after the optional’s type when you declare it.** *Excerpt From: Apple Inc. “The Swift Programming Language” iBooks.*
 */
let possibleString: String? = "An optional string."
print(possibleString as Any)
let forcedString = possibleString! // requires an exclamation mark
print(forcedString)

let assumedString: String! = "An implicitly unwrapped optional string."
let implicitString = assumedString // no need for an exclamation mark

/*:
Why use an implicitly unwrapped optional?  2 reasons:
1. When you are interfacing with an external framework or the Interface Builder.  You will see examples of this when we get into Xcode and the IB.
1. "When an optional’s value is confirmed to exist immediately after the optional is first defined and can definitely be assumed to exist at every point thereafter. The primary use of implicitly unwrapped optionals in Swift is during class initialization" (From Apple Swift Programming Language Guide)
*/
//:## Optional Chaining
/*:
 
 You specify optional chaining by placing a question mark (?) after the optional value on which you wish to call a property, method or subscript if the optional is non-nil. This is very similar to placing an exclamation mark (!) after an optional value to force the unwrapping of its value.

The main difference is that optional chaining fails gracefully when the optional is nil, whereas forced unwrapping triggers a runtime error when the optional is nil. To reflect the fact that optional chaining can be called on a nil value, **the result of an optional chaining call is always an optional value**, even if the property, method, or subscript you are querying returns a nonoptional value.
 
 You can use this optional return value to check whether the optional chaining call was successful (the returned optional contains a value), or did not succeed due to a nil value in the chain (the returned optional value is nil). Specifically, the result of an optional chaining call is of the same type as the expected return value, but wrapped in an optional. A property that normally returns an Int will return an Int? when accessed through optional chaining. *Excerpt From: Apple Inc. “The Swift Programming Language"*
*/
class Person {
    var residence: Residence?
}
class Residence {
    var numberOfRooms: Int = 1
}
let john = Person()
//let roomCount = john.residence!.numberOfRooms  // this triggers a runtime error
john.residence = Residence()
if let roomCount = john.residence?.numberOfRooms {    // remove the question mark to see the error this causes
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}

//:## Optionals and the guard statement
//: The guard statement is part of Swift error handling which allows you to test a condition before continuing.  One of those conditions can be testing the assignment of an optional.
func testDog(dogName: String?) -> String {
    guard let brier = dogName else {
        return "no value"
    }
    return brier
}
var dog: String?
testDog(dogName: dog)
dog = "Brier"
testDog(dogName: dog)

