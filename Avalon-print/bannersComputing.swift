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
  
  static var luversAmountOnOneproductSet = ""
  static var lengthPocketsSeams = ""
  
  static var priceToLabel = String()
  static var ndsPriceToLabel = ""// String()
  
  
  static var luversSetUpSwitchIsOn = false
  static var pocketSeamsSwitchIsOn = false
  //static var
  
  
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
  
////MARK: POST PRINT
//  
//  
//  
//  
//  
  
  
  //computings
  
//  false false
//  true  true
//  true  false
//  false true
  
  if( bannersBoolVariables.materialDidnNotChosen == true || bannersBoolVariables.amountDidNotInputed == true ||
    bannersBoolVariables.bannersWidhOrHeightDidNotInputed == true )  {
     print("Nothing chosen")
    
    bannersBoolVariables.priceToLabel = "0"
    bannersBoolVariables.ndsPriceToLabel = "0"
  }
  
  //lamin
  if( bannersBoolVariables.laminatedBannerC == true &&
      bannersBoolVariables.luversSetUpSwitchIsOn == false && bannersBoolVariables.pocketSeamsSwitchIsOn == false )  {
    print("Laminated banner chosen + luversSetUpSwitch Is Off + pocketSeamsSwitch Is Off")
    
    let materialSum = laminatedBannerPriceM2 + laminatedBannerMaterialM2// * overprice1
        price = Int(currency_course * amount * materialSum * squareMeters)

    
    
    
  //  bannersBoolVariables.priceToLabel = "1"
   // bannersBoolVariables.ndsPriceToLabel = "1"
  }
  
  if( bannersBoolVariables.laminatedBannerC == true &&
    bannersBoolVariables.luversSetUpSwitchIsOn == true && bannersBoolVariables.pocketSeamsSwitchIsOn == true )  {
    print("Laminated banner chosen + luversSetUpSwitch Is On + pocketSeamsSwitch Is On")
    
    bannersBoolVariables.priceToLabel = "1"
    bannersBoolVariables.ndsPriceToLabel = "1"
  }
  
  if( bannersBoolVariables.laminatedBannerC == true &&
    bannersBoolVariables.luversSetUpSwitchIsOn == true && bannersBoolVariables.pocketSeamsSwitchIsOn == false )  {
    print("Laminated banner chosen + luversSetUpSwitch Is On + pocketSeamsSwitch Is Off")
    
    bannersBoolVariables.priceToLabel = "1"
    bannersBoolVariables.ndsPriceToLabel = "1"
  }
  
  
  if( bannersBoolVariables.laminatedBannerC == true &&
    bannersBoolVariables.luversSetUpSwitchIsOn == false && bannersBoolVariables.pocketSeamsSwitchIsOn == true )  {
    print("Laminated banner chosen + luversSetUpSwitch Is Off + pocketSeamsSwitch Is On")
    
    bannersBoolVariables.priceToLabel = "1"
    bannersBoolVariables.ndsPriceToLabel = "1"
  }
  
 //===========
  
  
  
  // cast
  if( bannersBoolVariables.castBannerC == true &&
    bannersBoolVariables.luversSetUpSwitchIsOn == false && bannersBoolVariables.pocketSeamsSwitchIsOn == false )  {
    print("Cast banner chosen + luversSetUpSwitch Is Off + pocketSeamsSwitch Is Off")
    
    let materialSum = castBannerPriceM2 + castBannerMaterialM2 * overprice1
        price = Int(currency_course * amount * materialSum * squareMeters)
  }
  
  if( bannersBoolVariables.castBannerC == true &&
    bannersBoolVariables.luversSetUpSwitchIsOn == true && bannersBoolVariables.pocketSeamsSwitchIsOn == true )  {
    print("Cast banner chosen + luversSetUpSwitch Is On + pocketSeamsSwitch Is On")
    
    bannersBoolVariables.priceToLabel = "1"
    bannersBoolVariables.ndsPriceToLabel = "1"
  }
  
  if( bannersBoolVariables.castBannerC == true &&
    bannersBoolVariables.luversSetUpSwitchIsOn == true && bannersBoolVariables.pocketSeamsSwitchIsOn == false )  {
    print("Cast banner chosen + luversSetUpSwitch Is On + pocketSeamsSwitch Is Off")
    
    bannersBoolVariables.priceToLabel = "1"
    bannersBoolVariables.ndsPriceToLabel = "1"
  }
  
  
  if( bannersBoolVariables.castBannerC == true &&
    bannersBoolVariables.luversSetUpSwitchIsOn == false && bannersBoolVariables.pocketSeamsSwitchIsOn == true )  {
    print("Cast banner chosen + luversSetUpSwitch Is Off + pocketSeamsSwitch Is On")
    
    bannersBoolVariables.priceToLabel = "1"
    bannersBoolVariables.ndsPriceToLabel = "1"
  }
  
  
