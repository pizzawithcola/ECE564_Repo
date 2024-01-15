//: [Previous](@previous)
import UIKit


/*:
 # Operators
 ## Unary
 `+ - ! (prefix)`
 */
var unaryMath:Int = 4 + 5
let reverseIt = -unaryMath
//: Note:  The unary + operator does not do anything
let andBack = +reverseIt
//:  As mentioned above, unary ! also works on `Bool` types
let doubleNeg = !(!true)
/*:
 ## Binary
 `= + - / % += -=`
 */
var firstNum = 9
var secondNum = 34
firstNum += 25
firstNum % 5
/*:
 ### Comparisons == != > < >= <=
 */
if firstNum == secondNum {
    print("equal", terminator:".")
} else {
    print("not equal")
}
/*:
 ### Identity === !==
 `(same object instance)`
 */
class Dog {
    let sound = "Bark"
}
let fido = Dog()
let rover = Dog()
let max = fido
if fido === max {
    print("they are the same Dog!")
} else {
    print("those are two different Dogs!")
}
/*:
 ### Nil Coalescing ??
 */
let defaultColor = "black"
//: Note: `userColor` is defined as an Optional without setting a value
var userColor: String?
var setColor = userColor ?? defaultColor
//: Now let's set userColor to a value
userColor = "red"
setColor = userColor ?? defaultColor
/*:
 ### Range
 `a...b  a..<b`
 */
for index in 1..<4 {
    print("\(index) times 5 is \(index*5)")
}
let numRange = 0...3
/*:
 ### Logical && ||
 */
let trueOrFalse = true
var needToPrint: Bool = true
if (needToPrint && trueOrFalse) {
    print("Printed")
}
/*:
 ### Ternary:
 `(a ? b : c)`
 */
var outsideUS: Bool = true
//outsideUS = false                // what happens here?
let countrycode = outsideUS ?  "001" : "   "
//:## Strings and Characters
let sampleString = "Hello World"
//: * A `String` is an ordered collection of *Character* types
//: * Characters are Unicode scalar values – 21 bit number  up to U+10FFFF
//: * Special Unicode characters -
//:`\0 (null), \\ (backslash), \t (tab), \n (newline), \r (carriage return),  \” (double quotation), \’ (single quotation)`
//: * Contents of a String can be accessed in various ways, including breaking it into its Characters by putting in an Array
//: * Strings are **value** types - always copied when passed to a function or method.
//: * Characters
//: in the
//:`for-in `
//:`loop`
//: * Strings
//: can be concatenated using + and +=.  You can add on
//:`characters`
//: with .
//:`append`
//: method
//: * Other methods include .
//:`hasPrefix`
//: and .
//:`hasSuffix`
//: * *String interpolation* is a way to form strings from any set of variables/constants using
//:`\(varname)`
let babychick = "\u{1F425}"
let babychick2: Character = "\u{1F425}"
let chicknum = 0x1F425
let babychick3 = Character(UnicodeScalar(chicknum)!)
var phrase1 : String = "Everyone likes "
phrase1 += babychick
phrase1.append(babychick2)
let cnt3 = phrase1.count
let phrase2 = "A \"quote\" would go here\r\nalong with a new line"
//: ### Iterating through a string
let dolph =  "Dolphin🐬"
for letter in dolph {
    print(letter)
}
//: ### Characters out of a string
let str = "this is a string"
let arr = Array(str)
let c = arr[0]
//: ### String concatenation / interpolation
let classname = "ECE"
let week = "Week"
let classnum = 564
let weeknum = 1

var title = classname + " \(classnum) " + week + " \(weeknum)"
print(title)

let exclamationMark: Character = "!"
title.append(exclamationMark)
print(title)

if title.hasSuffix("!") {
    print("You do not need the explanation point")
}
//:  ### Array to String and vice-versa
var arr2 : Array = ["1", "2", "3"]
let str2 = arr2.joined(separator: " ")
let str3 = arr2.joined(separator: "")
let str4 = String(describing: arr2)
let characters = Array("This is a String")
let addrNumArray = characters[0...3]
let addrNum = String(addrNumArray)
/*:
 ## Advanced String Capabilities
 ### String Indices
 * Since a Unicode character can be of varying widths in bytes, you use the String *index type*, `String.Index` to find the location of each `Character`
 * Properties and methods include `startIndex`, `endIndex`, `index(before:)`, `index(after:)` and `index(_:offsetBy:)`
 * You can use subscript notation to access characters in this way
 */
var classInfo = "ECE 564"
classInfo[classInfo.startIndex]
classInfo[classInfo.index(before: classInfo.endIndex)]
classInfo[classInfo.index(classInfo.startIndex, offsetBy: 4)]
//: * Use the `indices` property to access all of the indices in a string
for index in classInfo.indices {
    print("\(classInfo[index]) ", terminator: "")
}
//: * To insert and remove a character in a String, use `insert(_:at:)` and `remove(at:)`
classInfo.insert(contentsOf: "Fall 2019", at: classInfo.endIndex)
classInfo.remove(at: classInfo.index(classInfo.startIndex, offsetBy: 3))
print(classInfo)
/*:
 ### Substrings
* A type of `Substring` is created when you subscript into a String to access a piece of that String.
* Once you are done manipulating the Substring, you need to convert it into a `String` for longer term use
 */
