//
//  JSONReading.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/8/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
// 

import Foundation
import Firebase

struct JSONVariables {
    static var USD = Double()
    static var NDS = Int()
    static var OVERPRICE1 = Double()
    
    //MARK: PAPER
    static var cityMaterialCost = Double()
    static var cityCostOfPrinting = Double()
    static var lomondMaterialCost = Double()
    static var lomondCostOfPrinting = Double()
    static var photo200MaterialCost = Double()
    static var photo200CostOfPrinting = Double()
    //MARK: STICKERS
    static var oracalWhiteGlossMattMaterialCost = Double()
    static var oracalWhiteGlossMattCostOfPrinting = Double()
    static var oracalTransparentGlossMattMaterialCost = Double()
    static var oracalTransparentGlossMattCostOfPrinting = Double()
    static var oneWayVisionMaterialCost = Double()
    static var oneWayVisionCostOfPrinting = Double()
    //MARK: CANVAS
    static var artCanvasMaterialCost = Double()
    static var artCanvasCostOfPrinting = Double()
    //MARK: POSTPRINT
    static var GLOSS1_0_MATERIAL = Double()
    static var GLOSS1_0_WORK = Double()
    static var MAT1_0_MATERIAL = Double()
    static var MAT1_0_WORK = Double()
    static var GLOSS1_1_MATERIAL = Double()
    static var GLOSS1_1_WORK = Double()
    static var MAT1_1_MATERIAL = Double()
    static var MAT1_1_WORK = Double()
    static var COLD_LAM_MATERIAL = Double()
    static var COLD_LAM_WORK = Double()
    
}


func getVariablesFromJSON () {
  
  var ref: FIRDatabaseReference!
      ref = FIRDatabase.database().reference()
 
  
  ref.child("GeneralData").observe(.value, with: { (snapshot) in
    
    let generalBlock = snapshot.value as? NSDictionary
    
    let USDBlock = generalBlock?["USD"] as? NSDictionary
    let NDSBlock = generalBlock?["NDS"] as? NSDictionary
    let Overprice1Block = generalBlock?["Overprice1"] as? NSDictionary
    
    JSONVariables.USD = (USDBlock?["Value"] as? String ?? "").doubleValue
    JSONVariables.NDS = Int((NDSBlock?["Value"] as? String ?? "").intValue)
    JSONVariables.OVERPRICE1 = (Overprice1Block?["Value"] as? String ?? "").doubleValue
  
  }) { (error) in
    print(error.localizedDescription)
  }
  
  
  ref.child("MaterialsData").observe(.value, with: { (snapshot) in
    
    let MaterialsDataBlock = snapshot.value as? NSDictionary
    let citylightBlock = MaterialsDataBlock?["CityLight"] as? NSDictionary
    let lomondBlock = MaterialsDataBlock?["Lomond"] as? NSDictionary
    let photoPaperBlock = MaterialsDataBlock?["photoPaper200"] as? NSDictionary
    let stickersWhiteBlock = MaterialsDataBlock?["StickerWhiteGlossMatt"] as? NSDictionary
    let stickersTransparentBlock = MaterialsDataBlock?["StickerTransparentGlossMatt"] as? NSDictionary
    let oneWayVisionBlock = MaterialsDataBlock?["StickerOneWayVision"] as? NSDictionary
    let artCanvasBlock = MaterialsDataBlock?["ArtCanvas"] as? NSDictionary
    
    
    JSONVariables.cityMaterialCost = (citylightBlock?["material_Cost"] as? String ?? "").doubleValue
    JSONVariables.cityCostOfPrinting = (citylightBlock?["cost_of_Printing"] as? String ?? "").doubleValue
    
    JSONVariables.lomondMaterialCost = (lomondBlock?["material_Cost"] as? String ?? "").doubleValue
    JSONVariables.lomondCostOfPrinting = (lomondBlock?["cost_of_Printing"] as? String ?? "").doubleValue

    JSONVariables.photo200MaterialCost = (photoPaperBlock?["material_Cost"] as? String ?? "").doubleValue
    JSONVariables.photo200CostOfPrinting = (photoPaperBlock?["cost_of_Printing"] as? String ?? "").doubleValue

    JSONVariables.oracalWhiteGlossMattMaterialCost = (stickersWhiteBlock?["material_Cost"] as? String ?? "").doubleValue
    JSONVariables.oracalWhiteGlossMattCostOfPrinting = (stickersWhiteBlock?["cost_of_Printing"] as? String ?? "").doubleValue

    JSONVariables.oracalTransparentGlossMattMaterialCost = (stickersTransparentBlock?["material_Cost"] as? String ?? "").doubleValue
    JSONVariables.oracalTransparentGlossMattCostOfPrinting = (stickersTransparentBlock?["cost_of_Printing"] as? String ?? "").doubleValue

    JSONVariables.oneWayVisionMaterialCost = (oneWayVisionBlock?["material_Cost"] as? String ?? "").doubleValue
    JSONVariables.oneWayVisionCostOfPrinting = (oneWayVisionBlock?["cost_of_Printing"] as? String ?? "").doubleValue

    JSONVariables.artCanvasMaterialCost = (artCanvasBlock?["material_Cost"] as? String ?? "").doubleValue
    JSONVariables.artCanvasCostOfPrinting = (artCanvasBlock?["cost_of_Printing"] as? String ?? "").doubleValue

  }) { (error) in
    print(error.localizedDescription)
  }

  
  ref.child("PostPrintData").observe(.value, with: { (snapshot) in
    
    let PostPrintDataBlock = snapshot.value as? NSDictionary
    
    let gloss1_0Block = PostPrintDataBlock?["prepressGloss1_0"] as? NSDictionary
    let gloss1_1Block = PostPrintDataBlock?["prepressGloss1_1"] as? NSDictionary
    let matt1_0Block = PostPrintDataBlock?["prepressMatt1_0"] as? NSDictionary
    let matt1_1Block = PostPrintDataBlock?["prepressMatt1_1"] as? NSDictionary
    let coldBlock = PostPrintDataBlock?["prepressCold"] as? NSDictionary
    
    JSONVariables.GLOSS1_0_WORK = (gloss1_0Block?["cost_of_Work"] as? String ?? "").doubleValue
    JSONVariables.GLOSS1_0_MATERIAL = (gloss1_0Block?["material_Cost"] as? String ?? "").doubleValue
    
    JSONVariables.GLOSS1_1_WORK = (gloss1_1Block?["cost_of_Work"] as? String ?? "").doubleValue
    JSONVariables.GLOSS1_1_MATERIAL = (gloss1_1Block?["material_Cost"] as? String ?? "").doubleValue
    
    JSONVariables.MAT1_0_WORK = (matt1_0Block?["cost_of_Work"] as? String ?? "").doubleValue
    JSONVariables.MAT1_0_MATERIAL = (matt1_0Block?["material_Cost"] as? String ?? "").doubleValue
    
    JSONVariables.MAT1_1_WORK = (matt1_1Block?["cost_of_Work"] as? String ?? "").doubleValue
    JSONVariables.MAT1_1_MATERIAL = (matt1_1Block?["material_Cost"] as? String ?? "").doubleValue
    
    JSONVariables.COLD_LAM_WORK = (coldBlock?["cost_of_Work"] as? String ?? "").doubleValue
    JSONVariables.COLD_LAM_MATERIAL = (coldBlock?["material_Cost"] as? String ?? "").doubleValue
    
  }) { (error) in
    print(error.localizedDescription)
  }
  
}
