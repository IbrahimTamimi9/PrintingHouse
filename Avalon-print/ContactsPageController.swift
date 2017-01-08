//
//  MainPageController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/1/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//


import UIKit

class ContactsPageController: UIViewController {
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    
    }
    
    @IBAction func openMap(_ sender: Any) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "map") as! map
                navigationController?.pushViewController(destination, animated: true)
        
        
    }
//    @IBAction func openMap(_ sender: Any) {
//        let destination = storyboard?.instantiateViewController(withIdentifier: "map") as! map
//        navigationController?.pushViewController(destination, animated: true)
//        
//        
//    }
}
