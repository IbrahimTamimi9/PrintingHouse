//
//  bucketUserFillForm.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/11/16.
//  Copyright © 2016 Константин. All rights reserved.
//

import UIKit
import avalonExtBridge

class bucketUserFillForm: UIViewController {

    @IBOutlet weak var nameTFHeight: NSLayoutConstraint!
    @IBOutlet weak var mailTFHeight: NSLayoutConstraint!
    @IBOutlet weak var phoneTFHeight: NSLayoutConstraint!
    @IBOutlet weak var layoutLinkTFHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var nameSurnameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var layoutLinkTF: UITextField!
    @IBOutlet weak var commentsTV: UITextView!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet var mainView: UIView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTV.clipsToBounds = true
        commentsTV.layer.cornerRadius = 5
        
        nameSurnameTF.text = (defaults.object(forKey: "nameSurnameToProfile") as? String)
        phoneTF.text = (defaults.object(forKey: "cellNumberToProfile") as? String)
        emailTF.text = (defaults.object(forKey: "emailToProfile") as? String)

        
        if screenSize.height < 667 {
            nameTFHeight.constant = 40
            mailTFHeight.constant = 40
            phoneTFHeight.constant = 40
            layoutLinkTFHeight.constant = 40
            
            nameSurnameTF.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            phoneTF.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            emailTF.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            layoutLinkTF.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            commentsTV.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            commentsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            
            
        }
    }
    
    
    @IBAction func dismissOrder(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closeKeyboard()
    }

}
