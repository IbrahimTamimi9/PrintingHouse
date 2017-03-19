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

//MARK: SHOWS IF ELEMENTS IN postersMaterialVC.swift, postersPostPrintVC.swift, postersAmountAndSizeVC CHECKED OR NOT
struct postersBoolVariables {
    static var amount = ""
    static var amountDidNotInputed = true
    
   static var materialDidnNotChosen = true
   static var cityC = false
   static var lomondC = false
   static var photoC = false

   static var postersWidhOrHeightDidNotInputed = true
   static var postersWidthSet = ""
   static var postersHeightSet = ""
    
   static var withoutPostPrint = false
   static var gloss1_0C = false
   static var matt1_0C = false
   static var gloss1_1C = false
   static var matt1_1C = false
    
   static var priceToLabel = String()
   static var ndsPriceToLabel = String()
  
  static func resetMaterials() {
      postersBoolVariables.materialDidnNotChosen = true
      postersBoolVariables.cityC = false
      postersBoolVariables.lomondC = false
      postersBoolVariables.photoC = false

  }
  
  static func resetPostprint() {
    postersBoolVariables.withoutPostPrint = false
    postersBoolVariables.gloss1_0C = false
    postersBoolVariables.matt1_0C = false
    postersBoolVariables.gloss1_1C = false
    postersBoolVariables.matt1_1C = false
  }
  
}

