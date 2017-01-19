//
//  HelpingFunctions.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 1/20/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import Foundation


func reset (page: String) {
    
    if page == "posters" {
        postersBoolVariables.amountDidNotInputed = true
        postersBoolVariables.amount = ""
       // print("lol from posters it works")
        
        postersBoolVariables.materialDidnNotChosen = true
        postersBoolVariables.cityC = false
        postersBoolVariables.lomondC = false
        postersBoolVariables.photoC = false
        postersBoolVariables.postersWidhOrHeightDidNotInputed = true
        postersBoolVariables.postersWidthSet = ""
        postersBoolVariables.postersHeightSet = ""
        
        postersBoolVariables.withoutPostPrint = true
        postersBoolVariables.gloss1_0C = false
        postersBoolVariables.matt1_0C = false
        postersBoolVariables.gloss1_1C = false
        postersBoolVariables.matt1_1C = false
        
        postersBoolVariables.priceToLabel = "0"
        postersBoolVariables.ndsPriceToLabel = "0"
    }
    
    
    if page == "stickers" {
        stickersBoolVariables.amountDidNotInputed = true
        stickersBoolVariables.amount = ""
        //print("lol from stickers it works")
        
        stickersBoolVariables.materialDidnNotChosen = true
        stickersBoolVariables.whiteStickerC = false
        stickersBoolVariables.transparentStickerC = false
        stickersBoolVariables.oneWayVisionC = false
        stickersBoolVariables.stickersWidhOrHeightDidNotInputed = true
        stickersBoolVariables.stickersWidthSet = ""
        stickersBoolVariables.stickersHeightSet = ""
        
        stickersBoolVariables.withoutPostPrint = true
        stickersBoolVariables.coldLaminationC = false
        
        stickersBoolVariables.priceToLabel = "0"
        stickersBoolVariables.ndsPriceToLabel = "0"
    }
    
    
    if page == "canvas" {
        canvasBoolVariables.amount = ""
        canvasBoolVariables.amountDidNotInputed = true
        //print("lol from canvas it works")
        
        canvasBoolVariables.standartSizeDidnNotChosen = true
        canvasBoolVariables.sixH_x_NineH_C = false
        canvasBoolVariables.fiveH_x_sevenH_C = false
        canvasBoolVariables.fourH_x_fiveH_C = false
        canvasBoolVariables.threeH_x_fourH_C = false
        canvasBoolVariables.twoH_x_threeH_C = false
        
        canvasBoolVariables.canvasWidhOrHeightDidNotInputed = true
        canvasBoolVariables.canvasWidthSet = ""
        canvasBoolVariables.canvasHeightSet = ""
        
        canvasBoolVariables.withoutUnderframe = true
        canvasBoolVariables.withUnderframe = false
        
        canvasBoolVariables.priceToLabel = "0"
        canvasBoolVariables.ndsPriceToLabel = "0"
    }
    
}
