//
//  canvasComputing.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/22/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//

import Foundation
import UIKit
struct canvasBoolVariables {
    static var amount = ""
    static var amountDidNotInputed = true
    
    static var standartSizeDidnNotChosen = true
    static var sixH_x_NineH_C = false
    static var fiveH_x_sevenH_C = false
    static var fourH_x_fiveH_C = false
    static var threeH_x_fourH_C = false
    static var twoH_x_threeH_C = false
    
    static var canvasWidhOrHeightDidNotInputed = true
    static var canvasWidthSet = ""
    static var canvasHeightSet = ""
    
    static var withoutUnderframe = false
    static var withUnderframe = false
    
    static var priceToLabel = String()
    static var ndsPriceToLabel = String()
}


func canvasComputings () {
    
    var price = 0; //цена
    let amount = canvasBoolVariables.amount.doubleValue //количество
    var custom_wi = canvasBoolVariables.canvasWidthSet
    var custom_he = canvasBoolVariables.canvasHeightSet
    let squareMeters = custom_he.convertToDemicalIfItIsNot * custom_wi.convertToDemicalIfItIsNot
    
    
    let currency_course = JSONVariables.USD
    let NDS = JSONVariables.NDS
    let overprice1 = JSONVariables.OVERPRICE1
    
    let artCanvas_material_m2 = JSONVariables.artCanvasMaterialCost
    let artCanvas_pricem2 = JSONVariables.artCanvasCostOfPrinting

    
    let podramnikPrice = 120.0
    let natyazhkaHolsta = 150.0
    
    
    var podramnik = 0.0
    
    let maxPercentOfDiscount = 19
    
    if( (canvasBoolVariables.standartSizeDidnNotChosen == true && canvasBoolVariables.withUnderframe == true) || canvasBoolVariables.amountDidNotInputed == true ||
        canvasBoolVariables.canvasWidhOrHeightDidNotInputed == true )  {
        
        canvasBoolVariables.priceToLabel = "0"
        canvasBoolVariables.ndsPriceToLabel = "0"
    }
    
    
    if( canvasBoolVariables.withoutUnderframe == true)  {
        print("artcanvas + without underframe")
        
        let materialSum = artCanvas_pricem2 + artCanvas_material_m2 * overprice1
        price = Int(currency_course * amount * materialSum * squareMeters)
        
    }
    
    
    if( canvasBoolVariables.withUnderframe == true && canvasBoolVariables.sixH_x_NineH_C == true)  {
        print("artcanvas + with underframe 600x900")
        custom_wi = "0.600"
        custom_he = "0.900"
        podramnik = ((custom_he.doubleValue + custom_wi.doubleValue) * 2) * podramnikPrice;

        
        let materialSum = artCanvas_pricem2 + artCanvas_material_m2 * overprice1
        let squareMeters = custom_he.doubleValue * custom_wi.doubleValue
        let underframeWorkPrice = natyazhkaHolsta * amount
        let underframePrice = podramnik * amount
        
        price = Int( (currency_course * amount * materialSum * squareMeters) + (underframeWorkPrice + underframePrice) )

    }
    
    
    if( canvasBoolVariables.withUnderframe == true && canvasBoolVariables.fiveH_x_sevenH_C == true)  {
        print("artcanvas + with underframe 500x700")
        custom_wi = "0.500"
        custom_he = "0.700"
        podramnik = ((custom_he.doubleValue + custom_wi.doubleValue) * 2) * podramnikPrice;
        
        
        let materialSum = artCanvas_pricem2 + artCanvas_material_m2 * overprice1
        let squareMeters = custom_he.doubleValue * custom_wi.doubleValue
        let underframeWorkPrice = natyazhkaHolsta * amount
        let underframePrice = podramnik * amount
        
        price = Int( (currency_course * amount * materialSum * squareMeters) + (underframeWorkPrice + underframePrice) )
        
    }
    
    
    if( canvasBoolVariables.withUnderframe == true && canvasBoolVariables.fourH_x_fiveH_C == true)  {
        print("artcanvas + with underframe 400x500")
        custom_wi = "0.400"
        custom_he = "0.500"
        podramnik = ((custom_he.doubleValue + custom_wi.doubleValue) * 2) * podramnikPrice;
        
        
        let materialSum = artCanvas_pricem2 + artCanvas_material_m2 * overprice1
        let squareMeters = custom_he.doubleValue * custom_wi.doubleValue
        let underframeWorkPrice = natyazhkaHolsta * amount
        let underframePrice = podramnik * amount
        
        price = Int( (currency_course * amount * materialSum * squareMeters) + (underframeWorkPrice + underframePrice) )
        
    }
    
    
    if( canvasBoolVariables.withUnderframe == true && canvasBoolVariables.threeH_x_fourH_C == true)  {
        print("artcanvas + with underframe 300x400")
        custom_wi = "0.300"
        custom_he = "0.400"
        podramnik = ((custom_he.doubleValue + custom_wi.doubleValue) * 2) * podramnikPrice;
        
        
        let materialSum = artCanvas_pricem2 + artCanvas_material_m2 * overprice1
        let squareMeters = custom_he.doubleValue * custom_wi.doubleValue
        let underframeWorkPrice = natyazhkaHolsta * amount
        let underframePrice = podramnik * amount
        
        price = Int( (currency_course * amount * materialSum * squareMeters) + (underframeWorkPrice + underframePrice) )
        
    }

    
    if( canvasBoolVariables.withUnderframe == true && canvasBoolVariables.twoH_x_threeH_C == true)  {
        print("artcanvas + with underframe 200x300")
        custom_wi = "0.200"
        custom_he = "0.300"
        podramnik = ((custom_he.doubleValue + custom_wi.doubleValue) * 2) * podramnikPrice;
        
        
        let materialSum = artCanvas_pricem2 + artCanvas_material_m2 * overprice1
        let squareMeters = custom_he.doubleValue * custom_wi.doubleValue
        let underframeWorkPrice = natyazhkaHolsta * amount
        let underframePrice = podramnik * amount
        
        price = Int( (currency_course * amount * materialSum * squareMeters) + (underframeWorkPrice + underframePrice) )
        
    }


    //MARK: DISCOUNT
    if(price >= 150) { price = (price - (price * 5)/100); }
    
    if(price >= 2000) { price = (price - (price * 7)/100); }
    
    if(price >= 4000) { price = (price - (price * 10)/100); }
    
    if(price >= 8000) { price = (price - (price * maxPercentOfDiscount)/100); }
    
    canvasBoolVariables.priceToLabel =  String(price)
    canvasBoolVariables.ndsPriceToLabel = String((price + ((price * NDS)/100) ))
    
}
