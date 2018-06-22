//
//  AvalonUITextField.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/18/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit


class AvalonUITextField: UITextField, UITextFieldDelegate {
  
  override var isEnabled: Bool {
    didSet{
      alpha = isEnabled ? 1.0 : 0.6
      text = isEnabled ? "" : ""
    }
  }
  
  
  override var placeholder: String? {
    
    didSet {
      guard let tmpText = placeholder else {
        self.attributedPlaceholder = NSAttributedString(string: "")
        return
      }
    
      let textRange = NSMakeRange(0, tmpText.count)
      let attributedText = NSMutableAttributedString(string: tmpText)
      attributedText.addAttribute(NSAttributedStringKey.foregroundColor , value: AvalonPalette.avalonPlaceholder, range: textRange)
      
      self.attributedPlaceholder = attributedText
    }
  }

  
  var isPasteEnabled: Bool = true
  
  var isCutEnabled: Bool = true
  
  var isDeleteEnabled: Bool = true
  
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    switch action {
    case #selector(UIResponderStandardEditActions.paste(_:)) where !isPasteEnabled,
         #selector(UIResponderStandardEditActions.cut(_:)) where !isCutEnabled,
         #selector(UIResponderStandardEditActions.delete(_:)) where !isDeleteEnabled:
      return false
    default:
      return super.canPerformAction(action, withSender: sender)
    }
  }
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
  if isEnabled {
      alpha = 1.0
    } else {
      alpha = 0.6
    }
    
    delegate = self
    
    borderStyle = .none

    backgroundColor = AvalonPalette.avalonTextFieldBackground
    
    font = UIFont.systemFont(ofSize: 17)
    
    layer.cornerRadius = 11
    
    returnKeyType = .done
    
    clearButtonMode = .whileEditing
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    
  }

  
  let inset: CGFloat = 14
  
  // placeholder position
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: inset, dy: inset)
  }
  
  // text position
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: inset, dy: inset)
  }
}
