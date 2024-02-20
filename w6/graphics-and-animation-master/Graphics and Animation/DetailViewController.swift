//
//  DetailViewController.swift
//  Graphics and Animation
//
//  Created by Richard Telford on 2/5/20.
//  Copyright © 2020 Duke Pratt. All rights reserved.
//

import UIKit
import SwiftUI


class DetailViewController: UIViewController {
    
    @IBOutlet weak var navItem: UINavigationItem!
    var detailItem: String?
    
    var textField = UITextField()
    var textView = UITextView()
    
    // "ball" UIView and animation routine for option "Graphic Context" and "View Animation"
    let blueBall: UIView = DukeBall() // The blue ball, width:100, height:100
    
    func moveBallAround() {
        UIView.animate(withDuration: 1.0, delay: 0,
                       options: [.repeat, .autoreverse], animations: {
                        self.blueBall.frame.origin.x += 100
        })
    }
    
    func configureView() {
        switch detailItem {
        case "Text":
            setMultiTextView()
        case "Image":
            setImageView()
        case "Image Animation":
            setImageAnimationView()
        case "Graphic Context":
            setGraphicContext()
        case "View Animation":
            setViewAnimationView()
        case "Path Animation":
            setGraphic()
        case "Layers":
            setLayerView()
        case "SwiftUI":
            callHostingController()
        default:
            print("error")
            // TODO:  Why did I have to add this to make it work?  Test by removing again
            detailItem = "Text"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navItem.title = detailItem
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch detailItem {
        case "Graphic Context":
            moveBallAround()
        default:
            break
        }
        
    }
    
    func setButtonView() {
        let goButton = UIButton()
        goButton.frame = CGRect(x: 50, y: 140, width: 100, height: 40)
        goButton.backgroundColor = UIColor.white
        goButton.layer.cornerRadius = 9
        goButton.layer.borderWidth = 2
        goButton.layer.borderColor = UIColor.black.cgColor
        goButton.isHidden = false
        goButton.setTitle("Change", for: .normal)
        goButton.setTitleColor(UIColor.blue, for: .normal)
        goButton.addTarget(self, action: #selector(DetailViewController.pressed(_:)), for: .touchUpInside)
        view.addSubview(goButton)
    }
    
    @objc
    func pressed(_ sender: UIButton!) {
        if detailItem == "Text" {
            fontTapped(sender) { fontName in
                // UI update should be on main queue
                DispatchQueue.main.async {
                    self.setTextView(fontName)
                    self.setTextField(fontName)
                }
            }
        }
    }
//: MARK:  Text
    func setMultiTextView() {
        view?.backgroundColor = .gray
        let firstFont = "American Typewriter"
        // Label setup
        let label = UILabel()
        label.frame = CGRect(x: 50, y: 80, width: 300, height: 20)
        label.text = "Current Font:"
        label.textColor = .black
        view?.addSubview(label)
        // TextField setup
        setTextField(firstFont)
        // Button setup
        setButtonView()
        // TextView setup
        setTextView(firstFont)
    }
    
    @objc
    func fontTapped(_ sender: UIButton, _ completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "Please choose a font", message: "press cancel to dismiss", preferredStyle: UIAlertController.Style.actionSheet)
        let AT = UIAlertAction(title: "American Typewriter", style: .default, handler: { _ in
            completion("American Typewriter")
        })
        let SE = UIAlertAction(title: "Chalkboard SE", style: .default, handler: { _ in
            completion("Chalkboard SE")
        })
        let Zapfino = UIAlertAction(title: "Zapfino", style: .default, handler: { _ in
            completion("Zapfino")
        })
        let MarkerFelt = UIAlertAction(title: "Marker Felt", style: .default, handler: { _ in
            completion("Marker Felt")
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(AT)
        alert.addAction(SE)
        alert.addAction(Zapfino)
        alert.addAction(MarkerFelt)
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = sender  // for iPad only
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    func setTextField(_ fontName: String) {
        textField.removeFromSuperview()
        let myFont = UIFont(name: fontName, size: 22.0)
        let fontString = NSAttributedString(string: fontName, attributes: [ NSAttributedString.Key.font: myFont as Any] )
        textField.frame = CGRect(x: 50, y: 100, width: 300, height: 30)
        textField.attributedText = fontString
        textField.borderStyle = .roundedRect
        textField.isEnabled = false  // use alert to change font instead, which is faster
        view?.addSubview(textField)
    }
    
    func setTextView(_ fontName: String) {
        textView.removeFromSuperview()  // first remove
        let myFont = UIFont(name: fontName, size: 22.0)
        let textLine1 =  "There are some key points to make: \n"
//        let textLine2 = "\t ✷ First, it is easy to put a shadow on text. \n\t ✷ "
        let textLine3 = "It is also easy to add any number of attributes"
        
        let firstString = NSMutableAttributedString(string: textLine1, attributes: [ NSAttributedString.Key.font : myFont as Any] )
        
        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 3
        myShadow.shadowOffset = CGSize(width: 3, height: 3)
        myShadow.shadowColor = UIColor.gray
//        let secondAttributes = [
//            NSAttributedString.Key.shadow: myShadow,
//            NSAttributedString.Key.font: myFont
//        ]
  //      let secondString = NSAttributedString(string: textLine2, attributes: (secondAttributes) as [NSAttributedString.Key : Any])
        let html = "<p>This is actually a line of HTML that can be converted. It has a <span style=\"font-family:Comic Sans MS,cursive\">font</span> <span style=\"font-family:Courier New,Courier,monospace\">change</span>, a</p><h1>heading style</h1><p>and a string of <strong>bold</strong>, and <em>some italic</em> and</p><ul><li>some</li><li>bullets</li></ul><p>&nbsp;</p>"
        let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false)!
        let secondString = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        
        let thirdAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: myFont as Any,
            NSAttributedString.Key.foregroundColor: UIColor.green,
            NSAttributedString.Key.backgroundColor: UIColor.yellow,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue ]
        let thirdString = NSAttributedString(string: textLine3, attributes: thirdAttributes)
        
        firstString.append(secondString!)
        firstString.append(thirdString)
        
        textView.frame = CGRect(x: 20, y: 200, width: 350, height: 500)
        textView.backgroundColor = UIColor.cyan
        textView.attributedText = firstString
        
        view?.addSubview(textView)
    }
    // MARK:   Image
    func setImageView() {
        let iv = UIImageView()
        iv.frame = CGRect(x: 50, y: 100, width: 300, height: 300)
        iv.image = UIImage(named: "1.png")
        view?.addSubview(iv)
        
        let iv2 = UIImageView()
        let iv3 = UIImageView()
        let iv4 = UIImageView()
        let iv5 = UIImageView()
        iv2.frame = CGRect(x: 50, y: 420, width:50, height: 80)
        iv3.frame = CGRect(x: 50, y: 510, width:50, height: 80)
        iv4.frame = CGRect(x: 250, y: 420, width:50, height: 80)
        iv5.frame = CGRect(x: 250, y: 510, width:50, height: 80)
        
        iv3.image = UIImage(named: "1.png")
        iv4.image = UIImage(named: "1.png")
        iv5.image = UIImage(named: "1.png")
        
        iv2.backgroundColor = .red
        iv3.backgroundColor = .red
        iv4.backgroundColor = .red
        iv5.backgroundColor = .red
        
        iv3.contentMode = .scaleToFill
        iv4.contentMode = .scaleAspectFill
        iv5.contentMode = .scaleAspectFit
        
        view?.addSubview(iv2)
        view?.addSubview(iv3)
        view?.addSubview(iv4)
        view?.addSubview(iv5)
    }
    
    // MARK: Image Animation
    
    func setImageAnimationView() {
        let iav = UIImageView()
        iav.frame = CGRect(x: 50, y: 200, width: 300, height: 300)
        
        let i1 = UIImage(named: "1.png")!
        let i2 = UIImage(named: "2.png")!
        let i3 = UIImage(named: "3.png")!
        let i4 = UIImage(named: "4.png")!
        let i5 = UIImage(named: "5.png")!
        iav.animationImages = [i1, i2, i3, i4, i5]
        iav.animationDuration = 1
        iav.startAnimating()
        view?.addSubview(iav)
        
    }

      // MARK: Graphic Context
    
    func setGraphicContext() {
        
        let blackBg = UIView(frame: CGRect(x: 50, y: 80, width: 200, height: 200)) // Make a black background for the blue ball
        blackBg.backgroundColor = .black
        view?.addSubview(blackBg)

        blueBall.frame = CGRect(x: 0, y: 0, width: 100, height: 100) // Place it on the top half of the scene
        blackBg.addSubview(blueBall)
        
        // Draw the two rectangles at the bottom of the scene
        let gcv2Frame = CGRect(x: 50, y: 300, width: 300, height: 300)
        
        UIGraphicsBeginImageContextWithOptions(gcv2Frame.size, false, 0.0)
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
        
        let iv = UIImageView()
        iv.frame = gcv2Frame
        iv.image = saveImage
        view?.addSubview(iv)
    }
    
    // MARK: View Animation
    func setViewAnimationView() {
        let vav = DukeBall()
    
        vav.frame = CGRect(x: 50, y: 80, width: 200, height: 200)
        
        let originalCenter = vav.center
        
        // shrink and move to the center of the view
        let animatorShrink = UIViewPropertyAnimator(duration: 2, curve: .easeInOut) { [unowned self, vav] in
            vav.center = self.view.frame.center
            vav.transform = CGAffineTransform(rotationAngle: CGFloat.pi).scaledBy(x: 0.1, y: 0.1)
        }
        
        // enlarge back to original frame
        let animatorEnlarge = UIViewPropertyAnimator(duration: 2, curve: .easeInOut) { [vav] in  // do not need to capture self
            vav.center = originalCenter
            vav.transform = CGAffineTransform(rotationAngle: 0).scaledBy(x: 1, y: 1)
        }
        
        view?.addSubview(vav)
        
        animatorShrink.startAnimation()
        // call reverse animation after finished
        animatorShrink.addCompletion { _ in
            animatorShrink.stopAnimation(true)
            animatorEnlarge.startAnimation()
        }
        
        // after all finished, repeat the function call. This is not a good design for looping forever.
        animatorEnlarge.addCompletion { _ in
            animatorEnlarge.stopAnimation(true)
            vav.removeFromSuperview()
            // since it is escaping closure, all the thing above got clean and released before next call.
            self.setViewAnimationView()
        }
    }
    
    // MARK: Path Animation
    func setGraphic() {
        let width = 300
        let height = 250
        let bgView = UIView(frame: CGRect(x: 20, y: 80, width: width, height: height))
        bgView.backgroundColor = .black
        view?.addSubview(bgView)
        
        let circleLayer = CAShapeLayer()
        let radius: CGFloat = 10
        circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius), cornerRadius: radius).cgPath
        circleLayer.position = CGPoint(x: 0, y: 0)
        circleLayer.fillColor = UIColor.yellow.cgColor
        
        let circlePath = CGMutablePath()
        circlePath.move(to: CGPoint(0, -radius))
        circlePath.addArc(center: .zero, radius: radius, startAngle: 3 * .pi/2, endAngle: .pi/2, clockwise: true)
        circlePath.addArc(center: .zero, radius: radius, startAngle: .pi/2, endAngle: 3 * .pi/2, clockwise: true)
        
        let scaleFactor: CGFloat = 2.0
        
        let smallRadius: CGFloat = 5.0   * scaleFactor
        let bigRadius: CGFloat = 20.0  * scaleFactor
        let h: CGFloat = -200  * scaleFactor
        let w: CGFloat = -145  * scaleFactor
        let h2 = h*0.4
        
        // complex math ;-)
        let heartPath = CGMutablePath()
        heartPath.move(to: CGPoint(-w*0.25, -h*0.25))  // the middle indent of the heart
        heartPath.addArc(tangent1End: CGPoint(-w, -h), tangent2End: CGPoint(0, -h2), radius: bigRadius)
        heartPath.addArc(tangent1End: CGPoint(0, -h2), tangent2End: CGPoint(w, -h), radius: 1.0)
        heartPath.addArc(tangent1End: CGPoint(w, -h), tangent2End: .zero, radius: bigRadius)
        heartPath.addArc(tangent1End: .zero, tangent2End: CGPoint(-w, -w), radius: smallRadius)
        heartPath.closeSubpath()
        
        let followHeartShape = CAKeyframeAnimation(keyPath: "position")
        followHeartShape.isAdditive = true
        followHeartShape.path  = heartPath
        followHeartShape.duration = 5
        followHeartShape.repeatCount = HUGE
        followHeartShape.calculationMode = CAAnimationCalculationMode(rawValue: "paced")
        
        let circleAround = CAKeyframeAnimation(keyPath: "position")
        circleAround.isAdditive = true
        circleAround.path = circlePath
        circleAround.duration = 0.3
        circleAround.repeatCount = HUGE
        circleAround.calculationMode = CAAnimationCalculationMode(rawValue: "paced")
        
        circleLayer.add(followHeartShape, forKey: "follow a heart shape")
        circleLayer.add(circleAround, forKey: "loop around")
        circleLayer.position = CGPoint(bgView.frame.maxX / 2, 0)
        
        let heartShape = CAShapeLayer()
        heartShape.path = heartPath
        heartShape.lineWidth = 3.0
        heartShape.strokeColor = UIColor.gray.cgColor
        heartShape.fillColor = UIColor.orange.cgColor
        heartShape.position = CGPoint(bgView.frame.maxX / 2, 0)
        //heartShape.setAffineTransform(toOrigin)
        bgView.layer.addSublayer(heartShape)
        bgView.layer.addSublayer(circleLayer)
    }
    
