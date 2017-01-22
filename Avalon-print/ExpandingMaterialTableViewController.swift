//
//  ExpandingMaterialTableViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 1/21/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import expanding_collection



class ExpandingMaterialTableViewController: ExpandingTableViewController {
   
    
    fileprivate var scrollOffsetY: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.backgroundColor = UIColor.clear
        
        
          //let image1 = UIImage(named: "contacts")
           // tableView.backgroundView = UIImageView(image: image1)
        
        
          }
    
   
     override func scrollViewDidScroll(_ scrollView: UIScrollView) {
            scrollOffsetY = scrollView.contentOffset.y
        }
    
   
        
    @IBAction func dismiss(_ sender: Any) {
        popTransitionAnimation()
        
       }
    }
    
    
    
//    @IBAction func dismissTBV(_ sender: Any) {
//        let viewControllers: [ExpandingMaterialViewController?] = navigationController?.viewControllers.map { $0 as? ExpandingMaterialViewController } ?? []
//        
//        popTransitionAnimation()
//    }

//}

// MARK: UIScrollViewDelegate


