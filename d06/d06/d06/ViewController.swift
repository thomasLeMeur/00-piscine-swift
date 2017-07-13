//
//  ViewController.swift
//  d06
//
//  Created by Thomas LE MEUR on 6/20/17.
//  Copyright © 2017 Thomas LE MEUR. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    var dynamicAnimator: UIDynamicAnimator!
    var gravityBehavior: UIGravityBehavior!
    var collisionBehavior: UICollisionBehavior!
    var elasticityBehavior: UIDynamicItemBehavior!
    var motionManager: CMMotionManager!
    
    static var it: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.it = self
        
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        gravityBehavior = UIGravityBehavior(items: [])
        collisionBehavior = UICollisionBehavior(items: [])
        elasticityBehavior = UIDynamicItemBehavior(items: [])

        gravityBehavior.magnitude = 1
        elasticityBehavior.elasticity = 0.5
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        
        
        dynamicAnimator.addBehavior(gravityBehavior)
        dynamicAnimator.addBehavior(collisionBehavior)
        dynamicAnimator.addBehavior(elasticityBehavior)
        
        motionManager = CMMotionManager()
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.2
            motionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler: accelerometerHandler)
        }        
    }
    
    func accelerometerHandler(data: CMAccelerometerData?, error: Error?) {
        let mini = CGFloat(min(data!.acceleration.x, min(data!.acceleration.y, data!.acceleration.z)))
        let maxi = CGFloat(max(data!.acceleration.x, max(data!.acceleration.y, data!.acceleration.z)))
        if maxi > -mini {
            gravityBehavior.magnitude = maxi
        } else {
            gravityBehavior.magnitude = mini
        }
        //gravityBehavior.angle = 
    }
    
    func createNewView(point: CGPoint) {
        let newView = formView(point: point)
        view.addSubview(newView)
        addBehaviors(newView: newView)
    }
    
    func addBehaviors(newView: UIView) {
        gravityBehavior.addItem(newView)
        collisionBehavior.addItem(newView)
        elasticityBehavior.addItem(newView)
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            createNewView(point: sender.location(in: view))
        default:
            print("balek")
        }
    }

}

