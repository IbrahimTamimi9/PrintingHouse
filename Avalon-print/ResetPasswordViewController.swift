//
//  ResetPasswordViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/6/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class ResetPasswordViewController: UIViewController {

  let passwordResetContainerView = ResetPasswordContainerView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.white
    
    view.addSubview(passwordResetContainerView)
    
    setConstraints()
    hideKeyboardWhenTappedAround()
    
  }
  
  fileprivate func setConstraints() {
    passwordResetContainerView.translatesAutoresizingMaskIntoConstraints = false
    passwordResetContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    passwordResetContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    passwordResetContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    passwordResetContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
  }
}


extension ResetPasswordViewController {
  
 @objc func recoverEmailTextFieldEditingChanged(_ sender: Any) { validateEmailTextField () }
  
  
 @objc func recoverPasswordButtonDidTap(_ sender: Any) {
    
    ARSLineProgress.show()
    
    view.isUserInteractionEnabled = false
    
    let credential = EmailAuthProvider.credential(withEmail: passwordResetContainerView.email.text!, password: passwordResetContainerView.oldPassword.text!)//
    
    
    
    Auth.auth().currentUser?.reauthenticate(with: credential) { error in
      if error != nil {
        
        let alert = UIAlertController(title: "Error", message: error?.localizedDescription , preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
          UIAlertAction in })
        
        ARSLineProgress.hide()
        self.view.isUserInteractionEnabled = true
        
        self.present(alert, animated: true, completion: nil)

      } else {
        
        Auth.auth().currentUser?.updatePassword(to: self.passwordResetContainerView.newPassword.text!, completion: { (error) in
        
          if error != nil {
            
            let alertController = UIAlertController(title: "Ошибка", message: error?.localizedDescription, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            
            ARSLineProgress.hide()
            
            self.view.isUserInteractionEnabled = true
            
            self.present(alertController, animated: true, completion: nil)
            
          } else {
            
            let alert = UIAlertController(title: "", message: "Password successfuly changed.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
              UIAlertAction in
              
              self.dismiss(animated: true, completion: nil)
            })
            
            ARSLineProgress.hide()
            
            self.view.isUserInteractionEnabled = true
            
            self.present(alert, animated: true, completion: nil)
            
          }
        })
      }
    }
  }
  
  
 @objc func validateEmailTextField () {
    let characterSetEmail = NSCharacterSet(charactersIn: "@")
    let characterSetEmail1 = NSCharacterSet(charactersIn: ".")
    let badCharacterSetEmail = NSCharacterSet(charactersIn: "!`~,/?|'\'';:#^&*=")
    
    if (passwordResetContainerView.email.text?.count)! < 5 ||
      
      passwordResetContainerView.email.text?.rangeOfCharacter(from: characterSetEmail as CharacterSet,
                                                              options: .caseInsensitive ) == nil ||
      passwordResetContainerView.email.text?.rangeOfCharacter(from: characterSetEmail1 as CharacterSet,
                                                              options: .caseInsensitive ) == nil ||
      passwordResetContainerView.email.text?.rangeOfCharacter(from: badCharacterSetEmail as CharacterSet,
                                                              options: .caseInsensitive ) != nil {
    passwordResetContainerView.reset.isEnabled = false
      
    } else {
      
      passwordResetContainerView.reset.isEnabled = true
    }
  }
}
