//
//  PasswordResetViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/30/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import FirebaseAuth

class PasswordResetViewController: UIViewController {
  
  let passwordResetContainerView = PasswordResetContainerView()

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


extension PasswordResetViewController {
  
 @objc func recoverEmailTextFieldEditingChanged(_ sender: Any) { validateEmailTextField () }
  
 @objc func recoverPasswordButtonDidTap(_ sender: Any) {
    
    ARSLineProgress.show()
    view.isUserInteractionEnabled = false
    
    Auth.auth().sendPasswordReset(withEmail: passwordResetContainerView.email.text!) { (error) in
      // ...
      if error != nil {
        let alertController = UIAlertController(title: NSLocalizedString("LoginViewController.alertVC.title", comment: ""), message: error?.localizedDescription, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        ARSLineProgress.hide()
        self.view.isUserInteractionEnabled = true
        
        self.present(alertController, animated: true, completion: nil)
        
      } else {
        
        // "Письмо для восстановления было отправлено на ваш e-mail адрес."
        
        let alert = UIAlertController(title: "", message: NSLocalizedString("PasswordResetViewController.alert.message", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
          UIAlertAction in
          
          self.dismiss(animated: true, completion: nil)
        } )
        
        ARSLineProgress.hide()
        self.view.isUserInteractionEnabled = true
        
        self.present(alert, animated: true, completion: nil)
        
      }
    }
  }
  

  func validateEmailTextField () {
    let characterSetEmail = NSCharacterSet(charactersIn: "@")
    let characterSetEmail1 = NSCharacterSet(charactersIn: ".")
    let badCharacterSetEmail = NSCharacterSet(charactersIn: "!`~,/?|'\'';:#^&*=")
    
    if (passwordResetContainerView.email.text?.characters.count)! < 5 ||
      
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
