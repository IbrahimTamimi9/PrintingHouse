//
//  PageStartButtonClass.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 1/9/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class PageStartButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        // Drawing code
          let screenSize: CGRect = UIScreen.main.bounds
          let titleInsets = UIEdgeInsets(top: screenSize.height/4, left: 0, bottom: 0, right: 0)
          let titleFont = UIFont(name: "Exo2-ExtraLight", size: 15)
        
        self.backgroundColor = .clear
        self.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.titleEdgeInsets = titleInsets
        self.titleLabel?.font = titleFont
    }
    
}
