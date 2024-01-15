import UIKit
//:# Swift Overview
//: This playground roughly follows the official Swift documentation which can be found [here](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/).  I suggest you read a section or two in the documentation first, then come to this playground to experiment and reinforce your learning.
//:### The Swift Language was developed and delivered by Apple in 2014
//: * Originally just for iOS/macOS, but now controlled by [swift.org](https://www.swift.org/)
//: * Now available on tvOS, watchOS, Ubuntu, CentOS, Amazon Linux and Windows
//: * If you know C, C++ and/or Objective C, some of it will seem familiar
//: * We will be learning Swift 5
//:### Swift incorporates modern programming patterns:
//: * Object-oriented – “Everything is an object”
//: * Variables are always initialized before use
//: * Automatic memory management
//: * Array indices are checked for out-of-bounds errors
//: * Integers are checked for overflow
//: * Strong typing – knows type of every object reference at every moment
//: * The use of *Optionals* ensure that **nil** values are handled explicitly
//: * Error handling allows controlled recovery from unexpected failures
/*:
* Swift provides its own versions of all fundamental C and Objective-C types, including *Int* for integers, *Double* and *Float* for floating-point values, *Bool* for Boolean values, and *String* for textual data. Swift also provides powerful versions of the three primary collection types, *Array*, *Set*, and *Dictionary*, as described in Collection Types.
* Like C, Swift uses *variables* to store and refer to values by an identifying name. Swift also makes extensive use of variables whose values can’t be changed. These are known as *constants*, and are much more powerful than constants in C. Constants are used throughout Swift to make code safer and clearer in intent when you work with values that don’t need to change.
* In addition to familiar types, Swift introduces advanced types not found in Objective-C, such as *tuples*. Tuples enable you to create and pass around groupings of values. You can use a tuple to return multiple values from a function as a single compound value.
* Swift also introduces *optional* types, which handle the absence of a value. Optionals say either “there is a value, and it equals x” or “there isn’t a value at all”. Using optionals is similar to using nil with pointers in Objective-C, but they work for any type, not just classes.
* Swift is a type-safe language, which means the language helps you to be clear about the types of values your code can work with. If part of your code requires a String, type safety prevents you from passing it an Int by mistake.
*/
/*:
 ## Constants and Variables
 * Constants and variables associate a name (such as `maximumNumberOfLoginAttempts` or `welcomeMessage`) with a value of a particular type (such as the number 10 or the string "Hello"). The value of a constant can’t be changed once it’s set, whereas a variable can be set to a different value in the future.
 */
let maximumNumberOfLoginAttempts = 10
var welcomeMessage = "Hello"
//: * You can declare multiple constants or multiple variables on a single line, separated by commas:
 var x = 0.0, y = 0.0, z = 0.0
//: ## Type Annotations
//:  * You can provide a type annotation when you declare a constant or variable, to be clear about the kind of values the constant or variable can store. Write a type annotation by placing a colon after the constant or variable name, followed by a space, followed by the name of the type to use.
 var welcomeMessage2: String
//: * The colon in the declaration means “…of type…,” so the code above can be read as: “Declare a variable called `welcomeMessage` that’s of type `String`.”
//: * The phrase “of type `String`” means “can store any `String` value.” Think of it as meaning “the type of thing” (or “the kind of thing”) that can be stored.
//: * The welcomeMessage variable can now be set to any string value without error:
 welcomeMessage = "Howdy"
//: * You can define multiple related variables of the same type on a single line, separated by commas, with a single type annotation after the final variable name:
 var red, green, blue: Double
//: ## Naming Constants and Variables
//: * Constant and variable names can contain almost any character, including Unicode characters:
 let π = 3.14159
 let 你好 = "你好世界"
 let 🐶🐮 = "dogcow"
//: *  Constant and variable names can’t contain whitespace characters, mathematical symbols, arrows, private-use Unicode scalar values, or line- and box-drawing characters. Nor can they begin with a number, although numbers may be included elsewhere within the name.
//: * Once you’ve declared a constant or variable of a certain type, you can’t declare it again with the same name, or change it to store values of a different type. Nor can you change a constant into a variable or a variable into a constant.
//: * Convention is to create variable and constant names in "camelCase" where the first word is lowercase and subsequent words start with an Upper case letter.
//: * Unlike a variable, the value of a constant can’t be changed after it’s set. Attempting to do so is reported as an error when your code is compiled:
 let languageName = "Swift"
//: * This would fail: `languageName = "Swift++`"
//: ## Printing Constants and Variables
//: * You can print the current value of a constant or variable with the print(_:separator:terminator:) function:
 print(languageName)
//: * The print(_:separator:terminator:) function is a global function that prints one or more values to an appropriate output. In Xcode, for example, the print(_:separator:terminator:) function prints its output in Xcode’s “console” pane. The separator and terminator parameter have default values, so you can omit them when you call this function. By default, the function terminates the line it prints by adding a line break. To print a value without a line break after it, pass an empty string as the terminator — for example, print(someValue, terminator: ""). For information about parameters with default values, see Default Parameter Values.
//: * Swift uses string interpolation to include the name of a constant or variable as a placeholder in a longer string, and to prompt Swift to replace it with the current value of that constant or variable. Wrap the name in parentheses and escape it with a backslash before the opening parenthesis:
 print("The current value of languageName is \(languageName)")
