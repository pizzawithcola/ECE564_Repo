//: [Previous](@previous)
import UIKit

//:# Control Flow
//:### for-in 
//: * performs a set of statements for each item in a range, sequence, collection or progression.
//: * iterate over collections of items
var test3 = 0
for index in 1...10 {
    test3 = 5 + index
}

//: * if you don’t need the value, you can use underscore
for _ in 1...4 {
        
}
let base = 3
let power = 10
var answer = 1
for _ in 1...power {
    answer *= base
}
print("\(base) to the power of \(power) is \(answer)")

let numberOfLegs = ["spider":8, "ant":6, "cat":4]
for (animalName, legCount) in numberOfLegs {
    print("\(animalName)s have \(legCount) legs")
}

for index in 0 ..< 3 {
    print(index)
}
//:### switch/case
//: * considers a value and compares it against possible patterns.  Can be conditions, ranges, tuples, values, values with where
//: * case
//:statements do not fall through. must be exhaustive (every possibility)
//: * `default:` covers all of the cases not yet covered
//: * `case _:` means "any value"
let someCharacter: Character = "4"
switch someCharacter {
case "a", "e", "i", "o", "u":
    print("\(someCharacter) is a vowel")
case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z":
    print("\(someCharacter) is a consonant")
default:
    print("\(someCharacter) is not a vowel or a consonant")
}

let integerToDescribe = 5
var description = "The number \(integerToDescribe) is"
switch integerToDescribe {
case 2, 3, 5, 7, 11, 13, 17, 19:
    description += " a prime number, and also"
    fallthrough
default:
    description += " an integer."
}
print(description)
//: using Range in a switch
var card: Character = "🂹"
// card = "🃚"
// card = "A"
var cardType: String
switch card {
case "🂡"..."🂮":
    cardType = "Spade"
case "🂱"..."🂾":
    cardType = "Diamond"
case "🃁"..."🃎":
    cardType = "Heart"
case "🃑"..."🃞":
    cardType = "Club"
case _:
    cardType = "Not a Card"
}
//: using value bindings in a switch
let anotherPoint = (2, 0)
switch anotherPoint {
case (let x, 0):
    print("on the x-axis with an x value of \(x)")
case (0, let y):
    print("on the y-axis with a y value of \(y)")
case let (x, y):
    print("somewhere else at (\(x), \(y))")
}
//: using value bindings with "where" in a switch
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:
    print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y:
    print("(\(x), \(y)) is on the line x == -y")
case let (x, y):
    print("(\(x), \(y)) is just some arbitrary point")
}
//:### while
//:performs a set of statements until a condition is
//:`false`
//:evaluates its condition at the start of each pass through the loop
var xx = 1
while xx < 10 {
    print(xx)
    xx += 1
}
var limit = 0
var dieRoll = 0
while limit < 70 {
    dieRoll = Int(arc4random()) % 6 + 1
    limit += dieRoll
}
//:### repeat-while
//:evaluates its condition at the end of each pass
var yy = 1
repeat {
    print(yy)
    yy += 1
} while yy < 10

limit = 0
var numRolls = 0
repeat {
    dieRoll = Int(arc4random()) % 6 + 1
    print("Die Roll: \(dieRoll)")
    numRolls += 1
    limit += dieRoll
} while limit < 70
//:### if/else
//:- execute if true, else execute, etc
if xx == yy {
    print("xx and yy are equal")
} else {
    print("xx and yy are not equal")
}

if numRolls < 20
{
    print("average roll was greater than 3.51")
} else {
    print("average roll was less than 3.51")
}
/*:
 ### Control Transfer statements
 Control transfer statements can change the order in which code in your program is executed by unconditionally transferring program control from one piece of code to another. Swift has five control transfer statements: a `break` statement, a `continue` statement, a `fallthrough` statement, a `return` statement, and a `throw` statement.
 */
//: * `break` – ends execution of the loop or switch entirely
//: * `continue` – stop this iteration through the loop or switch and go on to next iteration
//: * `fallthrough` - used in switch statements to fall into next case
//: * `return` - occurs in the body of a function or method definition and causes program execution to return to the calling function or method
//: * `throw` - occurs in the body of a throwing function or method, or in the body of a closure expression whose type is marked with the `throws` keyword. A `throw` statement causes a program to end execution of the current scope and begin error propagation to its enclosing scope. The error that’s thrown continues to propagate until it’s handled by a `catch` clause of a `do` statement.
let testcase = 1
switch testcase {
case 1:
//    print("it is 1")
    fallthrough
case 2:
    print("it is 2")
case _:
    print("it is others")
}
/*:
 # Closures

*Closures* are self-contained blocks of functionality, enclosed in curly braces `{ }`, that can be passed around. Closures *capture and store references* to any constants and variables that were in scope when the closure **was defined**, even if the closure is in a different scope when it is executed.
* Closures are *reference types* – you are creating a reference to the closure, not a new copy or value of the closure
* There are 3 types of Closures.
* **Global** and **Nested** functions are actually 2 types of closures.
* The 3rd type are called **Closure Expressions** or “anonymous functions”
    * Global Functions – have a name, don’t capture values
    * Nested Functions – have a name, capture values
    * Closure expressions / anonymous functions – no name, capture values
 */
