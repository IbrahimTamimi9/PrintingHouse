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
    return 7
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 20
    }
    if indexPath.row == 3 {
      return 130
    }
    
    return 44
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.numberOfLines = 6
    cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
    
   
    
    if indexPath.row == 1 {
       cell.textLabel?.text = "Мои заказы"
    }
    
    if indexPath.row == 3 {
     localyRetrieveUserData(cell: cell)
      //cell.textLabel?.text = ("\(name!)\n\n\(phone!)\n\n\(email!)")
    }
   
    if indexPath.row == 6 {
      cell.textLabel?.textColor = UIColor.red
      cell.textLabel?.text = "Выйти"
      cell.accessoryType = .none
    }
    
    if indexPath.row != 1 && indexPath.row != 3 && indexPath.row != 6 {
      cell.isHidden = true
    }
    
    
    
    return cell
  }
  
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        if indexPath.row == 1 {
          let destination = storyboard?.instantiateViewController(withIdentifier: "MyOrdersTableVC") as! MyOrdersTableVC
          navigationController?.pushViewController(destination, animated: true)
        }
  
        if indexPath.row == 3 {
          let destination = storyboard?.instantiateViewController(withIdentifier: "UpdateUserProfile") as! UpdateUserProfile
          navigationController?.pushViewController(destination, animated: true)
        }
  
          if indexPath.row == 6 {
  
            let firebaseAuth = FIRAuth.auth()
            do {
              try firebaseAuth?.signOut()
              dismiss(animated: true, completion: nil)
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
  
          }
      }
  
  func localyRetrieveUserData (cell: UITableViewCell) {
    
    var ref: FIRDatabaseReference!
    ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
    
    ref.observeSingleEvent(of: .value, with: { snapshot in
      
      if !snapshot.exists() { return }
      
      let mainUserData = snapshot.value as? NSDictionary
      
       let userNameSurname = mainUserData?["nameSurname"] as? String
        //self.nameSurname.text = userNameSurname
      
       let userPhoneNumber = mainUserData?["PhoneNumber"] as? String
        //self.phoneNumber.text = userPhoneNumber
    let userEmail = FIRAuth.auth()!.currentUser!.email!
      
      cell.textLabel?.text = ("\(userNameSurname!)\n\n\(userPhoneNumber!)\n\n\(userEmail)")
      
    })
    
   
    
    
  }
}
