//
//  MainPageController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/1/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//


import UIKit

class canvasVC: UIViewController {
    
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var leftImageViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var betweenAmountAndMaterial: NSLayoutConstraint!
    
    @IBOutlet weak var betweenWidthAndMaterial: NSLayoutConstraint!
    
    @IBOutlet weak var betweenHeightAndMaterial: NSLayoutConstraint!
    
    
    @IBOutlet weak var betweenSizeAndPostPrint: NSLayoutConstraint!
    
    @IBOutlet weak var betweenPostPrintAndPrice: NSLayoutConstraint!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
         applyMotionEffect(toView: backgroundImageView, magnitude: 25)
        
        // //MARK: iPhone 5/5c/5s/se
        if screenSize.height == 568 {
            topConstraint.constant = 30
            betweenAmountAndMaterial.constant = 50
            betweenWidthAndMaterial.constant = 20
            betweenHeightAndMaterial.constant = 20
            betweenSizeAndPostPrint.constant = 50
            betweenPostPrintAndPrice.constant = 40
        }
        
        //MARK: iPhone 6+/7+
        if screenSize.height == 736 {
            topConstraint.constant = 40
            betweenAmountAndMaterial.constant = 70
            betweenWidthAndMaterial.constant = 40
            betweenHeightAndMaterial.constant = 40
            betweenSizeAndPostPrint.constant = 70
            betweenPostPrintAndPrice.constant = 60
            
        }

    
    
    }
    
    
}
