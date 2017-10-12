//
//  OrdersViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/2/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


var selectedOrderNumber = String()
var selectedOrderMainInfo = String()
var selectedOrderPrice = String()


class OrdersViewController: UIViewController {
  
  var selectedOrderWorks = [String]()
  
  var ordersHistoryArray = [String]()
  
  var orderKeys = [String]()
  
  var orderDateOfPlacement = [String]()
  
  var orderStatus = [String]()
  
  var orderPrices = [String]()
  
  let ordersHeaderView = OrdersHeaderVIew()
  
  let ordersTableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
  
  let ordersCellId = "ordersCell"
  
  

    override func viewDidLoad() {
        super.viewDidLoad()
      
      view.backgroundColor = UIColor.white
      ordersTableView.backgroundColor = UIColor.white
     
      
      view.addSubview(ordersHeaderView)
      view.addSubview(ordersTableView)
      
      setConstraints()
      
      ordersTableView.delegate = self
      
      ordersTableView.dataSource = self
      
      ordersHeaderView.segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
      
      ordersTableView.register(OrdersTableViewCell.self, forCellReuseIdentifier: ordersCellId)
      
      checkInternetConnectionForFutureActivityIndicatorBehavior()
      
      observeOrders()
    }
  
  
    fileprivate func setConstraints() {
    
      ordersHeaderView.translatesAutoresizingMaskIntoConstraints = false
      ordersHeaderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
      ordersHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
      ordersHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
      ordersHeaderView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    
    
      ordersTableView.translatesAutoresizingMaskIntoConstraints = false
      ordersTableView.topAnchor.constraint(equalTo: ordersHeaderView.bottomAnchor, constant: 0).isActive = true
      ordersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
      ordersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
      ordersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}


extension OrdersViewController {
  
 fileprivate func resetArrays() {
  
    self.orderKeys.removeAll()
    self.orderDateOfPlacement.removeAll()
    self.orderStatus.removeAll()
    self.ordersHistoryArray.removeAll()
    self.orderPrices.removeAll()
  }
  
  
 @objc func segmentedControlValueChanged() {
  
    switch ordersHeaderView.segmentedControl.selectedSegmentIndex {
    case 0:
      
      resetArrays()
      observeOrders()
      ordersTableView.reloadData()
      break
   
    case 1:
      
      resetArrays()
      observeOrders()
      ordersTableView.reloadData()
      break
      
    default: break
   
    }
  }
  
  
  fileprivate func observeOrders() {
    
    let completedStatus = "Выполнен"
    
 
    
    var commentsRef: DatabaseReference!
    
    commentsRef = Database.database().reference().child("orders")
    
    let sortedRef = commentsRef.queryOrdered(byChild: "createdAt")
    
    sortedRef.observe(.childAdded, with: { (snapshot) in
      
      let allOrders = snapshot.value as? NSDictionary
      
      let userInfo = allOrders?["userInfo"] as? NSDictionary
      let uniqueIDofCustomer = userInfo?["userUniqueID"]  as? String ?? ""
      let orderInfo = allOrders?["orderInfo"] as? NSDictionary
      let dateOfPlacement = orderInfo?["dateOfPlacement"] as? String ?? ""
      let orderStatus = orderInfo?["orderStatus"] as? String ?? ""
      let fullPrice = orderInfo?["fullPrice"]  as? Double ?? 0.0
      let fullNDSPrice = orderInfo?["fullNDSPrice"]  as? Double ?? 0.0
      
      
      if self.ordersHeaderView.segmentedControl.selectedSegmentIndex == 0 {
        
        if Auth.auth().currentUser?.uid == uniqueIDofCustomer && orderStatus != completedStatus {
          
          let keys = snapshot.key
          
          self.orderKeys.append(keys)
          self.orderDateOfPlacement.append(dateOfPlacement)
          self.orderStatus.append(orderStatus)
          self.ordersHistoryArray.append("Дата поступления заказа: \(dateOfPlacement)\n\nСтатус заказа: \(orderStatus)")//\n\nИтого к оплате: \(fullPrice) грн.")
          self.orderPrices.append("Итого к оплате: \(fullPrice) грн.\nС НДС: \(fullNDSPrice) грн.")
          
          self.ordersTableView.insertRows(at: [IndexPath(row: self.ordersHistoryArray.count - 1, section: 0)], with: UITableViewRowAnimation.automatic)
        }
        
      } else {
        
        if Auth.auth().currentUser?.uid == uniqueIDofCustomer && orderStatus == completedStatus {
          
          let keys = snapshot.key
          
          self.orderKeys.append(keys)
          self.orderDateOfPlacement.append(dateOfPlacement)
          self.orderStatus.append(orderStatus)
          self.ordersHistoryArray.append("Дата поступления заказа: \(dateOfPlacement)\n\nСтатус заказа: \(orderStatus)")//\n\nИтого к оплате: \(fullPrice) грн.")
          self.orderPrices.append("Итого к оплате: \(fullPrice) грн.\nС НДС: \(fullNDSPrice) грн.")
          
          self.ordersTableView.insertRows(at: [IndexPath(row: self.ordersHistoryArray.count - 1, section: 0)], with: UITableViewRowAnimation.automatic)
        }
      }
      
      if ARSLineProgress.shown {
        ARSLineProgress.hide()
      }
      
    }, withCancel: { (error) in
      
      ARSLineProgress.hide()
      print(error)
    })

  }
  
  
 fileprivate func checkInternetConnectionForFutureActivityIndicatorBehavior () {
    
    if  currentReachabilityStatus != .notReachable {
      //connected
      ARSLineProgress.ars_showOnView(self.view)
    } else {
      //not connected
    }
  }
  
}


extension OrdersViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 78.0
  }
  
 

}


extension OrdersViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = ordersTableView.dequeueReusableCell(withIdentifier: ordersCellId, for: indexPath) as! OrdersTableViewCell
    
    cell.number.text = "\(indexPath.row + 1)"
    
    cell.title.text = "Заказ за \(orderDateOfPlacement[indexPath.row])"
    
    cell.subtitle.text = "Статус: \(orderStatus[indexPath.row])"
  
    return cell

  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    selectedOrderNumber = orderKeys[indexPath.row]
    selectedOrderMainInfo = ordersHistoryArray[indexPath.row]
    selectedOrderPrice = orderPrices[indexPath.row]
    ordersTableView.deselectRow(at: indexPath, animated: true)
    
    let destination = OrdersDetailViewController()
    self.navigationController?.pushViewController(destination, animated: true)
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return ordersHistoryArray.count
  }
  
}
