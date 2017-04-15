//
//  ExpandingMaterialTableViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 1/21/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import expanding_collection

 var dataArray = ["Плотность: 140","Покрытие меловка","макс ширина 1000"]
 var secondSection = ["Быстросохнущая микропористая постерная бумага с белой поверхностью, сатиновым покрытием для печати сольвентными и экосольвентными чернилами. Печатная поверхность может принять большое количество чернил, обеспечивая хорошее качество печати рекламных плакатов, чернила не растекаются. Рекомендуется для интерьерной и наружной рекламы. Бумагу можно защищать как горячей, так и холодной ламинацией."]



class ExpandingMaterialTableViewController: ExpandingTableViewController {
  
    fileprivate var scrollOffsetY: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
      
        }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    if section == 0 {
      return "Характеристики"
    }
    return "Описание"
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if section == 0 {
      return dataArray.count
    }
      
      return secondSection.count
    
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 1 {
      return 180
    }
    
      return 44
    }
  
 
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
     cell.textLabel?.numberOfLines = 10
     cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
    
    if indexPath.section == 0 {
       cell.textLabel?.text = dataArray[indexPath.row]
    }
    
    if indexPath.section == 1 {
      
      cell.textLabel?.text = secondSection[indexPath.row]
    }
    
    
    
    return cell
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