//: ## Comments
//: * Use comments to include nonexecutable text in your code, as a note or reminder to yourself. Comments are ignored by the Swift compiler when your code is compiled.
//: * Comments in Swift are very similar to comments in C. Single-line comments begin with two forward-slashes (//):
// This is a comment.
//: * Multiline comments start with a forward-slash followed by an asterisk (/*) and end with an asterisk followed by a forward-slash (*/):
 /* This is also a comment
 but is written over multiple lines. */
//: * Unlike multiline comments in C, multiline comments in Swift can be nested inside other multiline comments. You write nested comments by starting a multiline comment block and then starting a second multiline comment within the first block. The second block is then closed, followed by the first block:
 /* This is the start of the first multiline comment.
     /* This is the second, nested multiline comment. */
 This is the end of the first multiline comment. */
//: * Nested multiline comments enable you to comment out large blocks of code quickly and easily, even if the code already contains multiline comments.
//: ## Semicolons
//: * Unlike many other languages, Swift doesn’t require you to write a semicolon (;) after each statement in your code, although you can do so if you wish. However, semicolons are required if you want to write multiple separate statements on a single line:
 let cat = "🐱"; print(cat)
//:## Messages are passed to Objects via dot notation
//: * Since “everything is an object”, the following is valid:
let myTwo = 2.description
let newNum = 323.advanced(by: 5)
//: * Every noun is an object, and every verb is a message
//:## Three kinds of Object types:  classes, structs, and enums
//: * Classes are passed by reference, which allows for things like inheritance
//: * Structs and enums are passed by value
//:## Files are meaningful units and there are definite rules about the structure of the Swift code that goes inside it.
//: * import statements (modules to include)
//: * global variables (can be seen everywhere)
//: * global functions (can be seen everywhere)
//: * object type declarations (class, struct, enum)
/*:
 ## Type Aliases
 * Type aliases define an alternative name for an existing type
 */
typealias AudioSample = UInt16
var maxAmplitudeFound = AudioSample.max
//:## Native Types
//:### Int
//: Int represents an integer between `Int.max` and `Int.min`
print(Int.max)
print(Int.min)
let sampleInt = -234
//: * There is also `Uint`, which is an unsigned Int
let sampleUInt = UInt(5)
// let testUInt = sampleUInt - 6       // what happens here?
//:### Double
//:`Double` represents a floating-point number to a precision of about 15 decimal places
//: * To convert from Int to Double or vise-versa, use instantiation –
let i = 5
let j = Double(i)
let pi: Double = 3.14159265358979323846264
//: * There is also `Float` which is half the precision of `Double`
let pi1: Float = Float(pi)
let pi2: Double = Double(pi1)
let pi3: Int = Int(pi)
//:### Bool
let onState = true
//: Bool only has two values – **true** and **false**
var trueOrFalse: Bool = false
if trueOrFalse {
    print("its true!")
} else {
    print("it is not true")
}
//: * The `!` unary operator reverses the value of the Bool
let newVal = !trueOrFalse
//: * && returns true if both operands are true
//: * || return true if either operand is true
let first = true
let second = false
let third = first || second
//:### Tuple
//: A tuple is a lightweight custom ordered collection of multiple values.
var nameRankandSerial = ("Crunch", "Captain", 34592)
let (name, rank, serialnum) = nameRankandSerial
print(rank + " " + name + ", \(serialnum)")
var pair : (Int, String) = (1, "two")
print(pair)
//:NOTE: There are other types (Int8, UInt16, etc) but they are in the Swift language for compatibility reasons
//:### Numeric Literals
//: Int Types can be entered in various forms of *Numeric Literals*
//: * Binary number
let bNum = 0b0011
//: * Octal number
let oNum = 0o031
//: * Hexadecimal number
let hexiNum = 0xABD0
//: Float Types can also have an optional exponent
//: * Lower case e for decimal exponent
let expoNum = 14.8e2
//: * Lower case p for hexadecimal
let hexExpNum = 0xFp2
//:## Computed Variables
//: * Variables can be
//:*stored*
//: or
//:*computed*
//: (
//:`get`
//: and
//:`set` routines)
//: * Stored variables can have
//:*setter observers *
//:`(`
//:`willSet, didSet )`
var now : String {
    get {
        return NSDate().description
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

print(myLotSize.sqft)

myLotSize.sqft = 200000
print(myLotSize.acres)
myLotSize.acres = 10
print(myLotSize.acres)
print(myLotSize.sqft)
/*:
 ### Setter Observers
 */
var saveNew = ""
var saveOld = ""
var s: String = "whatever" {
    willSet {
        saveNew = newValue
    }
    didSet {
        saveOld = oldValue
        s = "override"
    }
}
print(s)
s = "Hello"
print(s)

/*:
 ## Optional
 You use *optionals* in situations where a value may be absent.  An optional represents two possibilities:  Either there is a value, and you can unwrap the optional to access that value, or there isn't a value at all.
 */

let convertedNumber = Int("123")
print(convertedNumber as Any)
let numj = convertedNumber!

/*:
 The absence of a value in handled by a special value *nil*.  You define Optionals by following the type with a question mark, `?`.  If you define an Optional without providing a default value, the variable is automatically set to *nil* for you
 */
var surveyAnswer:  String? = "Yes"
var zipcode3: Int?
var surveyAnswer2: Optional<String> = "No"
var surveyAnswer3: String?
print(surveyAnswer2 as Any)
/*:
 Just fyi, the Optional type is implemented as an *enumeration* with two cases - Optional.none and Optional.some(wrapped)
*/
let number: Int? = Optional.some(42)
let noNumber: Int? = Optional.none
print(noNumber == nil)
//: There is an entire section later in this playground covering Optionals

//: [Next](@next)
