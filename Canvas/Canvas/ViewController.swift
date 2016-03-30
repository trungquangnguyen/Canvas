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
            
//            UIView.animateWithDuration(0.2, delay: 0, options: [UIViewAnimationOptions.Repeat, .Autoreverse], animations: { () -> Void in
//                image.center.x -= 5
//                image.center.y -= 5
//                }) { (bool: Bool) -> Void in
//                    image.center.x += 5
//                    image.center.y += 5
//
//            }
            
            newlyCreatedFace = UIImageView(image: image.image)
            self.view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = image.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            newlyCreatedFace.userInteractionEnabled = true
            let panOnNewImageView = UIPanGestureRecognizer(target: self, action: "newCreatedImageViewDidPan:")
            newlyCreatedFace.addGestureRecognizer(panOnNewImageView)
            
            let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(ViewController.newCreatedImageViewDidRotate(_:)))
            newlyCreatedFace.addGestureRecognizer(rotationGesture)
            
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: "scaleImage:")
            newlyCreatedFace.addGestureRecognizer(pinchGesture)
            pinchGesture.delegate = self

        }else if sender.state == .Changed {
            newlyCreatedFace.center = sender.locationInView(self.view)
        }else if sender.state == .Ended {
            //            image.layer.removeAllAnimations()
            
            let pointInTray = sender.locationInView(trayView)
            print(pointInTray)
            if CGRectContainsPoint(trayView.frame, newlyCreatedFace.center){
                //                UIView.animateWithDuration(0.2, animations: { () -> Void in
                //
                //                    }, completion: {
                //                      finish in
                //
                //                }
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.newlyCreatedFace.center = image.center
                    }, completion: { (a: Bool) -> Void in
                        self.newlyCreatedFace.removeFromSuperview()
                })
            }
        }
        
        
    }
    
    func newCreatedImageViewDidPan(panGesture: UIPanGestureRecognizer) {
        let sender = panGesture.view as! UIImageView
        if panGesture.state == .Began {
            sender.transform = CGAffineTransformMakeScale(1.5, 1.5)
        } else if panGesture.state == .Changed {
            sender.center = panGesture.locationInView(self.view)
        } else if panGesture.state == .Ended {
            sender.transform = CGAffineTransformMakeScale(1, 1)
        }
    }

    
    func newCreatedImageViewDidRotate(rotateGesture: UIRotationGestureRecognizer) {
        print("Rotation: \(rotateGesture.rotation)")
        let sender = rotateGesture.view as! UIImageView
        sender.transform = CGAffineTransformMakeRotation(rotateGesture.rotation)
    }

    func scaleImage(pinch: UIPinchGestureRecognizer){
        let sender = pinch.view as! UIImageView
        sender.transform = CGAffineTransformMakeScale(pinch.scale,pinch.scale)
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

