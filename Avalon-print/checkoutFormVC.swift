//
//  checkoutFormVC.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/11/16.
//  Copyright © 2016 Константин. All rights reserved.
//

import UIKit
import DeckTransition
import FirebaseDatabase
import FirebaseAuth



class checkoutFormVC: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var nameSurnameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var layoutLinkTF: UITextField!
    @IBOutlet weak var commentsTV: UITextView!
    @IBOutlet weak var deliveryAdress: UITextField!
    @IBOutlet weak var deliveryTime: UITextField!
    
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var layoutDevSwitch: UISwitch!
    @IBOutlet weak var deliverySwitch: UISwitch!
    
    @IBOutlet weak var checkOutButton: ButtonMockup!
    @IBOutlet weak var attachLayoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentsTV.clipsToBounds = true
        commentsTV.layer.cornerRadius = 5
        
        mainScrollView.delegate = self
        nameSurnameTF.delegate = self
        emailTF.delegate = self
        phoneTF.delegate = self
        layoutLinkTF.delegate = self
        deliveryAdress.delegate = self
        deliveryTime.delegate = self
        
        self.hideKeyboardWhenTappedAround()

        setFontsForControllers(textfield: [nameSurnameTF,phoneTF, emailTF, layoutLinkTF, deliveryAdress, deliveryTime], textview: commentsTV, label: commentsLabel)
        
        localyRetrieveUserData()
        validateRegistraionData()
      
    }
    
    
    @IBAction func layoutDevSwitchStateChanged(_ sender: Any) {
        
        if layoutDevSwitch.isOn == true {
            attachLayoutButton.isEnabled = false
            textfieldState(textField: layoutLinkTF, state: false)
        } else {
            attachLayoutButton.isEnabled = true
            textfieldState(textField: layoutLinkTF, state: true)
        }
    }
    
    
    @IBAction func deliverySwitchStateChanged(_ sender: Any) {
        
        if deliverySwitch.isOn == true {
            
            textfieldState(textField: deliveryAdress, state: true)
            textfieldState(textField: deliveryTime, state: true)
            
        } else {
            
            textfieldState(textField: deliveryAdress, state: false)
            textfieldState(textField: deliveryTime, state: false)
            
        }
    }
    
    
    @IBAction func dismissOrder(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func checkOutButtonClicked(_ sender: Any) {
        print("checkOutButton clicked")
    }
    
    
    @IBAction func nameSurnameEditingChanged(_ sender: Any) { validateRegistraionData() }
    @IBAction func phoneNumberEditingChanged(_ sender: Any) { validateRegistraionData() }
    @IBAction func emailEditingChanged(_ sender: Any) { validateRegistraionData() }

  
  fileprivate func localyRetrieveUserData () {
     if FIRAuth.auth()?.currentUser != nil && FIRAuth.auth()?.currentUser?.isEmailVerified == true {
    var ref: FIRDatabaseReference!
    ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
    
    ref.observeSingleEvent(of: .value, with: { snapshot in
      
      if !snapshot.exists() { return }
      
      let mainUserData = snapshot.value as? NSDictionary
      
      if let userNameSurname = mainUserData?["nameSurname"] as? String  {
        self.nameSurnameTF.text = userNameSurname
     
      }
      
      
      if let userPhoneNumber = mainUserData?["PhoneNumber"] as? String  {
        self.phoneTF.text = userPhoneNumber
      }
    })
    
      emailTF.text = FIRAuth.auth()!.currentUser!.email!
     } else {
       nameSurnameTF.text = ""
       phoneTF.text = ""
       emailTF.text = ""
    }
  }
  
  
    func setFontsForControllers(textfield: [UITextField], textview: UITextView, label: UILabel ) {
         if screenSize.height < 667 {
            textview.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            label.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            
            for textField in textfield {
                textField.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            }
        }
    }
    
    
    
    func textfieldState(textField: UITextField, state: Bool ) {
        
        if state == true {
            
             textField.isEnabled = true
            
             UIView.animate(withDuration: 0.3, animations: {
                textField.alpha = 0.9 })
            
        } else {
            
              textField.isEnabled = false
              textField.text = ""
            
              UIView.animate(withDuration: 0.3, animations: {
                textField.alpha = 0.5 })

        }
   
    }
    
    
    func validateRegistraionData () {
        let characterSetEmail = NSCharacterSet(charactersIn: "@")
        let characterSetEmail1 = NSCharacterSet(charactersIn: ".")
        let badCharacterSetEmail = NSCharacterSet(charactersIn: "!`~,/?|'\'';:#^&*=")
        let badCharacterSetPhoneNumber = NSCharacterSet(charactersIn: "@$%.><!`~,/?|'\'';:#^&*=_+{}[]")
        
        
        
        if (nameSurnameTF.text?.characters.count)! < 2 ||
            (phoneTF.text?.characters.count)! < 10 ||
            (phoneTF.text?.characters.count)! > 20 ||
            phoneTF.text?.rangeOfCharacter(from: badCharacterSetPhoneNumber as CharacterSet, options: .caseInsensitive ) != nil ||
            (emailTF.text?.characters.count)! < 5 ||
            emailTF.text?.rangeOfCharacter(from: characterSetEmail as CharacterSet, options: .caseInsensitive ) == nil ||
            emailTF.text?.rangeOfCharacter(from: characterSetEmail1 as CharacterSet, options: .caseInsensitive ) == nil ||
            emailTF.text?.rangeOfCharacter(from: badCharacterSetEmail as CharacterSet, options: .caseInsensitive ) != nil  {
            
            checkOutButton.isEnabled = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.checkOutButton.alpha = 0.6 })
            
        } else {
            checkOutButton.isEnabled = true
            
            UIView.animate(withDuration: 0.5, animations: {
                self.checkOutButton.alpha = 1.0 })
        }
    }
    

}


 extension checkoutFormVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isEqual(mainScrollView) else {
            return
        }
        
        if let delegate = transitioningDelegate as? DeckTransitioningDelegate {
            if scrollView.contentOffset.y > 0 {
                // Normal behaviour if the `scrollView` isn't scrolled to the top
                scrollView.bounces = true
                delegate.isDismissEnabled = false
            } else {
                if scrollView.isDecelerating {
                    // If the `scrollView` is scrolled to the top but is decelerating
                    // that means a swipe has been performed. The view and scrollview are
                    // both translated in response to this.
                    view.transform = CGAffineTransform(translationX: 0, y: -scrollView.contentOffset.y)
                    scrollView.transform = CGAffineTransform(translationX: 0, y: scrollView.contentOffset.y)
                } else {
                    // If the user has panned to the top, the scrollview doesnʼt bounce and
                    // the dismiss gesture is enabled.
                    scrollView.bounces = false
                    delegate.isDismissEnabled = true
                }
            }
        }
    }
}


 extension checkoutFormVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}




