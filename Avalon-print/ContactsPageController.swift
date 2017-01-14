//
//  MainPageController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/1/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
// 


import UIKit

class ContactsPageController: UIViewController {
    
  
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var leftImageViewConstraint: NSLayoutConstraint!
    
    func applyMotionEffect (toView view: UIView, magnitude: Float ) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        view.addMotionEffect(group)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        leftImageViewConstraint.constant = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        leftImageViewConstraint.constant = -25
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
         applyMotionEffect(toView: backgroundImageView, magnitude: 25)
       
    
    }
    
    @IBAction func openMap(_ sender: Any) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "map") as! map
                navigationController?.pushViewController(destination, animated: true)
        
        
    }
//    @IBAction func openMap(_ sender: Any) {
//        let destination = storyboard?.instantiateViewController(withIdentifier: "map") as! map
//        navigationController?.pushViewController(destination, animated: true)
//        
//        
//    }
}
