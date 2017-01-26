//
//  JSONReading.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/8/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
// 

import Foundation
import UIKit

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


func getVariablesFromJSON() {
    
    let url = URL(string: "http://mizin-dev.com/data.json")
    let urlGeneral = URL(string: "http://mizin-dev.com/GeneralData.json")
    let urlPostPrint = URL(string: "http://mizin-dev.com/PostprintWorks.json")
    
    
    let taskPostPrint = URLSession.shared.dataTask(with: urlPostPrint!)  {( data, response, error) in
        if error != nil {
            print("ERROR")
           
        } else if let content = data {
                do {
                    
                    let myJsonPostPrint = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    if let gloss1_0 = myJsonPostPrint["prepressGloss1_0"] as? NSDictionary {
                        JSONVariables.GLOSS1_0_MATERIAL = (gloss1_0["material_Cost"] as! NSString).doubleValue
                        JSONVariables.GLOSS1_0_WORK = (gloss1_0["cost_of_Work"] as! NSString).doubleValue
                        
                        print("GLOSS 1 0 MATERIAL",  JSONVariables.GLOSS1_0_MATERIAL)
                        print("GLOSS 1 0 WORK",  JSONVariables.GLOSS1_0_WORK)
                    }
                    
                    if let mat1_0 = myJsonPostPrint["prepressMatt1_0"] as? NSDictionary {
                        JSONVariables.MAT1_0_MATERIAL = (mat1_0["material_Cost"] as! NSString).doubleValue
                        JSONVariables.MAT1_0_WORK = (mat1_0["cost_of_Work"] as! NSString).doubleValue
                        
                        print("mat 1 0 MATERIAL",  JSONVariables.MAT1_0_MATERIAL)
                        print("mat 1 0 WORK",  JSONVariables.MAT1_0_WORK)
                    }
                    
                    if let gloss1_1 = myJsonPostPrint["prepressGloss1_1"] as? NSDictionary {
                        JSONVariables.GLOSS1_1_MATERIAL = (gloss1_1["material_Cost"] as! NSString).doubleValue
                        JSONVariables.GLOSS1_1_WORK = (gloss1_1["cost_of_Work"] as! NSString).doubleValue
                        
                        print("GLOSS 1 1 MATERIAL",  JSONVariables.GLOSS1_1_MATERIAL)
                        print("GLOSS 1 1 WORK",  JSONVariables.GLOSS1_1_WORK)
                    }
                    
                    if let mat1_1 = myJsonPostPrint["prepressMatt1_1"] as? NSDictionary {
                        JSONVariables.MAT1_1_MATERIAL = (mat1_1["material_Cost"] as! NSString).doubleValue
                        JSONVariables.MAT1_1_WORK = (mat1_1["cost_of_Work"] as! NSString).doubleValue
                        
                        print("mat 1 1 MATERIAL",  JSONVariables.MAT1_1_MATERIAL)
                        print("mat 1 1 WORK",  JSONVariables.MAT1_1_WORK)
                    }
                    
                    if let prepressCold = myJsonPostPrint["prepressCold"] as? NSDictionary {
                        JSONVariables.COLD_LAM_MATERIAL = (prepressCold["material_Cost"] as! NSString).doubleValue
                        JSONVariables.COLD_LAM_WORK = (prepressCold["cost_of_Work"] as! NSString).doubleValue
                        
                        print("cold MATERIAL",  JSONVariables.COLD_LAM_MATERIAL)
                        print("cold WORK",  JSONVariables.COLD_LAM_WORK)
                    }
                
                }//do
                    
                catch {}
                
            }//if let content
            
    }//let task
    
    taskPostPrint.resume()
    
    
    let taskGeneral = URLSession.shared.dataTask(with: urlGeneral!)  {( data, response, error) in
        if error != nil {
            print("ERROR")
        } else {
            
            if let content = data {
                do {
                    let myJsonGeneral = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    if let USDCourse = myJsonGeneral["USD"] as? NSDictionary {
                        JSONVariables.USD = (USDCourse["Value"] as! NSString).doubleValue
                        print("courseeeeeee",  JSONVariables.USD)
                        
                    }
                    
                    if let NDSCourse = myJsonGeneral["NDS"] as? NSDictionary {
                        JSONVariables.NDS = Int((NDSCourse["Value"] as! NSString).intValue)
                        print("NDS",  JSONVariables.NDS)
                        
                    }
                    
                    if let overprice1 = myJsonGeneral["Overprice1"] as? NSDictionary {
                        JSONVariables.OVERPRICE1 = (overprice1["Value"] as! NSString).doubleValue
                        print("overprice1",  JSONVariables.OVERPRICE1)
                        
                    }
                }//do
                catch {}
            }//if let content
        }//else
    }//let task
    
    taskGeneral.resume()
    
    let task = URLSession.shared.dataTask(with: url!)  {( data, response, error) in
        if error != nil {
            print("ERROR")
        } else {
            if let content = data {
                do {
                    let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    if let cityLight = myJson["CityLight"] as? NSDictionary {
                        JSONVariables.cityMaterialCost = (cityLight["material_Cost"] as! NSString).doubleValue
                        JSONVariables.cityCostOfPrinting = (cityLight["cost_of_Printing"] as! NSString).doubleValue
                        
                        print("сити цена материала",  JSONVariables.cityMaterialCost)
                        print("сити цена печати",  JSONVariables.cityCostOfPrinting)
                    }
                    
                    if let lomond = myJson["Lomond"] as? NSDictionary {
                        JSONVariables.lomondMaterialCost = (lomond["material_Cost"] as! NSString).doubleValue
                        JSONVariables.lomondCostOfPrinting = (lomond["cost_of_Printing"] as! NSString).doubleValue
                        
                        print("ломонд цена материала",  JSONVariables.lomondMaterialCost)
                        print("ломонд цена печати",  JSONVariables.lomondCostOfPrinting)
                    }
                    
                    
                    if let photoPaper200 = myJson["photoPaper200"] as? NSDictionary {
                        JSONVariables.photo200MaterialCost = (photoPaper200["material_Cost"] as! NSString).doubleValue
                        JSONVariables.photo200CostOfPrinting = (photoPaper200["cost_of_Printing"] as! NSString).doubleValue
                        
                        print("200 цена материала",  JSONVariables.photo200MaterialCost)
                        print("200 цена печати",  JSONVariables.photo200CostOfPrinting)
                    }
                    
                    //================
                    
                    if let stickerWhiteGlossMatt = myJson["StickerWhiteGlossMatt"] as? NSDictionary {
                        JSONVariables.oracalWhiteGlossMattMaterialCost = (stickerWhiteGlossMatt["material_Cost"] as! NSString).doubleValue
                        JSONVariables.oracalWhiteGlossMattCostOfPrinting = (stickerWhiteGlossMatt["cost_of_Printing"] as! NSString).doubleValue
                        
                        print("StickerWhiteGlossMatt цена материала",  JSONVariables.oracalWhiteGlossMattMaterialCost)
                        print("StickerWhiteGlossMatt цена печати",  JSONVariables.oracalWhiteGlossMattCostOfPrinting)
                    }
                    
                    if let stickerTransparentGlossMatt = myJson["StickerTransparentGlossMatt"] as? NSDictionary {
                        JSONVariables.oracalTransparentGlossMattMaterialCost = (stickerTransparentGlossMatt["material_Cost"] as! NSString).doubleValue
                        JSONVariables.oracalTransparentGlossMattCostOfPrinting = (stickerTransparentGlossMatt["cost_of_Printing"] as! NSString).doubleValue
                        
                        print("StickerTransparentGlossMatt цена материала",  JSONVariables.oracalTransparentGlossMattMaterialCost)
                        print("StickerTransparentGlossMatt цена печати",  JSONVariables.oracalTransparentGlossMattCostOfPrinting)
                    }
                    
                    if let stickerOneWayVision = myJson["StickerOneWayVision"] as? NSDictionary {
                        JSONVariables.oneWayVisionMaterialCost = (stickerOneWayVision["material_Cost"] as! NSString).doubleValue
                        JSONVariables.oneWayVisionCostOfPrinting = (stickerOneWayVision["cost_of_Printing"] as! NSString).doubleValue
                        
                        print("StickerOneWayVision цена материала",  JSONVariables.oneWayVisionMaterialCost)
                        print("StickerOneWayVision цена печати",  JSONVariables.oneWayVisionCostOfPrinting)
                    }
                    
                    if let artCanvas = myJson["ArtCanvas"] as? NSDictionary {
                        JSONVariables.artCanvasMaterialCost = (artCanvas["material_Cost"] as! NSString).doubleValue
                        JSONVariables.artCanvasCostOfPrinting = (artCanvas["cost_of_Printing"] as! NSString).doubleValue
                        
                        print("ArtCanvas цена материала",  JSONVariables.artCanvasMaterialCost)
                        print("ArtCanvas цена печати",  JSONVariables.artCanvasCostOfPrinting)
                     }
                 }//do
                catch {}
            }//if let content
        }//else
    }// let task
    
    task.resume()
    
}
