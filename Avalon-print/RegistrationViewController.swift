//
//  RegistrationViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/30/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegistrationViewController: UIViewController {
  
  let registrationContainerView = RegistrationContainerView()

  
    override func viewDidLoad() {
        super.viewDidLoad()
            
      view.backgroundColor = UIColor.white
      view.addSubview(registrationContainerView)
      hideKeyboardWhenTappedAround()
      setConstraints()
      setupKeyboardObservers()
    }

  
 fileprivate var containerTopAnchor: NSLayoutConstraint?
 fileprivate func setConstraints() {
    registrationContainerView.translatesAutoresizingMaskIntoConstraints = false
    containerTopAnchor = registrationContainerView.topAnchor.constraint(equalTo: view.topAnchor)
    registrationContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    containerTopAnchor?.isActive = true
    registrationContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    registrationContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
  }
}


extension RegistrationViewController {/* keyboard */
  
  func setupKeyboardObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  
  func handleKeyboardWillShow(_ notification: Notification) {
    let keyboardFrame = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
    let keyboardDuration = ((notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
    
    if registrationContainerView.password.isFirstResponder || registrationContainerView.passwordAgain.isFirstResponder {
  
    containerTopAnchor?.constant = -keyboardFrame!.height
    }
    
    UIView.animate(withDuration: keyboardDuration!, animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  
  func handleKeyboardWillHide(_ notification: Notification) {
    let keyboardDuration = ((notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
    
     containerTopAnchor?.constant = 0
    
    UIView.animate(withDuration: keyboardDuration!, animations: {
      self.view.layoutIfNeeded()
    })
  }
}


extension RegistrationViewController {
  
  func textFieldEditingChanged(_ sender: Any) { validateRegistraionData() }
  
  func validateRegistraionData () {
    
    let characterSetEmail = NSCharacterSet(charactersIn: "@")
    let characterSetEmail1 = NSCharacterSet(charactersIn: ".")
    let badCharacterSetEmail = NSCharacterSet(charactersIn: "!`~,/?|'\'';:#^&*=")
    let badCharacterSetPhoneNumber = NSCharacterSet(charactersIn: "@$%.><!`~,/?|'\'';:#^&*=_+{}[]")
    
    
    if (registrationContainerView.name.text?.characters.count)! < 2 ||
      (registrationContainerView.phone.text?.characters.count)! < 10 ||
      (registrationContainerView.phone.text?.characters.count)! > 12 ||
      registrationContainerView.phone.text?.rangeOfCharacter(from: badCharacterSetPhoneNumber as CharacterSet, options: .caseInsensitive ) != nil ||
      (registrationContainerView.email.text?.characters.count)! < 5 ||
      registrationContainerView.email.text?.rangeOfCharacter(from: characterSetEmail as CharacterSet, options: .caseInsensitive ) == nil ||
      registrationContainerView.email.text?.rangeOfCharacter(from: characterSetEmail1 as CharacterSet, options: .caseInsensitive ) == nil ||
      registrationContainerView.email.text?.rangeOfCharacter(from: badCharacterSetEmail as CharacterSet, options: .caseInsensitive ) != nil ||
      (registrationContainerView.password.text?.characters.count)! < 6 ||
      (registrationContainerView.password.text != registrationContainerView.passwordAgain.text) {
      
      registrationContainerView.register.isEnabled = false
      
    } else {
      
      registrationContainerView.register.isEnabled = true
    }
  }
  
  
  func registerButtonDidTap(_ sender: Any) {
    
    ARSLineProgress.show()
    view.isUserInteractionEnabled = false
    
    Auth.auth().createUser(withEmail: registrationContainerView.email.text!, password: registrationContainerView.password.text!, completion: { authData, error  in
      if error == nil {
        let userData = ["name": self.registrationContainerView.name.text!,
                        "email": self.registrationContainerView.email.text!,
                        "PhoneNumber": self.registrationContainerView.phone.text!,
                        "type": "user" ]
        
        let ref = Database.database().reference()
        ref.child("users").child(authData!.uid).setValue(userData)
        print("Successfuly registered")
        
        Auth.auth().currentUser!.sendEmailVerification(completion: { (error) in
        })
        
     
        let alert = UIAlertController(title: NSLocalizedString("RegistrationViewController.alert.title", comment: ""), message: NSLocalizedString("RegistrationViewController.alert.message", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
          UIAlertAction in
          
          self.dismiss(animated: true, completion: nil)
          
        } )
        
        ARSLineProgress.hide()
        self.view.isUserInteractionEnabled = true
        
        
        self.present(alert, animated: true, completion: nil)
        
        
      } else {
        let alert = UIAlertController(title: NSLocalizedString("RegistrationViewController.alertEmailAlreadyExist.title", comment: ""), message: NSLocalizedString("RegistrationViewController.alertEmailAlreadyExist.message", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        ARSLineProgress.hide()
        self.view.isUserInteractionEnabled = true
        
        
        self.present(alert, animated: true, completion: nil)
        
      }
    })
    
  }

}


