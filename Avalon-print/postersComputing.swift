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
        return Double(self)!// ?? 0
    }
    
}

extension String {
    var intValue: Int {
        return Int(self)!// ?? 0
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
    
}

   

    func computings() {
        
        //MARK:INSIDE INITIALIZING VARS
        var price = 0; //цена
        let amount = postersBoolVariables.amount.doubleValue //количество
        let custom_wi = postersBoolVariables.postersWidthSet.convertToDemicalIfItIsNot
        let custom_he = postersBoolVariables.postersHeightSet.convertToDemicalIfItIsNot
        let squareMeters = custom_he * custom_wi
        
        var prepress_gloss_1_0 = Double() //просчет припреса
        var work_prepress_gloss_1_0 = Double()
        var prepress_mat_1_0 = Double() //просчет припреса
        var work_prepress_mat_1_0 = Double()
        
        var prepress_gloss_1_1 = Double() //просчет припреса
        var work_prepress_gloss_1_1 = Double();
        
        var prepress_mat_1_1 = Double() //просчет припреса
        var work_prepress_mat_1_1 = Double()
        
        let maxPercentOfDiscount = 19
        
        //MARK: INITIALIZING FROM JSON
        //MARK: GENERAL
        let currency_course = JSONVariables.USD
        let NDS = JSONVariables.NDS
        let overprice1 = JSONVariables.OVERPRICE1
        //double ovp_2 = 1.4;
        
        
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
            
            let materialSum = city_pricem2 + city_material_m2 * overprice1
                price = Int(currency_course * amount * materialSum * squareMeters)

        }

        
        if( postersBoolVariables.cityC == true && postersBoolVariables.gloss1_0C == true)  {
            print("city + gloss1_0 chosen")
            
            let materialSum = city_pricem2 + city_material_m2 * overprice1
                prepress_gloss_1_0 =  (squareMeters * gloss_1_0) * amount;
                work_prepress_gloss_1_0 =  (squareMeters * work_gloss_1_0) * amount;
            
            let prepressSum = prepress_gloss_1_0 + work_prepress_gloss_1_0
    
                price = Int(currency_course * (prepressSum + amount * materialSum * squareMeters))
   
        }
        
        
        if ( postersBoolVariables.cityC == true && postersBoolVariables.matt1_0C == true) {
            print("city + matt1_0 chosen")
            
            let materialSum = city_pricem2 + city_material_m2 * overprice1
                prepress_mat_1_0 =  (squareMeters * mat_1_0) * amount;
                work_prepress_mat_1_0 =  (squareMeters * work_mat_1_0) * amount;
            
            let prepressSum =  prepress_mat_1_0 + work_prepress_mat_1_0
        
                price = Int(currency_course * (prepressSum + amount * materialSum * squareMeters))
            
         }
        
        
        if (postersBoolVariables.cityC == true && postersBoolVariables.gloss1_1C == true) {
            print("city + gloss1_1 chosen")
            
            let materialSum = city_pricem2 + city_material_m2 * overprice1
                prepress_gloss_1_1 =  (squareMeters * gloss_1_1) * amount;
                work_prepress_gloss_1_1 =  (squareMeters * work_gloss_1_1) * amount;
            
            let prepressSum = prepress_gloss_1_1 + work_prepress_gloss_1_1
            
                price = Int(currency_course * (prepressSum + amount * materialSum * squareMeters))
            
        }
        
       
        if ( postersBoolVariables.cityC == true && postersBoolVariables.matt1_1C == true) {
            print("city + matt1_1 chosen")
            let materialSum = city_pricem2 + city_material_m2 * overprice1
                prepress_mat_1_1 =  (squareMeters * mat_1_1) * amount;
                work_prepress_mat_1_1 =  (squareMeters * work_mat_1_1) * amount;
            
            let prepressSum =  prepress_mat_1_1 + work_prepress_mat_1_1
            
                price = Int(currency_course * (prepressSum + amount * materialSum * squareMeters))
            
        }

        
         //MARK: LOMOND MATERIAL, VARIANTS START
        
        if( postersBoolVariables.lomondC == true && postersBoolVariables.withoutPostPrint == true)  {
            print("lomond + without post print")
            
            let materialSum = lomond_price_m2 + lomond_material_m2 * overprice1
                price = Int(currency_course * amount * materialSum * squareMeters)
            
        }
        