//:## Global Functions
//: * A function is a self-contained chunk of code to perform a specific task
//:- Use `func` to declare a function. Call a function by following its name with a list of arguments in parentheses and separated by commas.
func sayHi(personName: String) -> String { return "Hi, \(personName)!"}
sayHi(personName: "Jamie")
//: * return ends the `func`
//: * Arguments / return value are not required
//: * Each function parameter has both an argument label and a parameter name.
func someFunction(argumentLabel parameterName: Int) {
    print("inside the function we use parameterName: \(parameterName)")
}
someFunction(argumentLabel: 5)
//: * The **argument label** is used when calling the function; each argument is written in the function call with its argument label before it.
//: * The **parameter name** is used in the implementation of the function.
//: * By default, parameters use their parameter name as their argument label.
//: * Optionally, you can use "_" to make the first argumentLabel optional
func sayHello(_ from: String, toPerson to: String) -> String { return "Hello \(to) from \(from)"}
func sayBye(_ from: String, toPerson to: String) -> String { return "Bye \(to) from \(from)"}
sayHello("Ric", toPerson: "Niral")
//: * An example of a function with default argument labels.
func blackJackHand(card1: Int, card2: Int) -> String {
    var strHand: String
    let handTotal = card1 + card2
    strHand = "\(handTotal)"
    if card1 == 1 || card2 == 1 {
        strHand += " or \(handTotal+10)"
    }
    return strHand
}
blackJackHand(card1: 4, card2: 8)
blackJackHand(card1: 1, card2: 10)
//: * Functions can be *overloaded* (multiple functions with same name / parm names) if they have different signatures
//: * Each function has a function *signature* or *type*, just like an `Int`, or `String` is a *type*
func newOne (a: Int)-> Int {
    return(5)
}
//:has a *signature* or *type* of `(Int) -> Int`
func newOne (a: Int, b: String) -> String {
    return("done")
}
//:has a *signature* or *type* of `(Int, String) -> String`
//: * Function types can then be used like any other type
var getVal: (Int) -> Int = newOne
//: * Function types can be used as parameter types for calls to other functions
func callMe (getVal: (Int) -> Int) {}

//greetPerson 调用了上面的方法
func sayGreeting(greeting: String, person: String, greetPerson: (String, String) -> String) -> String {
    var tempstr = greetPerson("me", person) + "\n"
    tempstr += greeting
    return tempstr
}
sayGreeting(greeting: "Have a Nice Day!", person: "Ric", greetPerson: sayHello)
sayGreeting(greeting: "Have a good evening", person: "Ric", greetPerson: sayBye)
//: * Function types can be used as the return type of another function
func boolToString1 (isOdd: Bool) -> () -> String {
    return {
        if isOdd == true {
            return "It is Odd"
        } else {
            return "It is Even"
        }
    }
}
let result1 = boolToString1(isOdd: false)
result1()

//等同于⬇️

func boolToString2 (isOdd: Bool) -> String {
    if isOdd == true {
        return "It is Odd"
    } else {
        return "It is Even"
    }
}
let result2 = boolToString2(isOdd: false)
print(result2)
//: * Functions can pass multiple return values in a tuple
func minMax(array: [Int]) -> (min: Int, max: Int) {
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value >
            currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
let minMaxAns = minMax(array: [3, 7, 12, 76, 83, 23, 212, 17] )

print("\(minMaxAns.min) is the min and \(minMaxAns.max) is the max")
//: * Parameters can be declared with default values and thus are omittable
func say(_ s:String, times:Int = 1) {}
say("woof")
say("woof", times: 3)

func nameMaker(firstName: String, lastName: String, title: String = "Mr.") -> String {
    return title + " " + firstName + " " + lastName
}
nameMaker(firstName: "Ric", lastName: "Telford", title: "Prof.")
nameMaker(firstName: "Ric", lastName: "Telford")
/*:
 ## Variadic Parameters
* Variadic Parameters* accept 0 or more values of a specific type
* Write variadic parameters by inserting three periods (…) after the parameters **type name**
* A function can have only one variadic parameter and it must be last
*/
// variadic: 可变参数，可接受不定数量的参数=

func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5, 6, 7, 8, 9)

