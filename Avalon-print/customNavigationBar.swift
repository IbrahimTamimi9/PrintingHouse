//
//  customNavigationBar.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/17/16.
//  Copyright © 2016 Константин. All rights reserved.
//

import UIKit

class customNavigationBar: UINavigationBar {
    
   override func draw(_ rect: CGRect) {
    
        self.backIndicatorImage = UIImage(named: "ChevronLeft")
        self.backIndicatorTransitionMaskImage = UIImage(named: "ChevronLeft")
        self.tintColor = UIColor.white
        
        self.titleTextAttributes = [NSFontAttributeName : (UIFont(name: "Exo2-Light", size: 17))!, NSForegroundColorAttributeName: UIColor.white]
    }
}
