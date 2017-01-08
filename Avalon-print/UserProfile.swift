//
//  UserProfile.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/9/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//

import UIKit


class UserProfile: UIViewController {

    @IBOutlet weak var userNameTitle: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userCell: UILabel!
   @IBOutlet var userEmail: UILabel!
    
    @IBOutlet var logOutButton: UIButton!
    @IBAction func logOut(_ sender: Any) {
        
    //UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.slide)
        defaults.set("", forKey: "login")
        defaults.set("", forKey: "password")
        defaults.set(false, forKey: "loggedIn")
        
        defaults.set("", forKey: "nameSurnameToProfile")
        defaults.set("", forKey: "emailToProfile")
        defaults.set("", forKey: "cellNumberToProfile")


       
        
        dismiss(animated: true, completion: nil)
    
    }
    
    
  
   
    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        userName.text = (defaults.object(forKey: "nameSurnameToProfile") as? String)
        userNameTitle.text = (defaults.object(forKey: "nameSurnameToProfile") as? String)
        userCell.text = (defaults.object(forKey: "cellNumberToProfile") as? String)
        userEmail.text = (defaults.object(forKey: "emailToProfile") as? String)

        // Do any additional setup after loading the view.
        
        mainView.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = mainView.bounds
        mainView.insertSubview(blurEffectView, at: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeUserProfile(_ sender: Any) {
         // UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.slide)
          dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