    // MARK: Layers
    func setLayerView() {
        let lv = ClockView()
        lv.frame = CGRect(x: 50, y: 200, width: 300, height: 300)
        view?.addSubview(lv)
    }

    func callHostingController() {
        let myButton = { text, x, y, w, h -> UIButton in
            let button = UIButton()
            button.backgroundColor = UIColor.cyan
            button.layer.cornerRadius = 30
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
            button.frame = CGRect(x: x, y: y, width: w, height: h)
            button.layer.frame = button.frame.insetBy(dx: -5,dy: -5)
            button.isHidden = false
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.setTitle(text, for: UIControl.State())
            button.titleLabel?.font = UIFont(name: "Times New Roman", size: CGFloat(18))
            button.setTitleColor(UIColor.black, for: UIControl.State())
            button.setTitleColor(UIColor.black, for: .highlighted)
            button.addTarget(self, action: #selector(self.hikeButton(_:)), for: .touchUpInside)
            return button
        }("HikeView", 50, 100, 100, 100)
        view.addSubview(myButton)
        
        let myButton2 = { text, x, y, w, h -> UIButton in
            let button = UIButton()
            button.backgroundColor = UIColor.cyan
            button.layer.cornerRadius = 30
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
            button.frame = CGRect(x: x, y: y, width: w, height: h)
            button.layer.frame = button.frame.insetBy(dx: -5,dy: -5)
            button.isHidden = false
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.setTitle(text, for: UIControl.State())
            button.titleLabel?.font = UIFont(name: "Times New Roman", size: CGFloat(18))
            button.setTitleColor(UIColor.black, for: UIControl.State())
            button.setTitleColor(UIColor.black, for: .highlighted)
            button.addTarget(self, action: #selector(self.badgeButton(_:)), for: .touchUpInside)
            return button
        }("BadgeView", 200, 100, 100, 100)
        view.addSubview(myButton2)

    }
    // MARK:  SwiftUI
    @objc func hikeButton(_ xxx: UIButton) {
        let hikeView = HikeView(hike: ModelData().hikes[0])
        let viewCtrl = UIHostingController(rootView: hikeView)
        self.present(viewCtrl, animated: true)
    }
    
    @objc func badgeButton(_ xxx: UIButton) {
        let badgeView = Badge()
        let viewCtrl = UIHostingController(rootView: badgeView)
        self.present(viewCtrl, animated: true)
    }
}


