//: [Previous](@previous)
import UIKit
//:## Final Topics
//:### Extensions
//: * Extensions add new functionality to an existing class, structure, enumeration, or protocol type. This includes the ability to extend types for which you do not have access to the original source code (known as *retroactive modeling*).
//: * Extensions in Swift can:
//:     *  Add computed instance properties and computed type properties
//:     *  Define instance methods and type methods
//:     *  Provide new initializers
//:     *  Define subscripts
//:     *  Define and use new nested types
//:     *  Make an existing type conform to a protocol

struct Animal {
    let legs: Int
    let type: String
}
let dog = Animal(legs: 4, type: "Dog")

extension Animal: CustomStringConvertible {
    var description: String {
        type
    }
}
print(dog)

//:### Computed Variables
//: * Variables can be
//:*stored*
//: or
//:*computed*
//: (
//:`get`
//: and
//:`set` routines)

var now : String {
    get {
        return Date().description
    }
}

print(now)

struct lotsize {
    var acres : Float
    
    init(acres: Float) {
        self.acres = acres
    }
    var sqft : Float {
        get {
            return acres * (200*220)
        }
        set {
            self.acres = newValue / (200*220)
        }
    }
}

var myLotSize = lotsize(acres: 3)
print("My lot is \(myLotSize.sqft) square feet")

myLotSize.sqft = 200000
print("My lot is \(myLotSize.acres) acres")
/*:
 ### Setter Observers
 */
//: * Stored variables can have
//:*setter observers*
//:`(`
//:`willSet, didSet )` There are some keywords that are valid in context of each.  The keyword `newValue` contains the value that is being set to and is valid in scope of `willSet`.  `oldValue` contains the former value of the variable and is in scope of `didSet`.

var areacode: Int = 919 {
    willSet {
        if (newValue == 555) {
            print("not a valid area code")
        }
    }
    didSet {
        if (areacode == 555) {
            print("this is not valid, returning to old value")
            areacode = oldValue
        }
    }
}

areacode = 555
print(areacode)

/*:
### Error Handling
 * *Error Handling* is the process of responding to and recovering from error conditions in your program.
 * errors are represented by values of types that conform to the `Error` protocol.  Enumerations are good for this:
*/
enum MyAppError: Error {
    case JSONFail
    case BluetoothFail
    case FileReadFail
    case IntConvertFail
    case NotEqualFail
}
//: **NOTE:** Many `UIKit` functions now throw Error so you will need to look up the `enum` values in the appropriate Programming Guide
//: * Throwing an error lets you indicate something unexpected happened.
func toInt(_ myString: String) throws -> Int {
    guard let testInt = Int(myString) else {
        throw MyAppError.IntConvertFail
    }
    return testInt
}
//: * Because the `toInt(_ myString:)` method propagates any errors it throws, any code that calls this method must either handle the errors - using a `do-catch` statement, `try?` or `try!` - to continue to propagate them.
//: * A simple `try?` will handle the error by converting it to an optional value.  Do this if you will handle any error conditions the same way
let response = try? toInt("3")
print(response as Any)
//: * You can also use it in an `if` or `guard` statement.  These will unwrap the Optional for you. The advantage of the `guard` is now the unwrapped Optional value is in scope for any code that follows
if let newResponse = try? toInt("3") {
        print(newResponse as Any)
    } else {
        print("it failed")
}

guard let nextResponse = try? toInt("3") else {
    throw MyAppError.IntConvertFail
}
print(nextResponse as Any)

//: * To catch the Error, use `do-catch` instead
do {
    let xx = try toInt("sfd")
    let yy = try toInt("3")
} catch MyAppError.IntConvertFail {
    print("Did not convert")
} catch MyAppError.BluetoothFail {
    print("blue")
}
//: * If you **know** a function that throws will *not* throw an Error, you can use `try!` to call the function but if you are wrong, then a runtime error will occur.
 let finalResponse = try! toInt("5")
//: * Note that we also used a `guard` statement in `toInt()`.  Like an `if` statement, a `guard` executes based on the Boolean value of an expression.  Use a `guard` to require that a condition must be true in order for the code after the `guard` statement to be executed.
//: * **Unlike an `if` statement**, a `guard` statement always has an `else` clause - the code inside the `else` clause is executed if the condition is not true.
func isItAFour(_ myNum: Int) throws {
    guard (4 == myNum) else {
        print("It is not a Four")
        throw MyAppError.NotEqualFail
    }
    print("It is a Four")
}

do {
    try isItAFour(3)
} catch MyAppError.NotEqualFail {
    print("Items are not equal")
}
//: By the way, Error does not always need an enum.  Here is an example of a struct as Error compliant so that you can pass along more info in case of an error.
struct XMLParsingError: Error {
    enum ErrorKind {
        case invalidCharacter
        case mismatchedTag
        case internalError
    }

    let line: Int
    let column: Int
    let kind: ErrorKind
}

struct XMLDoc {
    let body: String?
}

func parse(_ source: String) throws -> XMLDoc {
    // ...
    throw XMLParsingError(line: 19, column: 5, kind: .mismatchedTag)
    // ...
}

/*:
### Property Wrappers
 ### (quoted content from docs.swift.org)
 “A property wrapper adds a layer of separation between code that manages how a property is stored and the code that defines a property. For example, if you have properties that provide thread-safety checks or store their underlying data in a database, you have to write that code on every property. When you use a property wrapper, you write the management code once when you define the wrapper, and then reuse that management code by applying it to multiple properties.”
 
 "To define a property wrapper, you make a structure, enumeration, or class that defines a wrappedValue property. In the code below, the TwelveOrLess structure ensures that the value it wraps always contains a number less than or equal to 12. If you ask it to store a larger number, it stores 12 instead."
 */
@propertyWrapper
struct TwelveOrLess {
    private var number = 0
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, 12) }
    }
}

//: "The setter ensures that new values are less than or equal to 12, and the getter returns the stored value.You apply a wrapper to a property by writing the wrapper’s name before the property as an attribute. Here’s a structure that stores a rectangle that uses the TwelveOrLess property wrapper to ensure its dimensions are always 12 or less:"
struct SmallRectangle {
    @TwelveOrLess var height: Int
    @TwelveOrLess var width: Int
}

var rectangle = SmallRectangle()
print(rectangle.height)
// Prints "0"

rectangle.height = 10
print(rectangle.height)
// Prints "10"

rectangle.height = 24
print(rectangle.height)
// Prints "12"
//: [Next](@next)
