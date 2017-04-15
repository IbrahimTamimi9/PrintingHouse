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



func getCanvasPrice ( materialPrice: Double, materialPrintPrice: Double,
                      natyazhkaHolsta: Double, podramnikPrice: Double,
                      width: Double, height: Double )  {
  
  var price = 0; //цена
  var podramnik = 0.0
  let amount = canvasBoolVariables.amount.doubleValue //количество
  let custom_wi = width
  let custom_he = height
  let squareMeters = custom_he * custom_wi
  
  let currency_course = JSONVariables.USD
  let NDS = JSONVariables.NDS
  let overprice1 = JSONVariables.OVERPRICE1
  let maxPercentOfDiscount = 19
  
  let materialPriceM2 = materialPrice
  let materialPrintPriceM2 = materialPrintPrice
 
       podramnik = ((custom_he + custom_wi) * 2) * podramnikPrice
  
   let materialSum = materialPrintPriceM2 + materialPriceM2 * overprice1
  
   let underframePrice = (natyazhkaHolsta * amount) + (podramnik * amount)
  
       price = Int((currency_course * amount * materialSum * squareMeters)  + (underframePrice))

  //MARK: DISCOUNT
  if(price >= 150)  { price = (price - (price * 5)/100); }
  if(price >= 2000) { price = (price - (price * 7)/100); }
  if(price >= 4000) { price = (price - (price * 10)/100); }
  if(price >= 8000) { price = (price - (price * maxPercentOfDiscount)/100); }

  canvasBoolVariables.priceToLabel =  String(price)
  canvasBoolVariables.ndsPriceToLabel = String((price + ((price * NDS)/100) ))
  
}


func canvasComputings () {
    
    var custom_wi = canvasBoolVariables.canvasWidthSet.convertToDemicalIfItIsNot
    var custom_he = canvasBoolVariables.canvasHeightSet.convertToDemicalIfItIsNot
  
    let artCanvas_material_m2 = JSONVariables.artCanvasMaterialCost
    let artCanvas_pricem2 = JSONVariables.artCanvasCostOfPrinting

    let natyazhkaHolsta = 150.0
    let podramnikPrice = 120.0
  
    
    if(( canvasBoolVariables.standartSizeDidnNotChosen == true && canvasBoolVariables.withUnderframe == true) ||
         canvasBoolVariables.amountDidNotInputed == true ||
         canvasBoolVariables.canvasWidhOrHeightDidNotInputed == true )  {
        
         canvasBoolVariables.priceToLabel = "0"
         canvasBoolVariables.ndsPriceToLabel = "0"
    }
    
    
    if( canvasBoolVariables.withoutUnderframe == true)  {
        print("artcanvas + without underframe")
      
        getCanvasPrice ( materialPrice: artCanvas_material_m2, materialPrintPrice: artCanvas_pricem2,
                         natyazhkaHolsta: 0.0, podramnikPrice: 0.0,
                         width: custom_wi, height: custom_he )
    }
    
    
    if( canvasBoolVariables.withUnderframe == true && canvasBoolVariables.sixH_x_NineH_C == true)  {
        print("artcanvas + with underframe 600x900")
        custom_wi = 0.600
        custom_he = 0.900


        getCanvasPrice ( materialPrice: artCanvas_material_m2, materialPrintPrice: artCanvas_pricem2,
                         natyazhkaHolsta: natyazhkaHolsta, podramnikPrice: podramnikPrice,
                         width: custom_wi, height: custom_he)
    }
    
    
    if( canvasBoolVariables.withUnderframe == true && canvasBoolVariables.fiveH_x_sevenH_C == true)  {
        print("artcanvas + with underframe 500x700")
        custom_wi = 0.500
        custom_he = 0.700

        getCanvasPrice ( materialPrice: artCanvas_material_m2, materialPrintPrice: artCanvas_pricem2,
                         natyazhkaHolsta: natyazhkaHolsta, podramnikPrice: podramnikPrice,
                         width: custom_wi, height: custom_he)
    }
    
    
    if( canvasBoolVariables.withUnderframe == true && canvasBoolVariables.fourH_x_fiveH_C == true)  {
        print("artcanvas + with underframe 400x500")
        custom_wi = 0.400
        custom_he = 0.500
      
        getCanvasPrice ( materialPrice: artCanvas_material_m2, materialPrintPrice: artCanvas_pricem2,
                         natyazhkaHolsta: natyazhkaHolsta, podramnikPrice: podramnikPrice,
                         width: custom_wi, height: custom_he)
    }
    
    
    if( canvasBoolVariables.withUnderframe == true && canvasBoolVariables.threeH_x_fourH_C == true)  {
        print("artcanvas + with underframe 300x400")
        custom_wi = 0.300
        custom_he = 0.400
      
        getCanvasPrice ( materialPrice: artCanvas_material_m2, materialPrintPrice: artCanvas_pricem2,
                         natyazhkaHolsta: natyazhkaHolsta, podramnikPrice: podramnikPrice,
                         width: custom_wi, height: custom_he)
    }

    
    if( canvasBoolVariables.withUnderframe == true && canvasBoolVariables.twoH_x_threeH_C == true)  {
        print("artcanvas + with underframe 200x300")
        custom_wi = 0.200
        custom_he = 0.300
      
        getCanvasPrice ( materialPrice: artCanvas_material_m2 , materialPrintPrice: artCanvas_pricem2,
                         natyazhkaHolsta: natyazhkaHolsta, podramnikPrice: podramnikPrice,
                         width: custom_wi, height: custom_he)
    }
}
