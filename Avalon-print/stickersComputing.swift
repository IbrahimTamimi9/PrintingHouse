//
//  stickersComputing.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/22/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//

import Foundation
import UIKit

//MARK: SHOWS IF ELEMENTS IN postersMaterialVC.swift, postersPostPrintVC.swift, postersAmountAndSizeVC CHECKED OR NOT
struct stickersBoolVariables {
    static var amount = ""
    static var amountDidNotInputed = true
  
    static var stickersWidhOrHeightDidNotInputed = true
    static var stickersWidthSet = ""
    static var stickersHeightSet = ""
  
    static var priceToLabel = String()
    static var ndsPriceToLabel = String()
  
}

func stickersComputings() {
  let materialTitle = "Stickers"
  
  let materialPrice = priceData.materialPrice
  let printPrice = priceData.printPrice
  
  //MARK: POST PRINT
  let postPrintMaterialPrice = priceData.postPrintMaterialPrice
  let postPrintWorkPrice = priceData.postPrintWorkPrice
  
  
  if( postersBoolVariables.amountDidNotInputed == true || postersBoolVariables.postersWidhOrHeightDidNotInputed == true )  {
    
    postersBoolVariables.priceToLabel = "0"
    postersBoolVariables.ndsPriceToLabel = "0"
    
  } else if (materialPrice == 0.0 || printPrice == 0.0) && (postPrintMaterialPrice != 0.0 || postPrintWorkPrice != 0.0) {
    
    postersBoolVariables.priceToLabel = "0"
    postersBoolVariables.ndsPriceToLabel = "0"
  } else {
    
    getPosterStickerPrice (title: materialTitle,
                           materialPrice: materialPrice, materialPrintPrice: printPrice,
                           prepress: postPrintMaterialPrice, workPrepress: postPrintWorkPrice)
  }
  
    //MARK: CITY MATERIAL, VARIANTS START
    if ( stickersBoolVariables.amountDidNotInputed == true || stickersBoolVariables.stickersWidhOrHeightDidNotInputed == true )  {
        
        stickersBoolVariables.priceToLabel = "0"
        stickersBoolVariables.ndsPriceToLabel = "0"
      
    } else if (materialPrice == 0.0 || printPrice == 0.0) && (postPrintMaterialPrice != 0.0 || postPrintWorkPrice != 0.0) {
      
      stickersBoolVariables.priceToLabel = "0"
      stickersBoolVariables.ndsPriceToLabel = "0"
    } else {
      
      getPosterStickerPrice(title: materialTitle,
                            materialPrice: materialPrice, materialPrintPrice: printPrice,
                            prepress: postPrintMaterialPrice, workPrepress: postPrintWorkPrice)
  }
}// func computings()
