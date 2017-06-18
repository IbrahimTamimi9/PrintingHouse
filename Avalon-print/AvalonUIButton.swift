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
      alpha = isEnabled ? 0.9 : 0.6

    }
  }

  override func draw(_ rect: CGRect) {
    
    //alpha = 0.9
    isOpaque = false
    layer.cornerRadius = 10
    titleLabel?.font =  UIFont.systemFont(ofSize: 15, weight: 21)
    setTitleColor(UIColor.white, for: .normal)
    titleLabel?.adjustsFontSizeToFitWidth = true
    
    round(corners: .allCorners, withRadius: 10)
    setBackgroundColor(AvalonPalette.avalonBlue, for: .normal)
    
  }
}
