//
//  UserProfile.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/9/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//

import UIKit


class UserProfile: UITableViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userCell: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var navtitle: UINavigationItem!
    
  
    @IBAction func BackButtonClicked(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
      
         view.backgroundColor = UIColor.white
         tableView.backgroundColor = UIColor.white
         tableView.backgroundView = UIImageView(image: UIImage(named: "bucketAndPlaceOrderBGv3"))
        
         navtitle.title = (defaults.object(forKey: "nameSurnameToProfile") as? String)
         userName.text = (defaults.object(forKey: "nameSurnameToProfile") as? String)
         userCell.text = (defaults.object(forKey: "cellNumberToProfile") as? String)
         userEmail.text = (defaults.object(forKey: "emailToProfile") as? String)

    }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 100.0
  }
  func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
    let footerView = UIView(frame:CGRect(x: 0,y: 0,width: 320,height: 40))
    footerView.backgroundColor = UIColor.blue
    
    let loginButton = UIButton(type: .custom)
    loginButton.setTitle("Выход", for: .normal)
    loginButton.addTarget(self, action: #selector(UserProfile.loginAction), for: .touchUpInside)
    loginButton.setTitleColor(UIColor.white, for: .normal)
    loginButton.backgroundColor = UIColor.darkGray
    loginButton.frame = CGRect(x: 0, y: 0, width: 130, height: 30)
    
    footerView.addSubview(loginButton)
    
    return footerView
  }
  
  func loginAction()
  {
    defaults.set("", forKey: "login")
    defaults.set("", forKey: "password")
    defaults.set(false, forKey: "loggedIn")
    
    defaults.set("", forKey: "nameSurnameToProfile")
    defaults.set("", forKey: "emailToProfile")
    defaults.set("", forKey: "cellNumberToProfile")
    
    dismiss(animated: true, completion: nil)  }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if indexPath.row == 7 {

            defaults.set("", forKey: "login")
            defaults.set("", forKey: "password")
            defaults.set(false, forKey: "loggedIn")
            
            defaults.set("", forKey: "nameSurnameToProfile")
            defaults.set("", forKey: "emailToProfile")
            defaults.set("", forKey: "cellNumberToProfile")
            
            dismiss(animated: true, completion: nil)
        }
    }
}
