//
//  MainPageController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/1/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//


import UIKit

class canvasVC: UIViewController {
    
    
    
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var betweenAmountAndMaterial: NSLayoutConstraint!
    
    @IBOutlet weak var betweenWidthAndMaterial: NSLayoutConstraint!
    
    @IBOutlet weak var betweenHeightAndMaterial: NSLayoutConstraint!
    
    
    @IBOutlet weak var betweenSizeAndPostPrint: NSLayoutConstraint!
    
    @IBOutlet weak var betweenPostPrintAndPrice: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
