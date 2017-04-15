//
//  PriceCalculation.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 4/15/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import Foundation

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


var currentPageData = currentPageDataStatus()

struct currentPageDataStatus {
  
  var amountIsEmpty = true
  var widthOrHeightIsEmpty = true
  var amount = ""
  var width = ""
  var height = ""
  var price = "0"
  var ndsPrice = "0"
  
  mutating func resetDataBeforeChangingPage() {
    
    self = currentPageDataStatus()
    
  }
  
}


func calculatePriceOfSelectedProduct() {
  
  //MARK: MATERIALS
  let materialPrice = priceData.materialPrice
  let printPrice = priceData.printPrice
  
  //MARK: POST PRINT
  let postPrintMaterialPrice = priceData.postPrintMaterialPrice
  let postPrintWorkPrice = priceData.postPrintWorkPrice
  
  //MARK: CITY MATERIAL, VARIANTS START
  if( currentPageData.amountIsEmpty == true || currentPageData.widthOrHeightIsEmpty == true )  {
    
    currentPageData.price = "0"
    currentPageData.ndsPrice = "0"
    
  } else if (materialPrice == 0.0 || printPrice == 0.0) && (postPrintMaterialPrice != 0.0 || postPrintWorkPrice != 0.0) {
    
    currentPageData.price = "0"
    currentPageData.ndsPrice = "0"
  } else {
    getPosterStickerPrice ( materialPrice: materialPrice, materialPrintPrice: printPrice,
                            prepress: postPrintMaterialPrice, workPrepress: postPrintWorkPrice )
    
  }
  
} //calculatePriceOfSelectedProduct()


func getPosterStickerPrice ( materialPrice: Double , materialPrintPrice: Double, prepress: Double,  workPrepress: Double)  {
  
  var price = 0 //цена
  var amount = Double()
  var custom_wi = Double()
  var custom_he = Double()
  
  
  amount = currentPageData.amount.doubleValue //количество
  custom_wi = currentPageData.width.convertToDemicalIfItIsNot
  custom_he = currentPageData.height.convertToDemicalIfItIsNot
  
  
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
  
  currentPageData.price =  String(price)
  currentPageData.ndsPrice = String((price + ((price * NDS)/100) ))
  
}

