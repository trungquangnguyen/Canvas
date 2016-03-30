//
//  ViewController.swift
//  Canvas
//
//  Created by nguyen trung quang on 3/30/16.
//  Copyright © 2016 coderSchool. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayCenterOpen: CGPoint!
    var trayCenterClosed: CGPoint!
    var newlyCreatedFace: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        trayCenterOpen = trayView.center
        trayCenterClosed = CGPointMake(trayView.center.x, self.view.frame.size.height + 50)
    }

    @IBAction func onTrayPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        // Absolute (x,y) coordinates in parent view (parentView should be
        // the parent view of the tray)
        let point = panGestureRecognizer.locationInView(self.view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
            trayOriginalCenter = trayView.center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("Gesture changed at: \(point)")
            let translation = panGestureRecognizer.translationInView(self.view)
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)

        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
            let velocity = panGestureRecognizer.velocityInView(self.view)
            print("Velocity: \(velocity.y)")
            if velocity.y < 0 {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.trayView.center = self.trayCenterOpen
                });
            } else if velocity.y > 0 {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.trayView.center = self.trayCenterClosed
                });
            }
        }
    }
    
    @IBAction func imageViewDidPan(sender: UIPanGestureRecognizer) {
        let image = sender.view as! UIImageView
        if sender.state == .Began{
            newlyCreatedFace = UIImageView(image: image.image)
            self.view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = image.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
        }else if sender.state == .Changed {
            newlyCreatedFace.center = sender.locationInView(self.view)
        }
        
    }
    

}

