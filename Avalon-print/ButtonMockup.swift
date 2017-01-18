//
//  ButtonMockup.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/8/16.

import UIKit

@IBDesignable
public class ButtonMockup: UIButton {
//    @IBInspectable var borderColor: UIColor? = UIColor.clear {
//        didSet {
//            layer.borderColor = self.borderColor?.cgColor
//        }
//    }
//    @IBInspectable var borderWidth: CGFloat = 0 {
//        didSet {
//            layer.borderWidth = self.borderWidth
//        }
//    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = self.cornerRadius
            layer.masksToBounds = self.cornerRadius > 0
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override public func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.cornerRadius
       // self.layer.borderWidth = self.borderWidth
       // self.layer.borderColor = self.borderColor?.cgColor
    }
}