let substrStart = classInfo.index(after: classInfo.firstIndex(of: " ")!)
let substrEnd = classInfo.index(before: classInfo.endIndex)
let subStr = classInfo[substrStart...substrEnd]
let termString = String(subStr)
/*:
### Multiline Strings
 * Use three double quotation marks to create a multiline string literal
 *  It starts with the line after the first set, and ends with the line above the closing set of quotation marks
 * If you indent the trailing quotation marks, then that many indented spaces will be ignored on all lines above.
 * A backslash (\) can be used to prevent the insertion of line breaks
 */
let haiku =  """
    
   
   The river goes by
   Never stopping to say "hello"
   It just sort of waves
   
   
 """
print(haiku)
let oneliner =
"""
      This will \
show up as \
one continuous line
"""
print(oneliner)
/*:
 ### String Methods*/
oneliner.isEmpty
oneliner.hasPrefix("This")
oneliner.hasSuffix("line")
oneliner.count
//: # Collection Types
//:  There are 3 collection types in Swift - Arrays, Dictionaries and Sets
//: ## Arrays
//: * Ordered list of values of the same type
//: * Declare with type and using []
var MyArray: [String] = ["one", "two", "three"]
//: * Access and modify an array through methods, properties and subscript []
//:    *   Examples: `.count, .isEmpty, .append, .insert, .removeAtIndex, .removeLast`
let cnt = MyArray.count
//: * Iterate over the array using for/in loop
//: * Create an empty array using initializer syntax
var someInts = [Int]()
//: * Initiate an array with values using initializer syntax
var someMoreInts = [Int](repeating: 5, count: 5)
//: ### Examples - Arrays
var students = Array<String>()    // initialize an empty Array
students = ["Joe", "Jack", "Josh", "Fred"]
var moreStudents: [String] = ["Jane", "Jen", "Jill", "Kate"]
var oneMoreStudent = ["Lou"]

if !(students.isEmpty) {
    
    print("There are \(students.count) students plus \(moreStudents.count) more")
}
students.append("John")
moreStudents += oneMoreStudent
students.insert("Bill", at: 1)
print("Now there are \(students.count) students")

students[0] = "Jesse"

let droppedStudent = moreStudents.removeLast()

print(droppedStudent)

let anotherDroppedStudent = students.remove(at: 4)
students += moreStudents
for item in students {
    print(item)
}

for (index, value) in students.enumerated() {
    print("Item \(index+1): \(value)")
}

var grades = [Int]()
grades.append(92)
var moreGrades = [Int](repeating: 88, count: 5)
print(moreGrades[0])

grades += moreGrades

//: ## Dictionaries
//: * Unordered collections of key/value pairs, where the values are of the same type
//: * Declare with type and using []
var MyDict: [String: String] = ["Name":"Ric", "Title":"Prof"]
var MyDict2 = [Int: String]()
//: * Use
//:`[:] `
//:to re-initialize, as in
MyDict = [:]
//: * Access and modify a dictionary through methods, properties and subscript[]
//: * For example, `.count, .isEmpty, .updateValue, .removeValueForKey `
//: * Iterate over the dictionary using for/in loop
//:### Examples - Dictionaries
var namesOfIntegers = [String: String]()
namesOfIntegers["56"] = "One"
namesOfIntegers["123"] = "Two"
print(namesOfIntegers)
namesOfIntegers = [:]

var deptStrings: [String: String] = ["ECE" : "Electical / Computer Engineering", "MENG" : "Master of Engineering"]
var zipCodes = [27709: "Durham", 27560: "Morrisville", 27513: "Cary"]
print("There are \(zipCodes.count) entries in the zip code database")

zipCodes[27601] = "Raleigh"
let oldValue = zipCodes.updateValue("Raleigh", forKey: 27601)
if let zip = zipCodes[27602] {
    print("That zipCode is for \(zip).")
} else {
    print("That zipCode is not in the database")
}

if let deletedZipCode = zipCodes.removeValue(forKey: 27709) {
    print("The removed city is \(deletedZipCode)")
} else {
    print("The database did not have that zip code")
}

for (zips, cities) in zipCodes {
    print("The zip code \(zips) is for \(cities)")
}
//: ## Sets
//: * A
//:`Set`
//: stores distinct values of the same type in a collection with no defined ordering.
//: * You can use a set instead of an array when the
//:*order of items is not important, or when you need to ensure that an item only appears once*
//: * Create an empty set using initializer syntax
var letters2 = Set<Character>()
//: * Declare with type and using []
var allMyPets: Set<String> = ["Brier", "Bentley", "Kenny", "Minnie", "Niki"]
//: * Access and modify a set through methods and properties
//:`    .count, .isEmpty, .insert, .remove, .contains, .sort`
//: * Iterate over the set using for/in loop
//: * Sets also have their own unique Set Operations
//:    * `.intersect, .exclusiveOr, .union, .subtract – return a Set`
//:    * `.isSubsetOf, .isSupersetOf, .isDisjointWith – return a Bool`
//:### Examples - Sets
var letters = Set<Character>()
letters.insert("a")
letters.isEmpty
letters = []
letters.isEmpty
var MyPets: Set = ["Kenny", "Brier", "Bentley", "Niki", "Minnie"]
let num  = MyPets.count
let ordered = MyPets.sorted()
let MyCats: Set = ["Kenny", "Niki", "Minnie", "Joe"]
MyPets.insert("Rose")
print(MyPets)
var MyDogs = MyPets
MyDogs.subtract(MyCats)
if MyPets.isSuperset(of: MyCats) {
    print("All the cats are accounted for")
} else {
    print("We are missing some cats from MyPets")
}
//: [Next](@next)
