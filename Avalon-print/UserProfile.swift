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
  
   let initialImageView = InitialImageView()
  
   let headerView = UIView()
  
   var nameLabel = UILabel()
  
   var nameToImage = ""
  
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
  
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
   
    headerView.backgroundColor = UIColor.white
    
    let yPositionLabel = (96 - 10)/2
    let yPositionImage = (headerView.frame.height + 35)/2

    
    initialImageView.frame =  CGRect(x: 10, y: yPositionImage, width: 65, height: 65)
    nameLabel.frame =  CGRect(x: Int(initialImageView.frame.width + 20), y: yPositionLabel, width: 200, height: 20)
    nameLabel.font = UIFont.boldSystemFont(ofSize: 17)

    headerView.addSubview(initialImageView)
    headerView.addSubview(nameLabel)
    
    return headerView
  }
  
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 96
  }
  
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 46
  }
  

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.numberOfLines = 6
    cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
    
    if indexPath.row == 0 {
      //cell.isHidden = true
      cell.textLabel?.text = "Установить фотографию профиля"
      cell.accessoryType = .none
      cell.textLabel?.textColor = UIColor.blue
      cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
    if indexPath.row == 1 {
      cell.isHidden = true
    }
    
    if indexPath.row == 2 {
       cell.textLabel?.text = "Мои заказы"
    }
    
    if indexPath.row == 3 {
      cell.textLabel?.text = "Редактировать профиль"
    }
   
    if indexPath.row == 4 {
      cell.textLabel?.text = "Обратная связь"
    }
    
    if indexPath.row == 5 {
      cell.textLabel?.text = "Уведомления"
    }
      
    if indexPath.row == 6 {
      cell.textLabel?.textColor = UIColor.red
      cell.textLabel?.text = "Выйти"
      cell.accessoryType = .none
    }
  
    
    return cell
  }
  
  
 override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
 
  
  if nameLabel.text?.isNotEmpty == true {
     ARSLineProgress.hide()
    
    UIView.animate(withDuration: 0.1, animations: {
      self.headerView.alpha = 1
      cell.alpha = 1
    
    })
   
  } else {
    
    self.headerView.alpha = 0
    cell.alpha = 0
    
     ARSLineProgress.show()
    
    
  }
  
 
  var ref: FIRDatabaseReference!
  ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
  
  ref.observeSingleEvent(of: .value, with: { snapshot in
    
    if !snapshot.exists() { return }
    
    let mainUserData = snapshot.value as? NSDictionary
    
    if let userNameSurname = mainUserData?["nameSurname"] as? String  {
      self.initialImageView.setImageWithName(name: userNameSurname, randomColor: true)
      
      self.nameLabel.text = userNameSurname

      UIView.animate(withDuration: 0.1, animations: {
        self.headerView.alpha = 1
        cell.alpha = 1
        
        ARSLineProgress.hide()
      })
      
      
    }
  })
  
  }
  
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        
        if indexPath.row == 2 {
          let destination = storyboard?.instantiateViewController(withIdentifier: "MyOrdersTableVC") as! MyOrdersTableVC
          navigationController?.pushViewController(destination, animated: true)
        }
  
        if indexPath.row == 3 {
          let destination = storyboard?.instantiateViewController(withIdentifier: "UpdateUserProfile") as! UpdateUserProfile
          navigationController?.pushViewController(destination, animated: true)
        }
          if indexPath.row == 4 { }
          
          if indexPath.row == 5 { }
          
  
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
}
