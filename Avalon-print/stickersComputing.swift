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
    
//    static var materialDidnNotChosen = true
//    static var whiteStickerC = false
//    static var transparentStickerC = false
//    static var oneWayVisionC = false
  
    static var stickersWidhOrHeightDidNotInputed = true
    static var stickersWidthSet = ""
    static var stickersHeightSet = ""
    
//    static var withoutPostPrint = false
//    static var coldLaminationC = false
  
    static var priceToLabel = String()
    static var ndsPriceToLabel = String()
  
  
//  static func resetMaterials() {
//    stickersBoolVariables.materialDidnNotChosen = true
//    stickersBoolVariables.whiteStickerC = false
//    stickersBoolVariables.transparentStickerC = false
//    stickersBoolVariables.oneWayVisionC = false
//    
//  }
//  
//  static func resetPostprint() {
//    stickersBoolVariables.withoutPostPrint = false
//    stickersBoolVariables.coldLaminationC = false
//    
 // }
  
}

func stickersComputings() {
  let materialTitle = "Stickers"
  
  let materialPrice = priceData.materialPrice
  let printPrice = priceData.printPrice
  
  //MARK: POST PRINT
  let postPrintMaterialPrice = priceData.postPrintMaterialPrice
  let postPrintWorkPrice = priceData.postPrintWorkPrice
  
  
//    //MARK: MATERIALS
//    let WhiteGlossMatt_material_m2 = JSONVariables.oracalWhiteGlossMattMaterialCost// cityMaterialCost // 0.46
//    let WhiteGlossMatt_pricem2 =   JSONVariables.oracalWhiteGlossMattCostOfPrinting
  
//    let TransparentGlossMatt_material_m2 = JSONVariables.oracalTransparentGlossMattMaterialCost
//    let TransparentGlossMatt_price_m2 = JSONVariables.oracalTransparentGlossMattCostOfPrinting
//    
//    let oneWayVision_material_m2 = JSONVariables.oneWayVisionMaterialCost
//    let oneWayVision_price_m2 = JSONVariables.oneWayVisionCostOfPrinting
//    
//    //MARK: POST PRINT
//    let lamination_cold =  JSONVariables.COLD_LAM_MATERIAL
//    let work_lamination_cold = JSONVariables.COLD_LAM_WORK
  
  
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
  
    
//    if( stickersBoolVariables.withoutPostPrint == true)  {
//        print("WhiteGlossMatt + without post print")
  
      //  }
    
    
//    if( stickersBoolVariables.whiteStickerC == true && stickersBoolVariables.coldLaminationC == true)  {
//        print("WhiteGlossMatt + cold lam chosen")
//      
//      getPosterStickerPrice(title: materialTitle, materialPrice: WhiteGlossMatt_material_m2, materialPrintPrice: WhiteGlossMatt_pricem2,
//                            prepress: lamination_cold, workPrepress: work_lamination_cold)
//    }
//    
//    
//    //MARK: LOMOND MATERIAL, VARIANTS START
//    
//    if( stickersBoolVariables.transparentStickerC == true && stickersBoolVariables.withoutPostPrint == true)  {
//        print("TransparentGlossMatt + without post print")
//      
//       getPosterStickerPrice(title: materialTitle, materialPrice: TransparentGlossMatt_material_m2, materialPrintPrice: TransparentGlossMatt_price_m2,
//                             prepress: 0.0, workPrepress: 0.0)
//    }
//  
//    
//    if( stickersBoolVariables.transparentStickerC == true && stickersBoolVariables.coldLaminationC == true)  {
//        print("TransparentGlossMatt + cold lam chosen")
//      
//      getPosterStickerPrice(title: materialTitle, materialPrice: TransparentGlossMatt_material_m2, materialPrintPrice: TransparentGlossMatt_price_m2,
//                            prepress: lamination_cold, workPrepress: work_lamination_cold)
//    }
//    
//    
//    //MARK: photo paper 200gr/m2 MATERIAL, VARIANTS START
//  
//    if( stickersBoolVariables.oneWayVisionC == true && stickersBoolVariables.withoutPostPrint == true)  {
//        print("oneWayVision + without post print")
//      
//      getPosterStickerPrice(title: materialTitle, materialPrice: oneWayVision_material_m2, materialPrintPrice: oneWayVision_price_m2,
//                            prepress: 0.0, workPrepress: 0.0)
//    }
//    
//    
//    if( stickersBoolVariables.oneWayVisionC == true && stickersBoolVariables.coldLaminationC == true)  {
//        print("oneWayVision + cold lam chosen")
//      
//      getPosterStickerPrice(title: materialTitle, materialPrice: oneWayVision_material_m2, materialPrintPrice: oneWayVision_price_m2,
//                            prepress: lamination_cold, workPrepress: work_lamination_cold)
//    }
  
}// func computings()
