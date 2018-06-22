//
//  FetchingMaterialsAndPostPrintFromFIrebase.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 4/9/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.


import UIKit
import Firebase

var priceData = priceDataStatus()

struct priceDataStatus {
  
   var materialsDictionary = [(title: NSLocalizedString("PostersStickersCanvasTopBlockView.materialField.placeholder", comment: ""),
                               maxMaterialWidth: 0.0, matPrice: 0.0, printPrice: 0.0)]
  
   var postPrintDictionary = [(title:  NSLocalizedString("PostersStickersCanvasTopBlockView.postprintField.placeholder", comment: ""),
                               materialCost: 0.0, costOfWork: 0.0)]
  
  var bannersPostPrintDictionary = [()]
  
   var materialPrice = Double()
   var printPrice = Double()
  
   var underframePrice = 0.0// Double()
   var setupWorkPrice = 0.0//Double()
  
    var luversPrice = 0.0
    var pocketsPrice = 0.0

  
   var postPrintMaterialPrice = Double()
   var postPrintWorkPrice = Double()
  
  mutating func resetMaterialsAndPostprintDictionaries () {
    
    self = priceDataStatus()
  }
  
}

struct generalDataForCalculations {
  static var USD = Double()
  static var NDS = Int()
  static var OVERPRICE1 = Double()
}


func fetchGeneralDataForCalculations () {
  
  var ref: DatabaseReference!
  ref = Database.database().reference()
  
  ref.child("GeneralData").observe(.value, with: { (snapshot) in
    
    let generalBlock = snapshot.value as? NSDictionary
    
    let USDBlock = generalBlock?["USD"] as? NSDictionary
    let NDSBlock = generalBlock?["NDS"] as? NSDictionary
    let Overprice1Block = generalBlock?["Overprice1"] as? NSDictionary
    
    generalDataForCalculations.USD = (USDBlock?["Value"] as? String ?? "").doubleValue
    generalDataForCalculations.NDS = Int((NDSBlock?["Value"] as? String ?? "").intValue)
    generalDataForCalculations.OVERPRICE1 = (Overprice1Block?["Value"] as? String ?? "").doubleValue
    
  }) { (error) in
    print(error.localizedDescription)
  }
  
}



func fetchMaterialsAndPostprint(productType: String, onlyColdLamAllowed: Bool, onlyDefaultPrepressAllowed: Bool) {
  
     priceData.resetMaterialsAndPostprintDictionaries()
  
  var ref: DatabaseReference!
      ref = Database.database().reference()
  
  // Materials
  print(preferredLanguage!)
   if preferredLanguage == russianLanguage {
    
    ref.child("MaterialsRUS").observe(.childAdded, with: { (snapshot) in
      
      if snapshot.key == productType {
        observeMaterialsData(snapshot: snapshot)
      }
      
    }) { (error) in
      print(error.localizedDescription)
    }
   } else {
    
    ref.child("MaterialsENG").observe(.childAdded, with: { (snapshot) in
      
      if snapshot.key == productType {
        observeMaterialsData(snapshot: snapshot)
      }
      
    }) { (error) in
      print(error.localizedDescription)
    }
    
  }
  
  // Post Print
  if preferredLanguage == russianLanguage {
        
    ref.child("PostprintRUS").observe(.childAdded, with: { (snapshot) in
      
      if onlyColdLamAllowed == true && onlyDefaultPrepressAllowed == true {
        print("error: impossible value in picker view")
      }
      
      if onlyDefaultPrepressAllowed == true {
        
        if snapshot.key != "prepressCold" && snapshot.key != "underframeSetup" {
          observePostrpintData(snapshot: snapshot)
        }
      }
      
      if onlyColdLamAllowed == true {
        
        if snapshot.key == "prepressCold" {
          observePostrpintData(snapshot: snapshot)
        }
      }
      
      if onlyColdLamAllowed == false && onlyDefaultPrepressAllowed == false {
        
        if  snapshot.key == "underframeSetup" {
          observePostrpintData(snapshot: snapshot)
        }
        
      }
      
    }) { (error) in
      print(error.localizedDescription)
    }
  } else {
    
    ref.child("PostprintENG").observe(.childAdded, with: { (snapshot) in
      
      if onlyColdLamAllowed == true && onlyDefaultPrepressAllowed == true {
        print("error: impossible value in picker view")
      }
      
      if onlyDefaultPrepressAllowed == true {
        
        if snapshot.key != "prepressCold" && snapshot.key != "underframeSetup" {
          observePostrpintData(snapshot: snapshot)
        }
      }
      
      if onlyColdLamAllowed == true {
        
        if snapshot.key == "prepressCold" {
          observePostrpintData(snapshot: snapshot)
        }
      }
      
      if onlyColdLamAllowed == false && onlyDefaultPrepressAllowed == false {
        
        if  snapshot.key == "underframeSetup" {
          observePostrpintData(snapshot: snapshot)
        }
        
      }
      
    }) { (error) in
      print(error.localizedDescription)
    }
    
  }
  
}


func fetchMaterialsForBanners(productType: String) {
  
  priceData.resetMaterialsAndPostprintDictionaries()
  
  var ref: DatabaseReference!
  ref = Database.database().reference()
  
  // Materials
  if preferredLanguage == russianLanguage {

    ref.child("MaterialsRUS").observe(.childAdded, with: { (snapshot) in
      
      if snapshot.key == productType {
        observeMaterialsData(snapshot: snapshot)
      }
      
    }) { (error) in
      print(error.localizedDescription)
    }
    
  } else {
    
    ref.child("MaterialsENG").observe(.childAdded, with: { (snapshot) in
      
      if snapshot.key == productType {
        observeMaterialsData(snapshot: snapshot)
      }
      
    }) { (error) in
      print(error.localizedDescription)
    }
  }

}


func fetchPostprintForBanners () {
  
  priceData.resetMaterialsAndPostprintDictionaries()
  
  var ref: DatabaseReference!
  ref = Database.database().reference()
  
  // Materials
  ref.child("BannersPostprint").observe(.childAdded, with: { (snapshot) in
    
    guard let dictionary = snapshot.value as? [String: AnyObject] else {
      return
    }
    
    for (_, value) in dictionary {
   //   print(value)
          if snapshot.key == "Luvers" {
            priceData.luversPrice = value.doubleValue
          }
      
          if snapshot.key == "Pockets" {
             priceData.pocketsPrice = value.doubleValue
      }
    
    }

    
  }) { (error) in
    print(error.localizedDescription)
  }
}


func observeMaterialsData(snapshot: DataSnapshot) {
  
  guard let dictionary = snapshot.value as? [String: AnyObject] else {
    return
  }
  
  for (_, value) in dictionary {
    
    if let materialTitle = value["title"], let maxMaterialWidth = value["maxMaterialWidth"], let materialPrice = value["materialPrice"] , let printPrice = value["printPrice"] {
      
      priceData.materialsDictionary.append(( materialTitle as! String, maxMaterialWidth as! Double, materialPrice as! Double  , printPrice as! Double  ))
    }
  }
}


func observePostrpintData(snapshot: DataSnapshot) {
  
  guard let dictionary = snapshot.value as? [String: AnyObject] else {
    return
  }
  if let postprintTitle = dictionary["title"],  let materialCost = dictionary["materialCost"] , let workCost = dictionary["workCost"] {
    
    priceData.postPrintDictionary.append(( postprintTitle as! String , materialCost as! Double , workCost as! Double ))
  }
}