func getPosterPrice (materialPrice: Double , materialPrintPrice: Double, prepress: Double,  workPrepress: Double)  {
  
  var price = 0; //цена
  let amount = postersBoolVariables.amount.doubleValue //количество
  let custom_wi = postersBoolVariables.postersWidthSet.convertToDemicalIfItIsNot
  let custom_he = postersBoolVariables.postersHeightSet.convertToDemicalIfItIsNot
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
  
    postersBoolVariables.priceToLabel =  String(price)
    postersBoolVariables.ndsPriceToLabel = String((price + ((price * NDS)/100) ))
  
}


    func computings() {
      
        //MARK: MATERIALS
        let city_material_m2 = JSONVariables.cityMaterialCost // 0.46
        let city_pricem2 =   JSONVariables.cityCostOfPrinting //3.7
        
        let lomond_material_m2 = JSONVariables.lomondMaterialCost // 0.78
        let lomond_price_m2 = JSONVariables.lomondCostOfPrinting //6.0
        
        let fotoPaper_material_m2 = JSONVariables.photo200MaterialCost //4.0
        let fotoPaper_price_m2 = JSONVariables.photo200CostOfPrinting //8.0
        
        
        //MARK: POST PRINT
        let gloss_1_0 =  JSONVariables.GLOSS1_0_MATERIAL// 0.13
        let work_gloss_1_0 = JSONVariables.GLOSS1_0_WORK //0.5
        let mat_1_0 =  JSONVariables.MAT1_0_MATERIAL //0.14
        let work_mat_1_0 = JSONVariables.MAT1_0_WORK //0.5
        
        let gloss_1_1 =   JSONVariables.GLOSS1_1_MATERIAL //0.26
        let work_gloss_1_1 = JSONVariables.GLOSS1_1_WORK //0.7
        let mat_1_1 = JSONVariables.MAT1_1_MATERIAL //0.28
        let work_mat_1_1 = JSONVariables.MAT1_1_WORK //0.7
        
      
         //MARK: CITY MATERIAL, VARIANTS START
        if( postersBoolVariables.materialDidnNotChosen == true || postersBoolVariables.amountDidNotInputed == true ||
            postersBoolVariables.postersWidhOrHeightDidNotInputed == true )  {
            
            postersBoolVariables.priceToLabel = "0"
            postersBoolVariables.ndsPriceToLabel = "0"
        }
    
      
        
        if( postersBoolVariables.cityC == true && postersBoolVariables.withoutPostPrint == true)  {
            print("city + without post print")
          
            getPosterPrice (materialPrice: city_material_m2, materialPrintPrice: city_pricem2, prepress: 0.0, workPrepress: 0.0)

        }
  
        
        if( postersBoolVariables.cityC == true && postersBoolVariables.gloss1_0C == true)  {
            print("city + gloss1_0 chosen")
          
            getPosterPrice(materialPrice: city_material_m2, materialPrintPrice: city_pricem2, prepress: gloss_1_0, workPrepress: work_gloss_1_0)
   
        }
      
        
        if ( postersBoolVariables.cityC == true && postersBoolVariables.matt1_0C == true) {
             print("city + matt1_0 chosen")
          
             getPosterPrice(materialPrice: city_material_m2, materialPrintPrice: city_pricem2, prepress: mat_1_0, workPrepress: work_mat_1_0)
            
         }
        
        
        if ( postersBoolVariables.cityC == true && postersBoolVariables.gloss1_1C == true) {
             print("city + gloss1_1 chosen")
          
             getPosterPrice(materialPrice: city_material_m2, materialPrintPrice: city_pricem2, prepress: gloss_1_1, workPrepress: work_gloss_1_1)
            
        }
        
       
        if ( postersBoolVariables.cityC == true && postersBoolVariables.matt1_1C == true) {
             print("city + matt1_1 chosen")
          
             getPosterPrice(materialPrice: city_material_m2, materialPrintPrice: city_pricem2, prepress: mat_1_1, workPrepress: work_mat_1_1)
          
        }

        
         //MARK: LOMOND MATERIAL, VARIANTS START
        
        if( postersBoolVariables.lomondC == true && postersBoolVariables.withoutPostPrint == true)  {
            print("lomond + without post print")
          
            getPosterPrice(materialPrice: lomond_material_m2, materialPrintPrice: lomond_price_m2, prepress: 0.0, workPrepress: 0.0)
            
        }
        

        if( postersBoolVariables.lomondC == true && postersBoolVariables.gloss1_0C == true)  {
            print("lomond + gloss1_0 chosen")
          
            getPosterPrice(materialPrice: lomond_material_m2, materialPrintPrice: lomond_price_m2, prepress: gloss_1_0, workPrepress: work_gloss_1_0)
        
        }
        
        
        if ( postersBoolVariables.lomondC == true && postersBoolVariables.matt1_0C == true) {
             print("lomond + matt1_0 chosen")
          
             getPosterPrice(materialPrice: lomond_material_m2, materialPrintPrice: lomond_price_m2, prepress: mat_1_0, workPrepress: work_mat_1_0)
          
        }
        
        
        if ( postersBoolVariables.lomondC == true && postersBoolVariables.gloss1_1C == true) {
             print("lomond + gloss1_1 chosen")
          
             getPosterPrice(materialPrice: lomond_material_m2, materialPrintPrice: lomond_price_m2, prepress: gloss_1_1, workPrepress: work_gloss_1_1)
        
        }
        
        
        if ( postersBoolVariables.lomondC == true && postersBoolVariables.matt1_1C == true) {
             print("lomond + matt1_1 chosen")
          
             getPosterPrice(materialPrice: lomond_material_m2, materialPrintPrice: lomond_price_m2, prepress: mat_1_1, workPrepress: work_mat_1_1)
        
        }
        
        
        //MARK: photo paper 200gr/m2 MATERIAL, VARIANTS START
        
        if( postersBoolVariables.photoC == true && postersBoolVariables.withoutPostPrint == true)  {
            print("photo paper 200gr/m2 + without post print")
          
            getPosterPrice(materialPrice: fotoPaper_material_m2, materialPrintPrice: fotoPaper_price_m2, prepress: 0.0, workPrepress: 0.0)
            
        }

        
        if( postersBoolVariables.photoC == true && postersBoolVariables.gloss1_0C == true)  {
            print("photo paper 200gr/m2 + gloss1_0 chosen")
          
            getPosterPrice(materialPrice: fotoPaper_material_m2, materialPrintPrice: fotoPaper_price_m2, prepress: gloss_1_0, workPrepress: work_gloss_1_0)
          
        }
        
        
        if ( postersBoolVariables.photoC == true && postersBoolVariables.matt1_0C == true) {
             print("photo paper 200gr/m2 + matt1_0 chosen")
          
             getPosterPrice(materialPrice: fotoPaper_material_m2, materialPrintPrice: fotoPaper_price_m2, prepress: mat_1_0, workPrepress: work_mat_1_0)

        }
        
        
        if ( postersBoolVariables.photoC == true && postersBoolVariables.gloss1_1C == true) {
             print("photo paper 200gr/m2 + gloss1_1 chosen")
          
             getPosterPrice(materialPrice: fotoPaper_material_m2, materialPrintPrice: fotoPaper_price_m2, prepress: gloss_1_1, workPrepress: work_gloss_1_1)
            
        }
        
        
        if ( postersBoolVariables.photoC == true && postersBoolVariables.matt1_1C == true) {
             print("photo paper 200gr/m2 + matt1_1 chosen")
          
             getPosterPrice(materialPrice: fotoPaper_material_m2, materialPrintPrice: fotoPaper_price_m2, prepress: mat_1_1, workPrepress: work_mat_1_1)
          
        }
        
      
    }// func computings()
