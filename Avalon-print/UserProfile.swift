//
//  UserProfile.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/9/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//

import UIKit
import avalonExtBridge

class UserProfile: UITableViewController {

    @IBOutlet var userName: UILabel!
    @IBOutlet var userCell: UILabel!
    @IBOutlet var userEmail: UILabel!
    @IBOutlet var navtitle: UINavigationItem!
    
  
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
