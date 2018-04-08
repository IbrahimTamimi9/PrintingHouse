//
//  HomepageMenu.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/26/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class HomepageMenu: NSObject {
  
  typealias ItemInfo = (imageName: String, title: String, viewController: UIViewController)
  
  var menuItems = [ItemInfo]()
  
  
  override init() {
    super.init()
    
    menuItems =  [("Posters", NSLocalizedString("HomeViewController.items.posters", comment: ""), viewController: PostersViewController()),
                  ("Banners", NSLocalizedString("HomeViewController.items.banners", comment: ""), viewController: BannersViewController()),
                  ("Stickers", NSLocalizedString("HomeViewController.items.stickers", comment: ""), viewController:StickersViewController()),
                  ("Canvas", NSLocalizedString("HomeViewController.items.canvas", comment: ""), viewController: CanvasViewController()),
                  ("Contacts", NSLocalizedString("HomeViewController.items.contacts", comment: ""), viewController: ContactsTableViewController()),
                  ("Information", NSLocalizedString("HomeViewController.items.information", comment: ""), viewController: InformationTableViewController())]
  }
}
