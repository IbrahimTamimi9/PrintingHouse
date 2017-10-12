//
//  LoginViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/30/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
  
  let loginContainerView = LoginContainerView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
  

    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.backgroundColor = UIColor.white
        view.addSubview(loginContainerView)
      
      let leftButton = UIBarButtonItem(image: UIImage(named: "ChevronLeft"), style: .plain, target: self, action: #selector(LoginViewController.leftBarButtonTapped))
      navigationItem.leftBarButtonItem = leftButton
    }
  
  
  @objc func leftBarButtonTapped () {
    dismiss(animated: true, completion: nil)
  }
}


extension LoginViewController {
  
 @objc func resetPasswordButtonTapped () {
    
    let controller = PasswordResetViewController()
    let transitionDelegate = DeckTransitioningDelegate()
    controller.transitioningDelegate = transitionDelegate
    controller.modalPresentationStyle = .custom
    present(controller, animated: true, completion: nil)
  }

  
 @objc func registerButtonTapped () {
    
    let controller = RegistrationViewController()
    let transitionDelegate = DeckTransitioningDelegate()
    controller.transitioningDelegate = transitionDelegate
    controller.modalPresentationStyle = .custom
    present(controller, animated: true, completion: nil)
  }

  
@objc func onLogInButtonClicked(_ sender: Any) {
    ARSLineProgress.show()
    view.isUserInteractionEnabled = false
    
    
    Auth.auth().signIn(withEmail: loginContainerView.emailField.text!, password: loginContainerView.passwordField.text!) {
      (user, error) in
      
      if error != nil  {
        //Tells the user that there is an error and then gets firebase to tell them the error
        let alertController = UIAlertController(title: NSLocalizedString("LoginViewController.alertVC.title", comment: ""), message: error?.localizedDescription, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        
        ARSLineProgress.hide()
        self.view.isUserInteractionEnabled = true
        
        
        self.present(alertController, animated: true, completion: nil)
      }
      
      if let user = Auth.auth().currentUser {
        if !user.isEmailVerified {
          let alertVC = UIAlertController(title: NSLocalizedString("LoginViewController.alertVC.title", comment: ""), message: "\(NSLocalizedString("LoginViewController.alertVC.message", comment: "")) \(self.loginContainerView.emailField.text!).", preferredStyle: .alert)
          
          let alertActionOkay = UIAlertAction(
          title: NSLocalizedString("LoginViewController.alertActionOkay.title", comment: ""), style: .default) {
            (_) in
            user.sendEmailVerification(completion: nil)
          }
          let alertActionCancel = UIAlertAction(title: NSLocalizedString("LoginViewController.alertActionCancel.title", comment: ""), style: .default, handler: nil)
          
          alertVC.addAction(alertActionOkay)
          alertVC.addAction(alertActionCancel)
          
          
          ARSLineProgress.hide()
          self.view.isUserInteractionEnabled = true
          
          
          self.present(alertVC, animated: true, completion: nil)
        } else {
          
          print ("Email verified. Signing in...")
          
          ARSLineProgress.showSuccess()
          self.view.isUserInteractionEnabled = true
          self.dismiss(animated: true, completion: nil)
          
        }
      }
    }
  }
  
  
 @objc func fieldsValidation(_ sender: Any) { validation() }
  
  func validation () {
    let characterSet = NSCharacterSet(charactersIn: "@")
    let badCharacterSet = NSCharacterSet(charactersIn: "!`~,/?|'\'';:#^&*=")
    
    if (loginContainerView.emailField.text?.characters.count)! < 5 || loginContainerView.emailField.text?.rangeOfCharacter(from: characterSet as CharacterSet, options: .caseInsensitive ) == nil || loginContainerView.emailField.text?.rangeOfCharacter(from: badCharacterSet as CharacterSet, options: .caseInsensitive ) != nil || (loginContainerView.passwordField.text?.characters.count)! < 6 {
      
      loginContainerView.login.isEnabled = false
  
    } else {
      
      loginContainerView.login.isEnabled = true
     
    }
  }
  
  
  func closeKeyboard() {
    self.view.endEditing(true)
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    closeKeyboard()
  }
  
}
