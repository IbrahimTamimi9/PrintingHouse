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

 let priceLocalizedLabel = NSLocalizedString("PriceCalculation.priceLocalizedLabel", comment: "")
 let ndsPriceLocalizedLabel = NSLocalizedString("PriceCalculation.ndsPriceLocalizedLabel", comment: "")
 let currencyTypeLocalizedLabel = NSLocalizedString("PriceCalculation.currencyTypeLocalizedLabel", comment: "")

var currentPageData = currentPageDataStatus()



struct currentPageDataStatus {
  
  //var amountIsEmpty = true
  //var widthOrHeightIsEmpty = true
  var viewControllersPriceBlock = PriceAndAddToCartView()
  var viewControllersLayoutBlock = LayoutSelectionView()
  var withUnderframe = false
  
  var luversAmount = ""
  var pocketsLength = ""
  
  var amount = ""
  var width = ""
  var height = ""
  
  var price = "0" {
        didSet {
        viewControllersPriceBlock.price.text = "\(priceLocalizedLabel): \(price) \(currencyTypeLocalizedLabel).\n\(ndsPriceLocalizedLabel): \(ndsPrice) \(currencyTypeLocalizedLabel)."
        }
      }
  
  var ndsPrice = "0" {
    didSet {
      viewControllersPriceBlock.price.text = "\(priceLocalizedLabel): \(price) \(currencyTypeLocalizedLabel).\n\(ndsPriceLocalizedLabel): \(ndsPrice) \(currencyTypeLocalizedLabel)."
    }
  }

  
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
  
if (materialPrice == 0.0 || printPrice == 0.0) && (postPrintMaterialPrice != 0.0 || postPrintWorkPrice != 0.0) {
   
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
  
  // for banners
  let pocketsLength = currentPageData.pocketsLength.convertToDemicalIfItIsNot //
  let luversAmount = currentPageData.luversAmount.convertToDemicalIfItIsNot//
  let luversPrice = priceData.luversPrice
  let pocketsPrice = priceData.pocketsPrice
  var bannersPostPrintSum = Double()
  
  if custom_he == 0.0 || custom_wi == 0.0 {
    bannersPostPrintSum = 0.0
  } else {
    bannersPostPrintSum = ((pocketsLength * pocketsPrice) + (luversAmount * luversPrice)) * amount
  }
  
  //
  
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

  let currency_course = generalDataForCalculations.USD
  let NDS = generalDataForCalculations.NDS
  let overprice1 = generalDataForCalculations.OVERPRICE1
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
  
  price = Int((currency_course * ( (postprintSum) + amount * materialSum * squareMeters)) + underframeSum + bannersPostPrintSum)
  
  //MARK: DISCOUNT
  if(price >= 150)  { price = (price - (price * 5)/100); }
  if(price >= 2000) { price = (price - (price * 7)/100); }
  if(price >= 4000) { price = (price - (price * 10)/100); }
  if(price >= 8000) { price = (price - (price * maxPercentOfDiscount)/100); }
  
  currentPageData.price =  String(price)
  currentPageData.ndsPrice = String((price + ((price * NDS)/100) ))
  chooseAddToCartButtonState()
}


func chooseAddToCartButtonState () {
  
  let priceBlock = currentPageData.viewControllersPriceBlock
  let layoutBlock = currentPageData.viewControllersLayoutBlock
  
  
  if priceBlock.addToCart.titleLabel?.text == priceBlock.addToCartButtonTitleAfterTapping {
    priceBlock.addToCart.setTitle(priceBlock.addToCartButtonTitleBeforeTapping, for: .normal)
  }
  

  if currentPageData.price == "0" {
    
    priceBlock.addToCart.isEnabled = false
  
  } else {
    
    if layoutBlock.layout.image == nil &&
      !layoutBlock.layoutDevSwitch.isOn &&
       layoutBlock.layoutLinkField.text == "" {
      
       priceBlock.addToCart.isEnabled  = false
      
    } else {
    
      priceBlock.addToCart.isEnabled = true
    }
  }
 
}