//=====
  
  //backlit
  
  if( bannersBoolVariables.backlitC == true &&
    bannersBoolVariables.luversSetUpSwitchIsOn == false && bannersBoolVariables.pocketSeamsSwitchIsOn == false )  {
    print("Backlit banner chosen + luversSetUpSwitch Is Off + pocketSeamsSwitch Is Off")
    
    let materialSum = backlitBannerPriceM2 + backlitBannerMaterialM2 * overprice1
        price = Int(currency_course * amount * materialSum * squareMeters)

  }
  
  if( bannersBoolVariables.backlitC == true &&
    bannersBoolVariables.luversSetUpSwitchIsOn == true && bannersBoolVariables.pocketSeamsSwitchIsOn == true )  {
    print("Backlit banner chosen + luversSetUpSwitch Is On + pocketSeamsSwitch Is On")
    
    bannersBoolVariables.priceToLabel = "1"
    bannersBoolVariables.ndsPriceToLabel = "1"
  }
  
  if( bannersBoolVariables.backlitC == true &&
    bannersBoolVariables.luversSetUpSwitchIsOn == true && bannersBoolVariables.pocketSeamsSwitchIsOn == false )  {
    print("Backlit banner chosen + luversSetUpSwitch Is On + pocketSeamsSwitch Is Off")
    
    bannersBoolVariables.priceToLabel = "1"
    bannersBoolVariables.ndsPriceToLabel = "1"
  }
  
  
  if( bannersBoolVariables.backlitC == true &&
    bannersBoolVariables.luversSetUpSwitchIsOn == false && bannersBoolVariables.pocketSeamsSwitchIsOn == true )  {
    print("Backlit banner chosen + luversSetUpSwitch Is Off + pocketSeamsSwitch Is On")
    
    bannersBoolVariables.priceToLabel = "1"
    bannersBoolVariables.ndsPriceToLabel = "1"
  }

  //==========
  
  
  //mesh
  if( bannersBoolVariables.meshC == true &&
    bannersBoolVariables.luversSetUpSwitchIsOn == false && bannersBoolVariables.pocketSeamsSwitchIsOn == false )  {
    print("Mesh banner chosen + luversSetUpSwitch Is Off + pocketSeamsSwitch Is Off")
    
    bannersBoolVariables.priceToLabel = "1"
    bannersBoolVariables.ndsPriceToLabel = "1"
  }
  
  if( bannersBoolVariables.meshC == true &&
    bannersBoolVariables.luversSetUpSwitchIsOn == true && bannersBoolVariables.pocketSeamsSwitchIsOn == true )  {
    print("Mesh banner chosen + luversSetUpSwitch Is On + pocketSeamsSwitch Is On")
    
    bannersBoolVariables.priceToLabel = "1"
    bannersBoolVariables.ndsPriceToLabel = "1"
  }
  
  if( bannersBoolVariables.meshC == true &&
    bannersBoolVariables.luversSetUpSwitchIsOn == true && bannersBoolVariables.pocketSeamsSwitchIsOn == false )  {
    print("Mesh banner chosen + luversSetUpSwitch Is On + pocketSeamsSwitch Is Off")
    
    bannersBoolVariables.priceToLabel = "1"
    bannersBoolVariables.ndsPriceToLabel = "1"
  }
  
  
  if( bannersBoolVariables.meshC == true &&
    bannersBoolVariables.luversSetUpSwitchIsOn == false && bannersBoolVariables.pocketSeamsSwitchIsOn == true )  {
    print("Mesh banner chosen + luversSetUpSwitch Is Off + pocketSeamsSwitch Is On")
    
    bannersBoolVariables.priceToLabel = "1"
    bannersBoolVariables.ndsPriceToLabel = "1"
  }

  //=====


  //MARK: DISCOUNT
   if(price >= 150) { price = (price - (price * 5)/100); }
  
  if(price >= 2000) { price = (price - (price * 7)/100); }
  
  if(price >= 4000) { price = (price - (price * 10)/100); }
  
  if(price >= 8000) { price = (price - (price * maxPercentOfDiscount)/100); }
  
  
    bannersBoolVariables.priceToLabel =  String(price)
    bannersBoolVariables.ndsPriceToLabel = String((price + ((price * NDS)/100) ))
  

}

