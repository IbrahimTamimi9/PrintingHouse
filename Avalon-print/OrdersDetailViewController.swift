//
//  OrdersDetailViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/2/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import FirebaseDatabase


class OrdersDetailViewController: UIViewController {
  
  let ordersDetailTableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
  
  let ordersDetailCellId = "ordersDetailCell"
  
  var productionTypes = [String]()
  var mainDataBlocks = [String]()
  var postPrintBlocks = [String]()
  var priceBlocks = [String]()
  var layoutURLs = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(ordersDetailTableView)
    
    view.backgroundColor = UIColor.white
    ordersDetailTableView.backgroundColor = UIColor.white
    ordersDetailTableView.separatorColor = UIColor.clear
  
    self.ordersDetailTableView.delegate = self
    self.ordersDetailTableView.dataSource = self
    ordersDetailTableView.register(OrdersDetailTableViewCell.self, forCellReuseIdentifier: ordersDetailCellId)
    
    setConstraints()
    observeWorks()
    
  }

  
  fileprivate func observeWorks() {
    
    var worksRef: DatabaseReference!
    worksRef = Database.database().reference().child("orders").child(selectedOrderNumber).child("works")
    
    worksRef.observe(.childAdded, with: { (snapshot) in
      
      let allWorks = snapshot.value as? NSDictionary
      
      let productionType =  allWorks?["productionType"]  as? String ?? ""
      let postprint = allWorks?["postprint"]  as? String ?? ""
      
      
      let mainData = allWorks?["mainData"]  as? String ?? ""
      let price = allWorks?["price"]  as? String ?? ""
      let ndsprice = allWorks?["ndsprice"]  as? String ?? ""
      
      let printLayoutURL = allWorks?["printLayoutURL"] as? String ?? ""
      
      
      self.productionTypes.append(productionType)
      self.mainDataBlocks.append(mainData)
      self.postPrintBlocks.append(postprint)
      self.priceBlocks.append("\nЦена:\(price) грн.\nЦена с НДС: \(ndsprice) грн.")
      
      self.layoutURLs.append(printLayoutURL)
      
      self.ordersDetailTableView.insertRows(at: [IndexPath(row: self.productionTypes.count-1, section: 1)], with: UITableViewRowAnimation.automatic)
      
    })
  }
  
  
  fileprivate func setConstraints() {

    ordersDetailTableView.translatesAutoresizingMaskIntoConstraints = false
    ordersDetailTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    ordersDetailTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
    ordersDetailTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    ordersDetailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
  }
  
  func moreButtonTapped (_ sender: UIButton) {
    
    guard let cell = sender.superview?.superview?.superview as? OrdersDetailTableViewCell else {
      return
    }
    
    let indexPath = ordersDetailTableView.indexPath(for: cell)
    
    let row = indexPath?.row
    
    let destination = WorksDetailTableViewController()
    
    destination.layoutURL = layoutURLs[row!]
    destination.productType = self.productionTypes[row!]
    destination.mainData = self.mainDataBlocks[row!]
    destination.postprint = self.postPrintBlocks[row!]
    destination.price = self.priceBlocks[row!]
    
    self.navigationController?.pushViewController(destination, animated: true)
  }

}


extension OrdersDetailViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 180
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 65
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? OrdersDetailTableViewCell else { return }
    
    cell.selectionStyle = .none
    
    if indexPath.section == 0 {
      
     DispatchQueue.main.async {
      
      cell.containerView.mainData.text = selectedOrderMainInfo
        
      cell.containerView.price.text = selectedOrderPrice
        
      cell.containerView.moreButton.isHidden = true
     }
    }
    
    if indexPath.section == 1 {
      
      DispatchQueue.main.async {
       
      
        
        cell.containerView.productionType.text = self.productionTypes[indexPath.row]
        
        cell.containerView.mainData.text = self.mainDataBlocks[indexPath.row]
        
        cell.containerView.price.text = self.priceBlocks[indexPath.row]
        
        cell.containerView.moreButton.isHidden = false
      }
    }
  }
  
}


extension OrdersDetailViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = ordersDetailTableView.dequeueReusableCell(withIdentifier: ordersDetailCellId, for: indexPath) as! ShoppingCartTableViewCell
    
    
        return ordersDetailTableView.dequeueReusableCell(withIdentifier: ordersDetailCellId, for: indexPath) as! OrdersDetailTableViewCell// cell
  }
  

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if section == 0 {
      return 1
    }
    return productionTypes.count
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "Заказ"
    }
    return "Работы"
  }
  
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as! UITableViewHeaderFooterView
    header.textLabel?.backgroundColor = self.view.backgroundColor
    if section == 0 {
      
      header.textLabel?.text = "Заказ"
      header.textLabel?.font = UIFont.systemFont(ofSize: 34)
      header.textLabel?.textColor = UIColor.black
    }
    
    if section == 1 {
      
      header.textLabel?.text = "Работы"
      header.textLabel?.font = UIFont.systemFont(ofSize: 22)
      header.textLabel?.textColor = UIColor.black
    }
  }
  
}

