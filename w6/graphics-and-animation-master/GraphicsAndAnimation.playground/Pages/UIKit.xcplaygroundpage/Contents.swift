//: [Previous](@previous)
import UIKit
import SwiftUI
/*:
 # Graphics and Animation in UIKit
 ## Overview
 * What goes into a UIView?
      * Text Content
      * Image Content
      * Graphics Content
 * Drawing in the UIView
      * draw
      * Graphic Context
      * Layers
 * Animating the content
## Text
 There are 3 levels of objects to think about when presenting text in an app:
 String and NSAttributedString, which contain the actual text content.
 Pre-built, text-drawing interface objects which know how to draw these strings –
 UILabel
 UITextField
 UITextView
 Text Kit – a text framework which provides low-level text functions and drawing features in UIKit
 Note:  If you are working in SwiftUI, to do Attributed Text you would just put attributes on Text objects.
### Attributed String
 * You are familiar with String, but what if you want to add attributes like **bold** or *italic*?
 * This is when you use `AttributedString`.
 * `AttributedString` and `MutableAttributedString` consists of a String plus the attributes.
 
 Attributed Strings can be created in an .xib or .storyboard when designing a UILabel, UITextField or UITextView
 You can of course always create them in code
 
 The example code in the app still shows the old way of using Attributed Strings, which is with 'NSAttributedString'
 
 The same thing can be accomplished with the Swift `AttributedString`

 */
var attributedString = AttributedString("This is a string with empty attributes.")
var container = AttributeContainer()
container[AttributeScopes.UIKitAttributes.ForegroundColorAttribute.self] = .red
attributedString.mergeAttributes(container, mergePolicy: .keepNew)

var thankYouString = AttributedString()
do {
    thankYouString = try AttributedString(
        markdown:"**Thank you!** Please visit our [website](https://example.com)")
} catch {
    print("Couldn't parse: \(error)")
}
print(thankYouString)
/*:
 ### Fonts
 A font is a “set of type of one particular face and size”
 Every text string will be rendered given a font (if not specified, then the system default).
 Fonts can be set for text strings via identifying the actual font (UIFont) or a font descriptor (UIFontDescriptor)
 UIFont init(name:size:) – you need to know the name, with every variant (bold, italic) having its own name
 UIFontDescriptor allows you to specify traits or attributes of a font to derive a font type.
 One can be converted to the other and vice-versa

 */
/*:
## Image Content (Raster Graphics)
An Image is a set of pixels arranged in a set of row and columns.
Also knows as Raster Graphics or a Bitmap
iOS supports Image objects in many different formats (such as .jpg and .png)
*/
//: ![](pixels.png)
/*:
UIImage objects are a high-level way to display image data
Immutable wrapper of its CGImage which is the actual image data
Properties such as size, scale, resizingMode, imageOrientation
Set of Drawing methods for drawing in a Graphics Context.
There is a pre-built UIImageView that provides a view-based container for displaying either a single image or for animating a series of images
A UIImageView without an image and without a background color is invisible.  So you can set up View and attach image later
Behavior is based on properties of the image and the view.
Image properties that affect presentation are leftCapWidth or topCapHeight
View property that affect presentation is  contentMode
.ScaleToFill, .Center, .AspectFit, .AspectFill .Top, .Bottom, .Left, .Right
highlighted property dictates which of image and highlightedImage to display
*/
/*:
 ## Vector Graphics
 * Vector graphics are shapes which are drawn first and then rasterized into an image to be displayed.
 * A set of Vector graphics is often called a set of drawing orders, as it is a list of instructions to the system to place on the screen.
 * iOS has a robust set of ways to place vector graphics on the screen.
* A **Graphics Context** allows for drawing to take place that is then going to be displayed.
* Think of a graphic context as a virtual “sketch pad” that you begin, draw on, and then end.
 * Most common way is to subclass UIView and implement draw.
      * The graphic context is already open for you when draw is called.
      * Whatever you draw is rendered and shown when the UIView appears
 * Alternatively, you can create a graphic context at any time to create a picture:
     * UIGraphicsBeginImageContextWith Options opens the context.
     * UIGraphicsGetImageFromCurrentImageContext turns the graphics into a UIImage
     * UIGraphicsEndImageContext dismisses the context


 */