func addUp(numbers: Int...) -> Int {
    var tally: Int = 0
    for count in numbers {
        tally += count
    }
    return tally
}
addUp(numbers: 4, 5, 6, 7, 8)
addUp(numbers: 10, 20, 30, 40, 50, 60, 70, 80, 90)
/*:
 ## In-Out Parameters
* Function parameters are constants by default.
* To make a parameter a variable (changes persist after function return), use `inout`
 * Place an ampersand (&) before a variable’s name to pass the address of the variable, not the value. `inout` parameters cannot have defaults or be variadic
 */
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let tempA = a
    a = b
    b = tempA
}
var a = 5
var b = 6
swapTwoInts(&a, &b)
print(a)
func hitMe( myHand: inout Int) {
    let newCard = Int(arc4random_uniform(10) + 1)
    myHand += newCard
}

var myHand = 3
hitMe(myHand: &myHand)
hitMe(myHand: &myHand)
hitMe(myHand: &myHand)


/*:
 ## Nested functions
 * If a function exists inside the body of another function it is a **Nested Function**.
 * It should be noted that, inner functions can be only called and used inside the enclosing function (outer function).
 * The nested function captures that values from the enclosing function, meaning it has access to them, both the parameter values and any variables/constants.
*/
var baseCount = 1  // Global variable

func outerFunction(_ startCount: Int) {
    let anotherCounter = baseCount + 1
    func innerFunction(){
        print("the value of startCount is \(startCount)")
        print("the value of baseCount is \(baseCount)")
        print("the value of anotherCounter is \(anotherCounter)")
        let finalCounter = anotherCounter + startCount + 1
        print("the value of finalCounter is \(finalCounter)")
    }
    innerFunction()  //uncomment to see the innerFunction run
    print("outerFunction complete")
}

outerFunction(5)

// innerFunction()  // if you uncomment it causes an error
/*:
## Closure Expressions

 * Closure expressions are useful when:
     * A function does not need a name or need vars in scope beyond a simple use.
     * Initializing an instance property
 * Closure expressions can be optimized in the following ways:
     * Inferring parameter and return values from context
     * Implicit returns from single-expression closures
     * Shorthand argument names
     * Trailing closure syntax
*/
let names = ["Chris", "Alex", "Eva", "Barry", "Daniel"]
/*:
 Best example is to show the sort() method for arrays.  The sort(_:) method accepts a closure that takes two arguments of the same type as the array’s contents, and returns a Bool value to say whether the first value should appear before or after the second value once the values are sorted. The sorting closure needs to return true if the first value should appear before the second value, and false otherwise.  This example is sorting an array of String values, and so the sorting closure needs to be a function of type (String, String) -> Bool.
 */
func forwards(s1: String, s2: String) -> Bool {
    return s2 > s1
}
func backwards(s1: String, s2: String) -> Bool {
    return s1 > s2
}
var ans1 = names.sorted()
var ans1b = names.sorted(by: forwards)
var ans2 = names.sorted(by: backwards)
var ans2b = names.sorted(by: >)
//: rather than writing a function, you can pass a closure
var ans3 = names.sorted(by: { (s1: String, s2: String) -> Bool in return s2 > s1 })
print(ans3)
//: inferred types since we know the definition of sort()
var ans4 = names.sorted(by: { s1, s2 in return s1 > s2 })
/*: implicit return when you have a single-expression closure.  Since we know sorted() returns a Bool, there is no ambiguity */
var ans5 = names.sorted(by: {s1, s2 in s2 > s1})
/*: shorthand argument names so don't need any declarations.
 don't need "in" anymore since what is left is just body
 */
var ans6 = names.sorted(by: { $0 > $1 })
/*: since ">" is also a function, you can infer its type as well.  it is what is called a "string-specific implementation" of the greater sign operator which accepts 2 Strings and returns a Bool.
 */
var ans7 = names.sorted(by: > )
print(ans7)

/*:
 ### Trailing Closures
 Trailing closures are most useful when the closure is sufficiently long that it is not possible to write it inline on a single line. As an example, Swift’s Array type has a map(_:) method which takes a closure expression as its single argument. The closure is called once for each item in the array, and returns an alternative mapped value (possibly of some other type) for that item. The nature of the mapping and the type of the returned value is left up to the closure to specify.
 
 After applying the provided closure to each array element, the map(_:) method returns a new array containing all of the new mapped values, in the same order as their corresponding values in the original array.
 */

let funTimes = ["Awesome","Crazy","Cool"]
var outp = funTimes.map({return $0.uppercased()})
print(outp)
/*:
 If the closure is long, better to use a trailing closure. Note that if it is a function with one parm that is a closure, the parentheses are optional
 */
let digitNames = [
    0: "Zero", 1: "One", 2: "Two", 3: "Three", 4: "Four", 5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"]
let numbers = [16, 58, 510]

let strings = numbers.map {   //no parentheses
    (value) -> String in
    var output = ""
    var number = value
    while number > 0 {
        output = digitNames[number % 10]! + output
        number /= 10
    }
    return output
}
print(strings)

//: [Next](@next)

