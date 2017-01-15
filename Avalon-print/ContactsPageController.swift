//
//  MainPageController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/1/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
// 


import UIKit

class ContactsPageController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var leftImageViewConstraint: NSLayoutConstraint!

    
    override func viewWillDisappear(_ animated: Bool) {
        leftImageViewConstraint.constant = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        leftImageViewConstraint.constant = -25
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
         applyMotionEffect(toView: backgroundImageView, magnitude: 25)
    }
    
    @IBAction func openMap(_ sender: Any) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "map") as! map
                navigationController?.pushViewController(destination, animated: true)
    }
}
