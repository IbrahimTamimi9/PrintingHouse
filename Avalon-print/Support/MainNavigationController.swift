//
//  MainNavigationController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/21/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.view.backgroundColor = UIColor.white
      
      self.navigationBar.backgroundColor = UIColor.white
      
      self.navigationBar.tintColor = UIColor.black
      
      var backImage =  UIImage(named: "ChevronLeft")
      
      backImage = backImage?.imageWithInsets(insets: UIEdgeInsets(top: 0, left: 8, bottom: 11, right: 0))
      
      self.navigationBar.backIndicatorImage = backImage
      
      UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
      
      self.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ChevronLeft")
      
      self.navigationBar.isTranslucent = false
    
    }
}

extension UIImage {
  func imageWithInsets(insets: UIEdgeInsets) -> UIImage {
    
    UIGraphicsBeginImageContextWithOptions(
      
      CGSize(width: self.size.width + insets.left + insets.right, height:  self.size.height + insets.top + insets.bottom), false, self.scale)
      
    
    //let context = UIGraphicsGetCurrentContext()
    
    let origin = CGPoint(x: insets.left, y: insets.top)
    
    self.draw(at: origin)
    
    let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    
    return imageWithInsets!
  }
}
