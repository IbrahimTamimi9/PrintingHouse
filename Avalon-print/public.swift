//
//  ExtensionsHomeVC.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/21/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import Foundation
import CoreData

  let postersTitle = NSLocalizedString("HomeViewController.items.posters", comment: "")
  let stickersTitle = NSLocalizedString("HomeViewController.items.stickers", comment: "")
  let canvasTitle = NSLocalizedString("HomeViewController.items.canvas", comment: "")
  let bannersTitle = NSLocalizedString("HomeViewController.items.banners", comment: "")

  let preferredLanguage = Locale.current.languageCode 

  let russianLanguage = "ru"

  let englishLanguage = "en"


let presentRequest:NSFetchRequest<AddedItems> = AddedItems.fetchRequest()

var addedItems = [AddedItems]()

var managedObjextContext: NSManagedObjectContext!


public func localizeCoreDataIfNeeded () {
  
  let postersENGTitle = "Posters"
  let stickersENGTitle = "Stickers"
  let canvasENGTitle = "Canvas"
  let bannersENGTitle = "Banners"
  
  let postersRUSTitle = "Плакаты"
  let stickersRUSTitle = "Наклейки"
  let canvasRUSTitle = "Холсты"
  let bannersRUSTitle = "Баннеры"
  
  
  do {
    if let fetchResults = try managedObjextContext?.fetch(presentRequest) {
      
      if fetchResults.count != 0 {
        
        for index in 0...fetchResults.count-1 {
          
          let managedObject = fetchResults[index]
          
          print(managedObject.value(forKey: "productType") as! String)
          if preferredLanguage == russianLanguage {
            
            switch managedObject.value(forKey: "productType") as! String {
              
              
            case postersENGTitle :
               managedObject.setValue(postersTitle, forKey: "productType")
              break
              
            case stickersENGTitle :
                managedObject.setValue(stickersTitle, forKey: "productType")
              break
              
            case canvasENGTitle :
                managedObject.setValue(canvasTitle, forKey: "productType")
              break
              
            case bannersENGTitle :
                managedObject.setValue(bannersTitle, forKey: "productType")
              break
              
            default: break
            }
            
          } else {
            
            switch managedObject.value(forKey: "productType") as! String {
              
            case postersRUSTitle :
                managedObject.setValue(postersTitle, forKey: "productType")
             
              break
              
            case stickersRUSTitle :
                managedObject.setValue(stickersTitle, forKey: "productType")
              
              break
              
            case canvasRUSTitle :
                managedObject.setValue(canvasTitle, forKey: "productType")
              
              break
              
            case bannersRUSTitle :
                managedObject.setValue(bannersTitle, forKey: "productType")
            
              break
              
            default: break
            }
          }
        }
        
        try managedObjextContext.save()
      }
    }
  } catch let error as NSError {
    print("Could not fetch \(error), \(error.userInfo)")
  }
  
}


  public func updateBadgeValue () {
    managedObjextContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do {
      addedItems = try managedObjextContext.fetch(presentRequest)
    } catch {
      print(error)
    }
    rightBarButton?.badgeValue = "\(addedItems.count)"
  }


