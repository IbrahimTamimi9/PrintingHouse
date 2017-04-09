//
//  postersComputing.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/4/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.


import Foundation
import UIKit


extension String {
    var doubleValue: Double {
        return Double(self) ?? 0
    }
    
}

extension String {
    var intValue: Int {
        return Int(self) ?? 0
    }
}

//MARK: SHOWS IF ELEMENTS IN postersVC.swift SELECTED OR NOT
struct postersBoolVariables {
    static var amount = ""
    static var amountDidNotInputed = true

   static var postersWidhOrHeightDidNotInputed = true
   static var postersWidthSet = ""
   static var postersHeightSet = ""
  
   static var priceToLabel = String()
   static var ndsPriceToLabel = String()
  
}

func getPosterStickerPrice (title: String, materialPrice: Double , materialPrintPrice: Double, prepress: Double,  workPrepress: Double)  {
  
  var price = 0 //цена
  var amount = Double()
  var custom_wi = Double()
  var custom_he = Double()
  
  if title == "Posters" {
     amount = postersBoolVariables.amount.doubleValue //количество
     custom_wi = postersBoolVariables.postersWidthSet.convertToDemicalIfItIsNot
     custom_he = postersBoolVariables.postersHeightSet.convertToDemicalIfItIsNot
  }
  
  if title == "Stickers" {
     amount = stickersBoolVariables.amount.doubleValue //количество
     custom_wi = stickersBoolVariables.stickersWidthSet.convertToDemicalIfItIsNot
     custom_he = stickersBoolVariables.stickersHeightSet.convertToDemicalIfItIsNot
  }
  
  let squareMeters = custom_he * custom_wi
  
  let currency_course = JSONVariables.USD
  let NDS = JSONVariables.NDS
  let overprice1 = JSONVariables.OVERPRICE1
  let maxPercentOfDiscount = 19

  
  let materialPriceM2 = materialPrice
  let materialPrintPriceM2 = materialPrintPrice
  
  ////MARK: POST PRINT
  let prepressPrice =  prepress
  let workPrepressPrice = workPrepress
  
  var prepressMaterial = Double() //просчет припреса
  var prepressWork = Double()
  
  
      prepressMaterial = (squareMeters * prepressPrice) * amount
      prepressWork = (squareMeters * workPrepressPrice) * amount
  
  let materialSum = materialPrintPriceM2 + materialPriceM2 * overprice1
  let prepressSum = prepressMaterial + prepressWork
  
      price = Int(currency_course * ( (prepressSum) + amount * materialSum * squareMeters))
  
  
  //MARK: DISCOUNT
  if(price >= 150)  { price = (price - (price * 5)/100); }
  if(price >= 2000) { price = (price - (price * 7)/100); }
  if(price >= 4000) { price = (price - (price * 10)/100); }
  if(price >= 8000) { price = (price - (price * maxPercentOfDiscount)/100); }
  
  
  if title == "Posters" {
     postersBoolVariables.priceToLabel =  String(price)
     postersBoolVariables.ndsPriceToLabel = String((price + ((price * NDS)/100) ))
  }
  
  if title == "Stickers" {
     stickersBoolVariables.priceToLabel =  String(price)
     stickersBoolVariables.ndsPriceToLabel = String((price + ((price * NDS)/100) ))
  }
  
  
}



    func computings() {
      
      let materialTitle = "Posters"
    
        //MARK: MATERIALS
      let materialPrice = priceData.materialPrice
      let printPrice = priceData.printPrice
      
      //MARK: POST PRINT
      let postPrintMaterialPrice = priceData.postPrintMaterialPrice
      let postPrintWorkPrice = priceData.postPrintWorkPrice
    
      
         //MARK: CITY MATERIAL, VARIANTS START
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
      
      
    }// func computings()
