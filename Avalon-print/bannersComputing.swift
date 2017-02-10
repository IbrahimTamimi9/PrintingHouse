//
//  bannersComputing.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/22/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//

import Foundation
 

struct bannersBoolVariables {
  static var amount = ""
  static var amountDidNotInputed = true
  
  static var materialDidnNotChosen = true
  static var laminatedBannerC = false
  static var castBannerC = false
  static var backlitC = false
  static var meshC = false
  
  static var bannersWidhOrHeightDidNotInputed = true
  static var bannersWidthSet = ""
  static var bannersHeightSet = ""
  
  static var distanceBetweenLuversSet = ""
  static var luversAmountOnOneproductSet = ""
  static var lengthPocketsSeams = ""
  
  
//  static var withoutPostPrint = false
//  static var coldLaminationC = false
  
  static var priceToLabel = String()
  static var ndsPriceToLabel = ""// String()
  
}

func bannersComputings () {
  
  //MARK:INSIDE INITIALIZING VARS
  var price = 0; //цена
  let amount = bannersBoolVariables.amount.doubleValue //количество
  
  let custom_wi = bannersBoolVariables.bannersWidthSet.convertToDemicalIfItIsNot
  let custom_he = bannersBoolVariables.bannersHeightSet.convertToDemicalIfItIsNot
  let squareMeters = custom_he * custom_wi
  
  let maxPercentOfDiscount = 19

  
  //MARK: INITIALIZING FROM JSON
  //MARK: GENERAL
  let currency_course = JSONVariables.USD
  let NDS = JSONVariables.NDS
  let overprice1 = JSONVariables.OVERPRICE1
 

  //MARK: MATERIALS
  let laminatedBannerMaterialM2 = JSONVariables.laminatedBannerMaterialCost
  let laminatedBannerPriceM2 = JSONVariables.laminatedBannerCostOfPrinting
  
  let castBannerMaterialM2 = JSONVariables.castBannerMaterialCost
  let castBannerPriceM2 = JSONVariables.castBannerCostOfPrinting
  
  let backlitBannerMaterialM2 = JSONVariables.backlitBannerMaterialCost
  let backlitBannerPriceM2 = JSONVariables.backlitBannerCostOfPrinting
  
  let meshBannerMaterialM2 = JSONVariables.meshBannerMaterialCost
  let meshBannerPriceM2 = JSONVariables.meshBannerCostOfPrinting
  
//MARK: POST PRINT

}

