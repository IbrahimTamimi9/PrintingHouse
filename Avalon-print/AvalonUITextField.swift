//
//  AvalonUITextField.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/18/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class AvalonUITextField: UITextField {
  
  override var isEnabled: Bool {
    didSet{
      alpha = isEnabled ? 0.9 : 0.6
      text = isEnabled ? "" : ""
    }
  }

  override func draw(_ rect: CGRect) {
    
   // alpha = 0.9
    if isEnabled {
      alpha = 0.9
    } else {
      alpha = 0.6
    }
    isOpaque = false
    clipsToBounds = true
    borderStyle = .roundedRect
    backgroundColor = UIColor.white
  
  }
}
