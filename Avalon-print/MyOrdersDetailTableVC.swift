//
//  MyOrdersDetailTableVC.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 1/30/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import FirebaseDatabase
//test
class MyOrdersDetailTableVC: UITableViewController {

  
  var works = [String]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      var worksRef: FIRDatabaseReference!
          worksRef = FIRDatabase.database().reference().child("orders").child(selectedOrderNumber).child("works")
      
      worksRef.observe(.childAdded, with: { (snapshot) in
        
        let allWorks = snapshot.value as? NSDictionary
        let mainData = allWorks?["mainData"]  as? String ?? ""
        let price = allWorks?["price"]  as? String ?? ""
        let ndsprice = allWorks?["ndsprice"]  as? String ?? ""
        
        self.works.append("\(mainData)\nЦена:\(price)\nЦена с НДС: \(ndsprice)")
      
        self.tableView.insertRows(at: [IndexPath(row: self.works.count-1, section: 1)], with: UITableViewRowAnimation.automatic)
        
      })
   
     }


    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 2
    }

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      if section == 0 {
        return 1
      }
        return works.count
    }
  
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return 180
    }
    return 120
  }

  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "Основная Информация"
    }
    return "Работы"
  }
  
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
      cell.textLabel?.numberOfLines = 10
      cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
     
      
      if indexPath.section == 0 {
        
        cell.textLabel?.text = ("\(selectedOrderNumber)\n\n\(selectedOrderMainInfo)")
        
      }
      
      if indexPath.section == 1 {
        
         cell.textLabel?.text = self.works[indexPath.row]
      
      }
    
        return cell
    }
  
}
