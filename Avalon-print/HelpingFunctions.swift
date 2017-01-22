//
//  HelpingFunctions.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 1/20/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

func setPickerTextFieldTint(sender: [UITextField]) {
    for textfield in sender {
        textfield.tintColor = UIColor.clear
    }
}




func reset (page: String) {
    
    if page == "posters" {
        postersBoolVariables.amountDidNotInputed = true
        postersBoolVariables.amount = ""
       // print("lol from posters it works")
        
        postersBoolVariables.materialDidnNotChosen = true
        postersBoolVariables.cityC = false
        postersBoolVariables.lomondC = false
        postersBoolVariables.photoC = false
        postersBoolVariables.postersWidhOrHeightDidNotInputed = true
        postersBoolVariables.postersWidthSet = ""
        postersBoolVariables.postersHeightSet = ""
        
        postersBoolVariables.withoutPostPrint = true
        postersBoolVariables.gloss1_0C = false
        postersBoolVariables.matt1_0C = false
        postersBoolVariables.gloss1_1C = false
        postersBoolVariables.matt1_1C = false
        
        postersBoolVariables.priceToLabel = "0"
        postersBoolVariables.ndsPriceToLabel = "0"
    }
    
    
    if page == "stickers" {
        stickersBoolVariables.amountDidNotInputed = true
        stickersBoolVariables.amount = ""
        //print("lol from stickers it works")
        
        stickersBoolVariables.materialDidnNotChosen = true
        stickersBoolVariables.whiteStickerC = false
        stickersBoolVariables.transparentStickerC = false
        stickersBoolVariables.oneWayVisionC = false
        stickersBoolVariables.stickersWidhOrHeightDidNotInputed = true
        stickersBoolVariables.stickersWidthSet = ""
        stickersBoolVariables.stickersHeightSet = ""
        
        stickersBoolVariables.withoutPostPrint = true
        stickersBoolVariables.coldLaminationC = false
        
        stickersBoolVariables.priceToLabel = "0"
        stickersBoolVariables.ndsPriceToLabel = "0"
    }
    
    
    if page == "canvas" {
        canvasBoolVariables.amount = ""
        canvasBoolVariables.amountDidNotInputed = true
        //print("lol from canvas it works")
        
        canvasBoolVariables.standartSizeDidnNotChosen = true
        canvasBoolVariables.sixH_x_NineH_C = false
        canvasBoolVariables.fiveH_x_sevenH_C = false
        canvasBoolVariables.fourH_x_fiveH_C = false
        canvasBoolVariables.threeH_x_fourH_C = false
        canvasBoolVariables.twoH_x_threeH_C = false
        
        canvasBoolVariables.canvasWidhOrHeightDidNotInputed = true
        canvasBoolVariables.canvasWidthSet = ""
        canvasBoolVariables.canvasHeightSet = ""
        
        canvasBoolVariables.withoutUnderframe = true
        canvasBoolVariables.withUnderframe = false
        
        canvasBoolVariables.priceToLabel = "0"
        canvasBoolVariables.ndsPriceToLabel = "0"
    }
    
}




struct ConstraintInfo {
    var attribute: NSLayoutAttribute = .left
    var secondAttribute: NSLayoutAttribute = .notAnAttribute
    var constant: CGFloat = 0
    var identifier: String?
    var relation: NSLayoutRelation = .equal
}

precedencegroup ConstOp {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator >>>- : ConstOp

@discardableResult
func >>>- <T: UIView> (left: (T, T), block: (inout ConstraintInfo) -> Void) -> NSLayoutConstraint {
    var info = ConstraintInfo()
    block(&info)
    info.secondAttribute = info.secondAttribute == .notAnAttribute ? info.attribute : info.secondAttribute
    
    let constraint = NSLayoutConstraint(item: left.1,
                                        attribute: info.attribute,
                                        relatedBy: info.relation,
                                        toItem: left.0,
                                        attribute: info.secondAttribute,
                                        multiplier: 1,
                                        constant: info.constant)
    constraint.identifier = info.identifier
    left.0.addConstraint(constraint)
    return constraint
}

@discardableResult
func >>>- <T: UIView> (left: T, block: (inout ConstraintInfo) -> Void) -> NSLayoutConstraint {
    var info = ConstraintInfo()
    block(&info)
    
    let constraint = NSLayoutConstraint(item: left,
                                        attribute: info.attribute,
                                        relatedBy: info.relation,
                                        toItem: nil,
                                        attribute: info.attribute,
                                        multiplier: 1,
                                        constant: info.constant)
    constraint.identifier = info.identifier
    left.addConstraint(constraint)
    return constraint
}

@discardableResult
func >>>- <T: UIView> (left: (T, T, T), block: (inout ConstraintInfo) -> Void) -> NSLayoutConstraint {
    var info = ConstraintInfo()
    block(&info)
    info.secondAttribute = info.secondAttribute == .notAnAttribute ? info.attribute : info.secondAttribute
    
    let constraint = NSLayoutConstraint(item: left.1,
                                        attribute: info.attribute,
                                        relatedBy: info.relation,
                                        toItem: left.2,
                                        attribute: info.secondAttribute,
                                        multiplier: 1,
                                        constant: info.constant)
    constraint.identifier = info.identifier
    left.0.addConstraint(constraint)
    return constraint
}

// MARK: UIView

extension UIView {
    
    func addScaleToFillConstratinsOnView(_ view: UIView) {
        [NSLayoutAttribute.left, .right, .top, .bottom].forEach { attribute in
            (self, view) >>>- {
                $0.attribute = attribute
                return
            }
        }
    }
    
    func getConstraint(_ attributes: NSLayoutAttribute) -> NSLayoutConstraint? {
        return constraints.filter {
            if $0.firstAttribute == attributes && $0.secondItem == nil {
                return true
            }
            return false
            }.first
    }
    
    
}

