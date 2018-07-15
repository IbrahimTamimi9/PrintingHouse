//
//  AvalonUIButton.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/18/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

extension UIButton {
  func setBackgroundColor(_ color: UIColor, for state: UIControlState) {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    color.setFill()
    UIRectFill(rect)
    let colorImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    setBackgroundImage(colorImage, for: state)
  }
}

class AvalonUIButton: UIButton {
  
  override var isEnabled: Bool {
    didSet{
      alpha = isEnabled ? 1.0 : 0.6

    }
  }
  

  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    titleLabel?.adjustsFontSizeToFitWidth = true
    
    titleLabel?.font =  UIFont.systemFont(ofSize: 18)
    
    setTitleColor(UIColor.white, for: .normal)
   
    round(corners: .allCorners, withRadius: 11)
  
    setBackgroundColor(AvalonPalette.avalonBlue, for: .normal)
    
    titleLabel?.backgroundColor = backgroundColor
  }
  
}
