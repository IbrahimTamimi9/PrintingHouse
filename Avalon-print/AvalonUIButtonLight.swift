//
//  AvalonUIButtonLight.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/21/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class AvalonUIButtonLight: UIButton {

  override var isEnabled: Bool {
    didSet{
      
      if isEnabled {
        enableButton()
      } else {
        disableButton()
      }
    }
  }
  

 fileprivate func enableButton() {
  UIView.animate(withDuration: 0.3, animations: {
    self.alpha = 1.0 })

  }
  
  
  fileprivate func disableButton () {
    UIView.animate(withDuration: 0.3, animations: {
      self.alpha = 0.3 })
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    titleLabel?.font = UIFont.systemFont(ofSize: 20)
    
    titleLabel?.backgroundColor = AvalonPalette.avalonControllerBackground
    
    setTitleColor(AvalonPalette.avalonBlue, for: .normal)
    
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    
  }

}
