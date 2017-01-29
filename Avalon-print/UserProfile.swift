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

struct userData {
  static var name = String()
  static var phone = String()
  static var email = String()
}



class UserProfile: UITableViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userCell: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var navtitle: UINavigationItem!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
         view.backgroundColor = UIColor.white
         tableView.backgroundColor = UIColor.white
         tableView.backgroundView = UIImageView(image: UIImage(named: "bucketAndPlaceOrderBGv3"))
         navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
         navigationItem.backBarButtonItem?.tintColor = UIColor.white
      
         localyRetrieveUserData()
}
  
  
    @IBAction func BackButtonClicked(_ sender: Any) {
      dismiss(animated: true, completion: nil)
    }
 
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      
      if indexPath.row == 3 {
        let destination = storyboard?.instantiateViewController(withIdentifier: "UpdateUserProfile") as! UpdateUserProfile
        navigationController?.pushViewController(destination, animated: true)
      }
      
        if indexPath.row == 7 {
          
          let firebaseAuth = FIRAuth.auth()
          do {
            try firebaseAuth?.signOut()
            dismiss(animated: true, completion: nil)
          } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
          }

        }
    }
  
  
  func localyRetrieveUserData () {
    
    var ref: FIRDatabaseReference!
    ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
    
    ref.observeSingleEvent(of: .value, with: { snapshot in
      
      if !snapshot.exists() { return }
      
      let mainUserData = snapshot.value as? NSDictionary
      
      if let userNameSurname = mainUserData?["nameSurname"] as? String  {
        self.userName.text = userNameSurname
        self.navtitle.title = userNameSurname
      }
      
      
      if let userPhoneNumber = mainUserData?["PhoneNumber"] as? String  {
        self.userCell.text = userPhoneNumber
      }
    })
    
    userEmail.text = FIRAuth.auth()!.currentUser!.email!
    
    
  }
}
