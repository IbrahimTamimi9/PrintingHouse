//
//  userProfileNavController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 1/18/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class userProfileNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
      //self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
       // self.navigationBar.shadowImage = UIImage()
       // self.navigationBar.isTranslucent = true
        self.view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
