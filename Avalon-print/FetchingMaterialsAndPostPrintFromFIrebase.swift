//
//  FetchingMaterialsAndPostPrintFromFIrebase.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 4/9/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.


import UIKit
import Firebase
import FirebaseDatabase

var priceData = priceDataStatus()

struct priceDataStatus {
  
   var materialsDictionary = [(title: "Выберите материал...", maxMaterialWidth: 0.0, matPrice: 0.0, printPrice: 0.0)]
   var postPrintDictionary = [(title: "Без постпечати", materialCost: 0.0, costOfWork: 0.0)]
  
   var materialPrice = Double()
   var printPrice = Double()
  
   var postPrintMaterialPrice = Double()
   var postPrintWorkPrice = Double()
  
  mutating func resetMaterialsAndPostprintDictionaries () {
    
    self = priceDataStatus()
  }
  
}


func fetchMaterialsAndPostprint(productType: String, onlyColdLamAllowed: Bool, onlyDefaultPrepressAllowed: Bool) {
  
     priceData.resetMaterialsAndPostprintDictionaries()
  
  var ref: FIRDatabaseReference!
      ref = FIRDatabase.database().reference()
  
  // Materials
  
  ref.child("Materials").observe(.childAdded, with: { (snapshot) in
    
    if snapshot.key == productType {
        observeMaterialsData(snapshot: snapshot)
    }
    
  }) { (error) in
    print(error.localizedDescription)
  }
  
  // Post Print
  ref.child("Postprint").observe(.childAdded, with: { (snapshot) in
    
    if onlyColdLamAllowed == true && onlyDefaultPrepressAllowed == true {
      print("error: impossible value in picker view")
    }
    
    if onlyDefaultPrepressAllowed == true {
      
        if snapshot.key != "prepressCold" {
            observePostrpintData(snapshot: snapshot)
       }
    }
    
    if onlyColdLamAllowed == true {
      
      if snapshot.key == "prepressCold" {
             observePostrpintData(snapshot: snapshot)
      }
    }
  
    if onlyColdLamAllowed == false && onlyDefaultPrepressAllowed == false {
           observePostrpintData(snapshot: snapshot)
    }
    
  }) { (error) in
    print(error.localizedDescription)
  }
}


func observeMaterialsData(snapshot: FIRDataSnapshot) {
  
  guard let dictionary = snapshot.value as? [String: AnyObject] else {
    return
  }
  
  for (_, value) in dictionary {
    
    if let materialTitle = value["title"], let maxMaterialWidth = value["maxMaterialWidth"], let materialPrice = value["materialPrice"] , let printPrice = value["printPrice"] {
      
      priceData.materialsDictionary.append(( materialTitle as! String, maxMaterialWidth as! Double, materialPrice as! Double  , printPrice as! Double  ))
    }
  }
}


func observePostrpintData(snapshot: FIRDataSnapshot) {
  
  guard let dictionary = snapshot.value as? [String: AnyObject] else {
    return
  }
  if let postprintTitle = dictionary["title"],  let materialCost = dictionary["materialCost"] , let workCost = dictionary["workCost"] {
    
    priceData.postPrintDictionary.append(( postprintTitle as! String , materialCost as! Double , workCost as! Double ))
  }
}
