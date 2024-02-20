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
//:  **How are they different from Macros? from (https://engineering.traderepublic.com/get-ready-for-swift-macros-fe21d3867e02)
//: You might be inclined to think that Macros and property wrappers serve the same purpose, especially because they look quite similar at a glance. However, they operate at different phases of the development cycle.Property wrappers come into play at runtime, dynamically interacting with your wrapped values by applying any added logic you’ve programmed. In contrast, Macros operate strictly at compile-time, enriching your codebase before your application even starts running.
//: [Next](@next)
