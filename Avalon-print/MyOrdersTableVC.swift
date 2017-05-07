//
//  MyOrdersTableVC.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 1/30/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

var selectedOrderNumber = String()
var selectedOrderMainInfo = String()


class MyOrdersTableVC: UITableViewController {

  var selectedOrderWorks = [String]()
  var ordersHistoryArray = [String]()
  var orderKeys = [String]()
  
 
  
    override func viewDidLoad() {
        super.viewDidLoad()
  
     navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
     tableView.backgroundView = UIImageView(image: UIImage(named: "bucketAndPlaceOrderBGv3"))
      
     checkInternetConnectionForFutureActivityIndicatorBehavior()
      
       var commentsRef: FIRDatabaseReference!
           commentsRef = FIRDatabase.database().reference().child("orders")
     
       let sortedRef = commentsRef.queryOrdered(byChild: "createdAt")
      
       sortedRef.queryLimited(toFirst: 9999999).observe(.childAdded, with: { (snapshot) -> Void in
      
        let allOrders = snapshot.value as? NSDictionary
        
        let userInfo = allOrders?["userInfo"] as? NSDictionary
        let uniqueIDofCustomer = userInfo?["userUniqueID"]  as? String ?? ""
        let orderInfo = allOrders?["orderInfo"] as? NSDictionary
        let dateOfPlacement = orderInfo?["dateOfPlacement"] as? String ?? ""
        let orderStatus = orderInfo?["orderStatus"] as? String ?? ""
        let fullPrice = orderInfo?["fullPrice"]  as? Double ?? 0.0
        
        
        if FIRAuth.auth()?.currentUser?.uid == uniqueIDofCustomer {
          
          let keys = snapshot.key
          
          self.orderKeys.append(keys)
        
          self.ordersHistoryArray.append("\nДата поступления заказа: \(dateOfPlacement)\n\nСтатус заказа: \(orderStatus)\n\nИтого к оплате: \(fullPrice) грн.")
          
          
         
          
          self.tableView.insertRows(at: [IndexPath(row: self.ordersHistoryArray.count - 1, section: 0)], with: UITableViewRowAnimation.automatic)
          
          }
        
       
       ARSLineProgress.hide()
      })
      
  }

  
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150.0
  }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return ordersHistoryArray.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
            cell.textLabel?.numberOfLines = 1
            cell.detailTextLabel?.numberOfLines = 6
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
     
      cell.textLabel?.text = "\(orderKeys[indexPath.row])"
      
      cell.detailTextLabel?.text = ordersHistoryArray[indexPath.row]
      
      
    
        return cell
    }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let cell:UITableViewCell? = tableView.cellForRow(at: indexPath)
    
    
    
    if cell?.textLabel?.text == orderKeys[indexPath.row] {
      print("!!!EQUALS")
      selectedOrderNumber = orderKeys[indexPath.row]
      selectedOrderMainInfo = ordersHistoryArray[indexPath.row]
      
    } else {
      
      print("notEquals")
      
  }
 
    
    
    let destination = storyboard?.instantiateViewController(withIdentifier: "MyOrdersDetailTableVC") as! MyOrdersDetailTableVC
        navigationController?.pushViewController(destination, animated: true)
    
  }
  
  
  
  func checkInternetConnectionForFutureActivityIndicatorBehavior () {
    
    if  currentReachabilityStatus != .notReachable {
      //connected
      ARSLineProgress.show()
    } else {
      //not connected
      
    }
    
  }
  
}
