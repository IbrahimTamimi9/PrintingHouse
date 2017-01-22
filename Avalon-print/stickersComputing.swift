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
    
    static var materialDidnNotChosen = true
    static var whiteStickerC = false
    static var transparentStickerC = false
    static var oneWayVisionC = false
    
    static var stickersWidhOrHeightDidNotInputed = true
    static var stickersWidthSet = ""
    static var stickersHeightSet = ""
    
    static var withoutPostPrint = false
    static var coldLaminationC = false
    
    static var priceToLabel = String()
    static var ndsPriceToLabel = String()
    
}

func stickersComputings() {
    
    //MARK:INSIDE INITIALIZING VARS
    var price = 0; //цена
    let amount = stickersBoolVariables.amount.doubleValue //количество
    
    let custom_wi = stickersBoolVariables.stickersWidthSet.convertToDemicalIfItIsNot
    let custom_he = stickersBoolVariables.stickersHeightSet.convertToDemicalIfItIsNot
    let squareMeters = custom_he * custom_wi
    
    var coldLam = Double() //просчет припреса
    var work_coldLam = Double()
    
    let maxPercentOfDiscount = 19
    //
    
    
    //MARK: INITIALIZING FROM JSON
    //MARK: GENERAL
    let currency_course = JSONVariables.USD
    let NDS = JSONVariables.NDS
    let overprice1 = JSONVariables.OVERPRICE1
    //double ovp_2 = 1.4;
    
    
    //MARK: MATERIALS
    let WhiteGlossMatt_material_m2 = JSONVariables.oracalWhiteGlossMattMaterialCost// cityMaterialCost // 0.46
    let WhiteGlossMatt_pricem2 =   JSONVariables.oracalWhiteGlossMattCostOfPrinting
    
    let TransparentGlossMatt_material_m2 = JSONVariables.oracalTransparentGlossMattMaterialCost
    let TransparentGlossMatt_price_m2 = JSONVariables.oracalTransparentGlossMattCostOfPrinting
    
    let oneWayVision_material_m2 = JSONVariables.oneWayVisionMaterialCost
    let oneWayVision_price_m2 = JSONVariables.oneWayVisionCostOfPrinting
    
    //MARK: POST PRINT
    let lamination_cold =  JSONVariables.COLD_LAM_MATERIAL
    let work_lamination_cold = JSONVariables.COLD_LAM_WORK
    
    
    
    //MARK: CITY MATERIAL, VARIANTS START
    if( stickersBoolVariables.materialDidnNotChosen == true || stickersBoolVariables.amountDidNotInputed == true ||
        stickersBoolVariables.stickersWidhOrHeightDidNotInputed == true )  {
        
        stickersBoolVariables.priceToLabel = "0"
        stickersBoolVariables.ndsPriceToLabel = "0"
    }
    
    
    
    if( stickersBoolVariables.whiteStickerC == true && stickersBoolVariables.withoutPostPrint == true)  {
        print("WhiteGlossMatt + without post print")
        
        let materialSum = WhiteGlossMatt_pricem2 + WhiteGlossMatt_material_m2 //* overprice1
            price = Int(currency_course * amount * materialSum * squareMeters)
        
    }
    
    
    if( stickersBoolVariables.whiteStickerC == true && stickersBoolVariables.coldLaminationC == true)  {
        print("WhiteGlossMatt + cold lam chosen")
        
        let materialSum = WhiteGlossMatt_pricem2 + WhiteGlossMatt_material_m2 //* overprice1
            coldLam =  (squareMeters * lamination_cold) * amount;
            work_coldLam =  (squareMeters * work_lamination_cold) * amount;
        
        let prepressSum = coldLam + work_coldLam
        
            price = Int(currency_course * (prepressSum + amount * materialSum * squareMeters))
        
    }
    
    
    
    //MARK: LOMOND MATERIAL, VARIANTS START
    
    
    if( stickersBoolVariables.transparentStickerC == true && stickersBoolVariables.withoutPostPrint == true)  {
        print("TransparentGlossMatt + without post print")
        
        let materialSum = TransparentGlossMatt_price_m2 + TransparentGlossMatt_material_m2// * overprice1
            price = Int(currency_course * amount * materialSum * squareMeters)
    }
    
    
    
    if( stickersBoolVariables.transparentStickerC == true && stickersBoolVariables.coldLaminationC == true)  {
        print("TransparentGlossMatt + cold lam chosen")
        
        let materialSum = TransparentGlossMatt_price_m2 + TransparentGlossMatt_material_m2// * overprice1
            coldLam =  (squareMeters * lamination_cold) * amount;
            work_coldLam =  (squareMeters * work_lamination_cold) * amount;
        
        let prepressSum = coldLam + work_coldLam

            price = Int(currency_course * (prepressSum + amount * materialSum * squareMeters))
        
    }
    
    
    //MARK: photo paper 200gr/m2 MATERIAL, VARIANTS START
    
    
    if( stickersBoolVariables.oneWayVisionC == true && stickersBoolVariables.withoutPostPrint == true)  {
        print("oneWayVision + without post print")
        
        let materialSum = oneWayVision_price_m2 + oneWayVision_material_m2  * overprice1
            price = Int(currency_course * amount * materialSum * squareMeters)
        
    }
    
    
    if( stickersBoolVariables.oneWayVisionC == true && stickersBoolVariables.coldLaminationC == true)  {
        print("oneWayVision + cold lam chosen")
        
        let materialSum = oneWayVision_price_m2 + oneWayVision_material_m2  * overprice1
            coldLam =  (squareMeters * lamination_cold) * amount;
            work_coldLam =  (squareMeters * work_lamination_cold) * amount;
        
        let prepressSum = coldLam + work_coldLam
        
            price = Int(currency_course * (prepressSum + amount * materialSum * squareMeters))
        
    }
    
    
    //MARK: DISCOUNT
    if(price >= 150) { price = (price - (price * 5)/100); }
    
    if(price >= 2000) { price = (price - (price * 7)/100); }
    
    if(price >= 4000) { price = (price - (price * 10)/100); }
    
    if(price >= 8000) { price = (price - (price * maxPercentOfDiscount)/100); }
    

    stickersBoolVariables.priceToLabel =  String(price)
    stickersBoolVariables.ndsPriceToLabel = String((price + ((price * NDS)/100) ))

    
}// func computings()
