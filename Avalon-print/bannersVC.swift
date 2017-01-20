//
//  MainPageController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/1/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//


import UIKit

class bannersVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var leftImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    override func viewWillDisappear(_ animated: Bool) {
        leftImageViewConstraint.constant = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        leftImageViewConstraint.constant = -25
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainScrollView.delegate = self
        
         applyMotionEffect(toView: backgroundImageView, magnitude: 25)
   }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 || scrollView.contentOffset.x<0 {
            scrollView.contentOffset.x = 0
        }
    }
    
}