UIGraphicsBeginImageContextWithOptions(CGSize(300, 300), true, 0.0)
let color:UIColor = UIColor.blue
let bpath:UIBezierPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 300, height: 300))
bpath.lineWidth = 5
color.set()
bpath.stroke()
let color2:UIColor = UIColor.black
let bpath2:UIBezierPath = UIBezierPath(roundedRect: CGRect(x: 100, y: 100, width: 100, height: 150), cornerRadius: 10)
color2.set()
bpath2.lineWidth = 2
bpath2.stroke()
let saveImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
UIGraphicsEndImageContext()

/*:
 ## Drawing
 * “Drawing” implies placing the content inside a View rectangle:
     * Text content
     * Raster graphic / Image / Bitmap content
     * Vector graphic / Graphic content
 * There are numerous approaches and frameworks for drawing, for example:
     * The UI (Cocoa) framework has the UIImage library for managing image (raster) objects (like .png, .jpg, etc)
     * The CG (Core Graphics) framework is a C-based API that has a rich area of 2D-rendered graphics (vector) and image (raster / bitmap) objects
## What are Image and Graphics used for?
 * These are the basic constructs for designing the content of a UIView.
 * You have been mostly using UIView subclasses that are “pre-built” and contain their drawn content (although you add things like images and text to them).
 * If you make your own UIView subclass, you can override it’s `draw` method to design your own content.
 * Placing image data in the view itself, or on a layer
 * Drawing inside a graphic context to create truly custom user interface content.
## Layers
 * When a View is displayed, it usually is a cached version of the drawing – the raster or bitmap version of the view.
 * This bitmap is called the “layer”
 * By using Layer interfaces, you can modify how a view is drawn
 * A view can be composed of multiple layers, allowing pieces of the drawing to be treated as objects and manipulated individually
 * Layers are the basis of animation.  (The “CA” stands for “Core Animation”)
 * A UIView instance has an accompanying CALayer instance, accessible via layer property
      * A layer can have sublayers, but only one superlayer
      * Once you create a new layer, you can then add it to the superlayer with addSubLayer method
 * There are 3 handy pre-built Layers you can add to your drawing:
      * `CAGradientLayer`, which gives you a nice gradient background
      * `CAShapeLayer`, where you draw a path and set it to the layer’s path property
      * `CATextLayer`, where you put text in the layer’s string property
 * The key properties of a Layer you need to know:
      * bounds – the coordinates of the layer relative to its own space
      * anchorpoint – is the location within the layer where the layer is “pinned” to its superlayer! Example – CGPoint(0.5, 0.5)
      * position – the location on the superlayer where the anchorpoint goes  Example: CGPoint(50, 50)

 */
//: ![](donkey.png)
/*:
## Animation
 * There are many ways to animate content in an iOS application
 * The 4 main categories of animation are:
     * UIImageView and UIImage animation
     * UIView animation – there are a limited number of UIView properties you can animate, but it is an easy way to do it
     * Implicit Layer Animation – changing an animatable property of any non-UIView layer is animated by default
     * Explicit Layer Animation – this is the true animation capability provided through the Core Animation library.
 * `UIImageView` animation is as simple as setting some existing properties.
 */
let iv = UIImageView()
 iv.animationImages = [UIImage(), UIImage()]
 iv.animationDuration = 2
 iv.animationRepeatCount = 1
 iv.startAnimating()
/*:
 * UIView has a small set of properties that, when changed, can be automated:
      * Alpha, bounds, center, frame, transform, backgroundColor
 * Two types of UIView animation - ”block-based” and the new UIViewPropertyAnimator.
 * The concept is the same – a set of changes to the properties above that are then “animated” as the changes are made.
 */
//: [Next](@next)
