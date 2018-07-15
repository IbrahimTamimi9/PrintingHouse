//
//  InitialImageView.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 2/3/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//


import UIKit

public class InitialImageView : UIImageView {
  
  public var fontResizeValue:CGFloat = 0.26
  public var font = UIFont(name: "Avenir-Light", size: 11)  //font size does not matter, it will be calculated by the base on fontResizeValue and self.bounds
  public var isCircle = true
  
  public func setImageWithFirstName(firstName: String, lastName: String, backgroundColor: UIColor = UIColor.darkGray, randomColor: Bool = false) {
    self.setImageWithInitial(initial: getInitialFromName(name: "\(firstName) \(lastName)"), backgroundColor: backgroundColor, randomColor: randomColor)
  }
  
  public func setImageWithName(name: String, backgroundColor: UIColor = UIColor.darkGray, randomColor: Bool = false) {
    self.setImageWithInitial(initial: getInitialFromName(name: name), backgroundColor: backgroundColor, randomColor: randomColor)
  }
  
  public func setImageWithInitial(initial: String, backgroundColor: UIColor = UIColor.darkGray, randomColor: Bool = false) {
    let attributedInitial = NSAttributedString(string: initial, attributes: createFontAttribute())
    
    if randomColor {
      let bgColor = UIColor.randomNonNearWhiteColor()
      self.image = createImageFromInitial(attributedInitial: attributedInitial, backgroundColor: bgColor)
      
      if backgroundColor != UIColor.darkGray {
        print("Warning: backgroundColor parameters will be ignored if randomColor is set to true")
      }
    } else {
      self.image = createImageFromInitial(attributedInitial: attributedInitial, backgroundColor: backgroundColor)
    }
  }
  
  // MARK: - Helpers
  func getInitialFromName(name: String) -> String {
    let fullName = name.components(separatedBy: " ") //componentsSeparatedByString(" ")
    var initial = String()
    
    if let firstChar = fullName[safe: 0]?.first {
      initial.append(firstChar)
    }
    if let secondChar = fullName[safe: 1]?.first {
      initial.append(secondChar)
    }
    
    return initial
    
  }
  
  func createFontAttribute() -> [NSAttributedStringKey: AnyObject] {
    let fontSize = self.bounds.width * fontResizeValue;
    let fontAttribute:[NSAttributedStringKey: AnyObject] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white, NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font!.withSize(fontSize)]
    return fontAttribute
  }
  
  private func createImageFromInitial(attributedInitial: NSAttributedString, backgroundColor: UIColor) -> UIImage {
    let scale = UIScreen.main.scale
    let bounds = self.bounds
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
    let context = UIGraphicsGetCurrentContext()
    
    if (isCircle) {
      let path = CGPath(ellipseIn: self.bounds, transform: nil);
      context!.addPath(path)
      context?.clip()
    }
    
    context!.setFillColor(backgroundColor.cgColor)
    context!.fill(CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
    
    let textSize = attributedInitial.size()
    let rect = CGRect(x: bounds.size.width/2 - textSize.width/2, y: bounds.size.height/2 - textSize.height/2, width: textSize.width, height: textSize.height)
    
    attributedInitial.draw(in: rect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image!
    
  }
}

extension UIColor {
  static func randomNonNearWhiteColor() -> UIColor {
    //upper bounds is set to 215 to prevent color that is "near" white which result in no differences between initial and bg color
    let red = CGFloat(arc4random_uniform(215)) / 255
    let green = CGFloat(arc4random_uniform(215)) / 255
    let blue = CGFloat(arc4random_uniform(215)) / 255
    
    return UIColor(red: red, green: green, blue: blue, alpha: 1)
  }
}

extension Array {
  subscript (safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