        if( postersBoolVariables.lomondC == true && postersBoolVariables.gloss1_0C == true)  {
            print("lomond + gloss1_0 chosen")
            
            let materialSum = lomond_price_m2 + lomond_material_m2// * overprice1
                prepress_gloss_1_0 =  (squareMeters * gloss_1_0) * amount;
                work_prepress_gloss_1_0 =  (squareMeters * work_gloss_1_0) * amount;
            
            let prepressSum = prepress_gloss_1_0 + work_prepress_gloss_1_0
            
                price = Int(currency_course * (prepressSum + amount * materialSum * squareMeters))
        
        }
        
        
        if ( postersBoolVariables.lomondC == true && postersBoolVariables.matt1_0C == true) {
            print("lomond + matt1_0 chosen")
            
            let materialSum = lomond_price_m2 + lomond_material_m2// * overprice1
                prepress_mat_1_0 =  (squareMeters * mat_1_0) * amount;
                work_prepress_mat_1_0 =  (squareMeters * work_mat_1_0) * amount;
            
            let prepressSum =  prepress_mat_1_0 + work_prepress_mat_1_0
    
                price = Int(currency_course * (prepressSum + amount * materialSum * squareMeters))
            
        }
        
        
        if (postersBoolVariables.lomondC == true && postersBoolVariables.gloss1_1C == true) {
            print("lomond + gloss1_1 chosen")
            
            let materialSum = lomond_price_m2 + lomond_material_m2// * overprice1
                prepress_gloss_1_1 =  (squareMeters * gloss_1_1) * amount;
                work_prepress_gloss_1_1 =  (squareMeters * work_gloss_1_1) * amount;
            
            let prepressSum = prepress_gloss_1_1 + work_prepress_gloss_1_1
        
                price = Int(currency_course * (prepressSum + amount * materialSum * squareMeters))
        
        }
        
        
        if ( postersBoolVariables.lomondC == true && postersBoolVariables.matt1_1C == true) {
            print("lomond + matt1_1 chosen")
            
            let materialSum = lomond_price_m2 + lomond_material_m2// * overprice1
                prepress_mat_1_1 =  (squareMeters * mat_1_1) * amount;
                work_prepress_mat_1_1 =  (squareMeters * work_mat_1_1) * amount;
            
            let prepressSum =  prepress_mat_1_1 + work_prepress_mat_1_1
    
                price = Int(currency_course * (prepressSum + amount * materialSum * squareMeters))
        
        }
        
        
        //MARK: photo paper 200gr/m2 MATERIAL, VARIANTS START
        
        if( postersBoolVariables.photoC == true && postersBoolVariables.withoutPostPrint == true)  {
            print("photo paper 200gr/m2 + without post print")
            
            let materialSum = fotoPaper_price_m2 + fotoPaper_material_m2// * overprice1
                price = Int(currency_course * amount * materialSum * squareMeters)
            
        }

        
        if( postersBoolVariables.photoC == true && postersBoolVariables.gloss1_0C == true)  {
            print("photo paper 200gr/m2 + gloss1_0 chosen")
            
            let materialSum = fotoPaper_price_m2 + fotoPaper_material_m2// * overprice1
                prepress_gloss_1_0 =  (squareMeters * gloss_1_0) * amount;
                work_prepress_gloss_1_0 =  (squareMeters * work_gloss_1_0) * amount;
            
            let prepressSum = prepress_gloss_1_0 + work_prepress_gloss_1_0
        
                price = Int(currency_course * (prepressSum + amount * materialSum * squareMeters))
            
        }
        
        
        if ( postersBoolVariables.photoC == true && postersBoolVariables.matt1_0C == true) {
            print("photo paper 200gr/m2 + matt1_0 chosen")
            
            let materialSum = fotoPaper_price_m2 + fotoPaper_material_m2// * overprice1
                prepress_mat_1_0 =  (squareMeters * mat_1_0) * amount;
                work_prepress_mat_1_0 =  (squareMeters * work_mat_1_0) * amount;
            
            let prepressSum =  prepress_mat_1_0 + work_prepress_mat_1_0
    
                price = Int(currency_course * (prepressSum + amount * materialSum * squareMeters))

        }
        
        
        if (postersBoolVariables.photoC == true && postersBoolVariables.gloss1_1C == true) {
            print("photo paper 200gr/m2 + gloss1_1 chosen")
            
            let materialSum = fotoPaper_price_m2 + fotoPaper_material_m2// * overprice1
                prepress_gloss_1_1 =  (squareMeters * gloss_1_1) * amount;
                work_prepress_gloss_1_1 =  (squareMeters * work_gloss_1_1) * amount;
            
            let prepressSum = prepress_gloss_1_1 + work_prepress_gloss_1_1
            
                price = Int(currency_course * (prepressSum + amount * materialSum * squareMeters))
            
        }
        
        
        if ( postersBoolVariables.photoC == true && postersBoolVariables.matt1_1C == true) {
            print("photo paper 200gr/m2 + matt1_1 chosen")
            
            let materialSum = fotoPaper_price_m2 + fotoPaper_material_m2// * overprice1
                prepress_mat_1_1 =  (squareMeters * mat_1_1) * amount;
                work_prepress_mat_1_1 =  (squareMeters * work_mat_1_1) * amount;
            
            let prepressSum =  prepress_mat_1_1 + work_prepress_mat_1_1
        
                price = Int(currency_course * (prepressSum + amount * materialSum * squareMeters))
            
        }
        
        //MARK: DISCOUNT
        if(price >= 150) { price = (price - (price * 5)/100); }
        
        if(price >= 2000) { price = (price - (price * 7)/100); }
        
        if(price >= 4000) { price = (price - (price * 10)/100); }
        
        if(price >= 8000) { price = (price - (price * maxPercentOfDiscount)/100); }
        
        
        postersBoolVariables.priceToLabel =  String(price)
        postersBoolVariables.ndsPriceToLabel = String((price + ((price * NDS)/100) ))
        
    }// func computings()
