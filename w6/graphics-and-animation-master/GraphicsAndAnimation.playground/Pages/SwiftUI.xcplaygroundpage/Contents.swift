import UIKit
import SwiftUI

/*:
# SwiftUI
* Drawing is actually a bit easier in SwiftUI because it is interactive
* Creating drawing orders can be difficult to get the coordinates right
* Having an interactive canvas allows for easy trial-and-error
*/
//: ![](badge.png)
/*:
 ## Drawing
 * One of the key structs is “GeometryReader”
 * “A container view that defines its content as a function of its own size and coordinate space.”
 * “This view returns a flexible preferred size to its parent layout.”
 * It passes a parameter “geometry” which is of type “GeometryProxy” and contains info you can work with, like the width and height of the frame you are drawing in.  (see below)
 * Another powerful tool is the way you add elements to a path.
 * There are a number of methods:
 `.addEllipse, .addLine, .addCurve, .addArc, .addRect`
 */
struct BadgeSymbol: View {
    static let symbolColor = Color(red: 79.0 / 255, green: 79.0 / 255, blue: 191.0 / 255)
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = min(geometry.size.width, geometry.size.height)
                let height = width * 0.75
                let spacing = width * 0.030
                let middle = width * 0.5
                let topWidth = width * 0.226
                let topHeight = height * 0.488
                
                path.addLines([
                                CGPoint(x: middle, y: spacing),
                                CGPoint(x: middle - topWidth, y: topHeight - spacing),
                                CGPoint(x: middle, y: topHeight / 2 + spacing),
                                CGPoint(x: middle + topWidth, y: topHeight - spacing),
                                CGPoint(x: middle, y: spacing)
                ])
                path.move(to: CGPoint(x: middle, y: topHeight / 2 + spacing * 3))
                path.addLines([
                                CGPoint(x: middle - topWidth, y: topHeight + spacing),
                                CGPoint(x: spacing, y: height - spacing),
                                CGPoint(x: width - spacing, y: height - spacing),
                                CGPoint(x: middle + topWidth, y: topHeight + spacing),
                                CGPoint(x: middle, y: topHeight / 2 + spacing * 3)
                ])
            }
            .fill(Self.symbolColor)
        }
    }
}
/*:
 ## Animation
 * “When you use the animation(_:) modifier on a view, SwiftUI animates any changes to animatable properties of the view. A view’s color, opacity, rotation, size, and other properties are all animatable.”
 * There are .animation modifiers
      * In HikeView.swift, you can see the effect of .animation on the chevron image.
      * Both the movement and the scaleEffect are animated
 * There is also a withAnimation method
      * In HikeView.swift, you can see how this is used as well.
      * The method can have parameters or not
 * You can Animate transitions with the transition modifier
      * By extending “AnyTransition” you can customize transitions
      * See HikeView.swift for some options
 * You can create more complex animations by various modifiers for custom Animations
      * Various parameters of .speed and .delay is one way
      * See HikeGraph.swift

 */

