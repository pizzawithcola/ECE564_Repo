//: [Previous](@previous)

import UIKit
//:# Object Types – enum, struct, class
//: * Object types are
//:*first-class types*
//:– that is they
//:*work like any other variable.*
struct Dog {
    var breed: String
    var name: String = "Fido"
    
    func bark() { return }
    init() {
        breed = "Unknown"
    }
}
//: * When you declare an object type, you are only defining that
//:*type.*
//:To instantiate it, you create an
//:*instance*
//: of that type by assigning it to a constant/variable.
//:     * This is done by using the object type’s
//:*initializer* - the name as a function followed by parentheses  -
let fido = Dog()
print(fido.breed)
//:or possibly `let fido = Dog(type: Collie)` if you set up additional initializers
//:* Multiple Initializers can be defined for the object
//:`– `
//:`init (parm: Type) {code}`
//:     * If none are defined there is always an
//:*implicit initializers*, but once you have an explicit initializer the implicit one goes away.
//:     * With initializers, it is not necessary to define your properties with default values.
//:     * Forced initialization of all instance properties is a valuable feature of Swift.
extension Dog {
    init(dogType: String, name: String ) {
        self.breed = dogType
        self.name = name
    }
}
//:* Variables and functions in object types are called
//:*properties*
//: and
//:*methods*
//:, respectively -
fido.name
fido.breed
fido.bark()
let ralph = Dog(dogType: "Poodle", name: "Ralph")
print(ralph)
//:* Instances can send messages to themselves using the word
//:`self`
//:.  Self refers to that specific instance of that object type.
//:* Object members are public by default, use
//:`private`
//: keyword to prevent it from being seen -
//:`private var newCounter = 0`
//:# enum - Enumerations
//: * An
//:*enumeration*
//: defines a common type for a group of related values and enables you to work with those values in a type-safe way within your code.
//:     * In C, enums assign related names to a set of integer values. In Swift do not have to provide a value for each member of the enumeration.
//:     * Members are delineated by ‘case’
//:`enum Dogs { case Collie, case Boxer }`
//:     * Cases are referenced using dot notation (`Dogs.Collie` or `case .Collie`)
//:     * Each enumeration definition becomes a new type
//:* If a value (called
//:*raw values*
//:) is provided for each member, the value can be a String, Character, Integer or Float type
//:`enum Letters: Character { case A = “A”, B = “B”, C=“C” }`
//: * Each member of the enumeration can have
//: *associated values*
//:– values assigned of
//:*any*
//: type associated w/member
//:* An enum can contain computed properties and instance methods

enum Example {
    case A
    case B
    case C
    case D
}

var example = Example.A
example = .B
switch example {
case .A:
    print("A")
case .B:
    print("B")
case .C:
    print("C")
case .D:
    print("D")
}
//: *Associated values* are set up for instances of the enum.  They are like variables that are associated with one of the enumeration cases.  They don't all have to be of the same type. This allows you to *associate* values with an instance of an enum type.
enum Reference {
    case Book(Int)
    case Magazine(String)
}

let footnote1 = Reference.Book(9780201633610)
var footnote2 = Reference.Magazine("Time, August 26, 2019")

switch footnote2 {
case .Book(let val):
    print(val)
case .Magazine(let val):
    print(val)
}
//: *Raw values* are assigned to the **cases themselves** and have to be all of the same type. If the enum does not specify a type, then they don't have rawValues.

enum Letters: String {
    case a = "Alpha"
    case b = "Bravo"
    case c = "Charlie"
}

let newEnum = Letters.c
print(newEnum)
print(newEnum.rawValue)

enum Ranks : String {
    case Captain 
    case Major
    case Colonel
}
//: If you don't specify rawValues, defaults are assigned
print (Ranks.Major)
let rank = Ranks.Major
print (rank)
print (rank.rawValue)

enum Nums: Int {
    case uno
    case dos
    case tres
}
let spNum = Nums.uno
print (spNum.rawValue)


enum Numbers: Int {
    case One = 1, Two, Three, Four, Five
}

var five = Numbers.Five
print(five.rawValue)

var possibleNum = Numbers(rawValue: 2)!
print(possibleNum == Numbers.Two)

enum Trade {
    case Buy
    case Sell
}

func trade(tradeType: Trade, stock: String, amount: Int) {}

