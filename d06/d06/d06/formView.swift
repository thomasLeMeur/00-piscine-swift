//
//  formView.swift
//  d06
//
//  Created by Thomas LE MEUR on 6/20/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit

class formView: UIView {
    var type: Int
    
    init (point: CGPoint) {
        type = 1
        super.init(frame: CGRect(x: point.x - 50, y: point.y - 50, width: 100, height: 100))
        if CGFloat((arc4random() % 2)) * 50 != 0 {
            type = 0
            layer.cornerRadius = 50
        }
        backgroundColor = generateColor()
        clipsToBounds = true
        layer.masksToBounds = true
        center = point
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:))))
        addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(_:))))
        addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotationGesture(_:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    func generateColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        if (self.type == 1) {
            return .rectangle
        } else {
            return .ellipse
        }
    }
    
    func movinUpdate(_ v: formView) {
        ViewController.it.collisionBehavior.removeItem(v)
        ViewController.it.elasticityBehavior.removeItem(v)
        ViewController.it.dynamicAnimator.updateItem(usingCurrentState: v)
        ViewController.it.collisionBehavior.addItem(v)
        ViewController.it.elasticityBehavior.addItem(v)
    }
    
    func panGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            ViewController.it.gravityBehavior.removeItem(self)
            movinUpdate(self)
        case .changed:
            center = gesture.location(in: superview)
            movinUpdate(self)
        case .ended:
            ViewController.it.gravityBehavior.addItem(self)
        default:
            print("balek j'ai dit 1")
        }
    }
    
    func pinchGesture(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            ViewController.it.gravityBehavior.removeItem(self)
            movinUpdate(self)
        case .changed:
            let side = 100 * gesture.scale
            if side <= UIScreen.main.bounds.width && side <= UIScreen.main.bounds.height {
                frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: side, height: side)
                if type == 0 {
                    layer.cornerRadius = side / 2
                }
                movinUpdate(self)
            }
        case .ended:
            ViewController.it.gravityBehavior.addItem(self)
        default:
            print("balek j'ai dit 2")
        }
    }
    
    func rotationGesture(_ gesture: UIRotationGestureRecognizer) {
        switch gesture.state {
        case .began:
            ViewController.it.gravityBehavior.removeItem(self)
            movinUpdate(self)
        case .changed:
            transform = CGAffineTransform(rotationAngle: gesture.rotation)
            movinUpdate(self)
        case .ended:
            ViewController.it.gravityBehavior.addItem(self)
        default:
            print("balek j'ai dit 3")
        }
    }
}
