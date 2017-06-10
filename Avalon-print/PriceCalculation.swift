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
  var withUnderframe = false
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
  
  if( currentPageData.amountIsEmpty == true || currentPageData.widthOrHeightIsEmpty == true )  {
    
    currentPageData.price = "0"
    currentPageData.ndsPrice = "0"
   
  } else if (materialPrice == 0.0 || printPrice == 0.0) && (postPrintMaterialPrice != 0.0 || postPrintWorkPrice != 0.0) {
    
    currentPageData.price = "0"
    currentPageData.ndsPrice = "0"
  } else {
    getPosterStickerPrice (materialPrice: materialPrice, materialPrintPrice: printPrice,
                            postprint: postPrintMaterialPrice, workPostprint: postPrintWorkPrice )
    
  }
  
} //calculatePriceOfSelectedProduct()


func getPosterStickerPrice (materialPrice: Double , materialPrintPrice: Double, postprint: Double,  workPostprint: Double)  {
  
  var price = 0 //цена
  var amount = Double()
  var custom_wi = Double()
  var custom_he = Double()

  amount = currentPageData.amount.doubleValue //количество
  custom_wi = currentPageData.width.convertToDemicalIfItIsNot
  custom_he = currentPageData.height.convertToDemicalIfItIsNot
  
  
// if selected page is canvas page ======================================
  let underframePriceLengthMeter = 120.0
  let setupWorkPrice = 150.0
  
  let perimeter = (custom_he + custom_wi) * 2
  let underframePrice = perimeter * underframePriceLengthMeter

  

  var underframeSum = Double()
  
  if currentPageData.withUnderframe == false {
    underframeSum = 0.0
  } else  if currentPageData.withUnderframe && ( custom_he == 0 || custom_wi == 0 ) {
    underframeSum = 0.0
  } else {
    underframeSum = (underframePrice + setupWorkPrice) * amount
  }
  
//========================================================================
  
  let squareMeters = custom_he * custom_wi

  let currency_course = JSONVariables.USD
  let NDS = JSONVariables.NDS
  let overprice1 = JSONVariables.OVERPRICE1
  let maxPercentOfDiscount = 19
  
  
  let materialPriceM2 = materialPrice
  let materialPrintPriceM2 = materialPrintPrice
  
  ////MARK: POST PRINT
  let postprintPrice = postprint  //podramnikprice
  let workPostprintsPrice = workPostprint //natyazhkaHolsta
  
  var postprintMaterial = Double() //просчет припреса
  var postprintWork = Double()
  
  postprintMaterial = (squareMeters * postprintPrice) * amount
  postprintWork = (squareMeters * workPostprintsPrice) * amount
  
  let materialSum = materialPrintPriceM2 + materialPriceM2 * overprice1
  let postprintSum = postprintMaterial + postprintWork
  
  price = Int((currency_course * ( (postprintSum) + amount * materialSum * squareMeters)) + underframeSum )
  
  //MARK: DISCOUNT
  if(price >= 150)  { price = (price - (price * 5)/100); }
  if(price >= 2000) { price = (price - (price * 7)/100); }
  if(price >= 4000) { price = (price - (price * 10)/100); }
  if(price >= 8000) { price = (price - (price * maxPercentOfDiscount)/100); }
  
  currentPageData.price =  String(price)
  currentPageData.ndsPrice = String((price + ((price * NDS)/100) ))
}

