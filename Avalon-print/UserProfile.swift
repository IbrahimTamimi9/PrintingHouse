//
//  UserProfile.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/9/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class UserProfile: UITableViewController {
  
  
    @IBOutlet weak var navtitle: UINavigationItem!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
         navtitle.title = "Профиль"
      
         view.backgroundColor = UIColor.white
         tableView.backgroundColor = UIColor.white
         tableView.backgroundView = UIImageView(image: UIImage(named: "bucketAndPlaceOrderBGv3"))
         navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
         navigationItem.backBarButtonItem?.tintColor = UIColor.white
}
  
  
    @IBAction func BackButtonClicked(_ sender: Any) {
      dismiss(animated: true, completion: nil)
    }
  
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 6
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
        headerView.backgroundColor = UIColor.white
  
    return headerView
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 130
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 44
  }
  

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.numberOfLines = 6
    cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
    
    if indexPath.row == 0 {
      cell.isHidden = true
    }
    
    if indexPath.row == 1 {
       cell.textLabel?.text = "Мои заказы"
    }
    
    if indexPath.row == 2 {
      cell.textLabel?.text = "Редактировать профиль"
    }
   
    if indexPath.row == 3 {
      cell.textLabel?.text = "Обратная связь"
    }
    
      if indexPath.row == 4 {
        cell.textLabel?.text = "Уведомления"
      }
      
      if indexPath.row == 5 {
        cell.textLabel?.textColor = UIColor.red
        cell.textLabel?.text = "Выйти"
        cell.accessoryType = .none
      }
    
    
    return cell
  }
  
  
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        
        if indexPath.row == 1 {
          let destination = storyboard?.instantiateViewController(withIdentifier: "MyOrdersTableVC") as! MyOrdersTableVC
          navigationController?.pushViewController(destination, animated: true)
        }
  
        if indexPath.row == 2 {
          let destination = storyboard?.instantiateViewController(withIdentifier: "UpdateUserProfile") as! UpdateUserProfile
          navigationController?.pushViewController(destination, animated: true)
        }
          if indexPath.row == 3 { }
          
          if indexPath.row == 4 { }
          
  
          if indexPath.row == 5 {
  
            let firebaseAuth = FIRAuth.auth()
            do {
              try firebaseAuth?.signOut()
              dismiss(animated: true, completion: nil)
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
        }
    }
}
