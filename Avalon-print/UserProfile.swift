//
//  UserProfile.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/9/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//

import UIKit


class UserProfile: UITableViewController {

  //  @IBOutlet weak var userNameTitle: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userCell: UILabel!
    @IBOutlet var userEmail: UILabel!
    
   // @IBOutlet var logOutButton: UIButton!
   // @IBOutlet weak var mainView: UIView!
    
    @IBOutlet var navtitle: UINavigationItem!
    
//    @IBAction func logOut(_ sender: Any) {
//        //UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.slide)
//        defaults.set("", forKey: "login")
//        defaults.set("", forKey: "password")
//        defaults.set(false, forKey: "loggedIn")
//        
//        defaults.set("", forKey: "nameSurnameToProfile")
//        defaults.set("", forKey: "emailToProfile")
//        defaults.set("", forKey: "cellNumberToProfile")
//        
//        dismiss(animated: true, completion: nil)
//    }
    
  
    @IBAction func BackButtonClicked(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        tableView.backgroundColor = UIColor.white
        tableView.backgroundView = UIImageView(image: UIImage(named: "bucketAndPlaceOrderBGv3"))
        userName.text = (defaults.object(forKey: "nameSurnameToProfile") as? String)
        navtitle.title = (defaults.object(forKey: "nameSurnameToProfile") as? String)
        userCell.text = (defaults.object(forKey: "cellNumberToProfile") as? String)
        userEmail.text = (defaults.object(forKey: "emailToProfile") as? String)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeUserProfile(_ sender: Any) {
         // UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.slide)
          dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     //   let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if indexPath.row == 2 {
           // appDelegate.centerViewController = appDelegate.sourcePageViewController()
        } else if indexPath.row == 7 {
           // appDelegate.centerViewController = appDelegate.drawerSettingsViewController()
            defaults.set("", forKey: "login")
            defaults.set("", forKey: "password")
            defaults.set(false, forKey: "loggedIn")
            
            defaults.set("", forKey: "nameSurnameToProfile")
            defaults.set("", forKey: "emailToProfile")
            defaults.set("", forKey: "cellNumberToProfile")
            
            dismiss(animated: true, completion: nil)
        }
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//      //  cell.backgroundColor = UIColor.clear
//    }

}