enum NewTrade {
    case Buy(stock: String, amount: Int)
    case Sell(stock: String, amount: Int)
}
func newTrade(type: Trade) {}

let trade = NewTrade.Buy(stock: "AAPL", amount: 500)
if case let NewTrade.Buy(stock, amount) = trade {
    print("buy \(amount) of \(stock)")
}
//: * Since enums can be kind of tricky, it may be good to learn more [here](https://appventure.me/2015/10/17/advanced-practical-enum-examples/) at appventure.me

//:# Structures
//:### *struct* defines flexible constructs that define new types
//: * Structures are *value types* - always copied when they are passed, classes are passed by reference!
//: * `Int, String, Array, Dictionary, etc. `
//:are all implemented as structures.  This differs from the Foundation class equivalents (NSString, etc) which are implemented as classes and thus passed as references
//: * Structures have an implicit initializer, but if there are explicit initializers, then they must ensure all stored properties must be initialized.
//: * Use structures when:
//:     * You need to encapsulate data values
//:     * You want the values copied each time you pass, not referenced
//:     * You don’t need to do type casting / downcasting (`is` and `as` operators)
//:     * You don’t need inheritance
//: * When the instance of a structure is defined as a
//:*constant*
//:, all the properties are then constant
//:*(immutable)*

struct InventoryItem {
    var SKU: Int
    var name: String
    var count: Int
    
    func available() -> Bool {
        return (count > 0)
    }
    
    init(SKU: Int, name: String, count: Int) {
        self.SKU = SKU
        self.name = name
        self.count = count
    }
}

let nextItem = InventoryItem(SKU: 243243323, name:"iPhone 6s", count: 34)

if (nextItem.available()){
    print("you can buy one!")
}

//:# Classes
//:* A class is similar to a struct, with the following differences:
//:    * Classes are reference types, which is different from struct and enum.  This allows classes to be *mutable in place* and can have *multiple references to the same instance.*
//:    * Classes have *inheritance*, which means they can be a *subclass* to a *superclass*
//:* Initializers in classes are a bit more complicated than structs, due to inheritance.  More on this later.
//:* `self` refers to the currently executing instance of the class
//:* `override` allows you to override the existing method of the *superclass*
//:* Classes have the *Identical to* `(===)` and *Not Identical to* `(!==)` operators to test to see if two constants or vars point to the same instance

class Animal {
    var legs: Int
    var sound: String
    
    func makeNoise() {
        print(self.sound)
    }
        
    init(legs: Int, sound: String) {
        self.legs = legs
        self.sound = sound
    }
}

let thor = Animal(legs: 4, sound: "woof")
thor.makeNoise()

class Cat: Animal {
    
    var breed: String = "unknown"
    
}

let snowflake = Cat(legs: 4, sound: "meow")
snowflake.breed = "Maine Coon"

//: ![Comparing classes and structures](table1.png)
//:# Properties
//: * Properties are constants and variables associate with a class, structure or enumeration, declared at the top level.
//: * There are calculated and stored properties (except no stored properties in enum)
//:     * A
//:*calculated property*
//:is one that does not store a value – it calculates a value whenever referenced
//:     * A
//: *stored property*
//:is a constant or var that is stored as part of an instance of a class or structure
//:     * A
//: *lazy stored property*
//:is a property whose initial value is not calculated until the first time used.
//:`lazy var totalCost = 0`
//: * There are also
//:*type properties*
//:– which are stored with the type itself, not just the instance.  Use
//:`static`
//:, or
//:`class`
//: for classes
//:* You can define
//:*property observers *
//:to monitor changes in a property’s value.  Use
//:`willSet`
//:` and `
//:`didSet`
//:# Methods
//: * `Methods` are functions that are associated with a particular type (classes, structures or enums) and declared at the top level
//:     * Instance methods
//:are associated with instance
//:     * Type methods
//:are associated with the type itself
//: * Method parameters can have both a local name and an external name, just like function parameters.
//:     * Default behavior for methods is no external name for first parameter but have them for the rest.
//:     * Use a name using a preposition such as
//:`with`
//:`, `
//:`for`
//:`, or `
//:`by`
//: to refer to the first parameter, then names for others
//: * Every instance of a type has an implicit property called
//:`self`
//:, which is exactly equivalent to the instance itself
//:     * Use
//:`self`
//: to refer to the current instance within its own instance methods


//: [Next](@next)
