//
//  PasswordResetVC.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 1/29/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import FirebaseAuth

class PasswordResetVC: UIViewController {

  
  @IBOutlet weak var recoverEmailTextField: UITextField!
  @IBOutlet weak var recoverPasswordButton: ButtonMockup!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      hideKeyboardWhenTappedAround()
  }

  
  @IBAction func recoverEmailTextFieldEditingChanged(_ sender: Any) { validateEmailTextField () }
  
  
  @IBAction func recoverPasswordButtonDidTouch(_ sender: Any) {
  
    ARSLineProgress.show()
    view.isUserInteractionEnabled = false
    
    FIRAuth.auth()?.sendPasswordReset(withEmail: recoverEmailTextField.text!) { (error) in
      // ...
      if error != nil {
        let alertController = UIAlertController(title: "Ошибка", message: error?.localizedDescription, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
          ARSLineProgress.hide()
           self.view.isUserInteractionEnabled = true
        
        self.present(alertController, animated: true, completion: nil)
        
      } else {
        
        let alert = UIAlertController(title: "", message: "Письмо для восстановления было отправлено на ваш e-mail адрес.", preferredStyle: UIAlertControllerStyle.alert)
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
  
  
  @IBAction func dismissVC(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func validateEmailTextField () {
    let characterSetEmail = NSCharacterSet(charactersIn: "@")
    let characterSetEmail1 = NSCharacterSet(charactersIn: ".")
    let badCharacterSetEmail = NSCharacterSet(charactersIn: "!`~,/?|'\'';:#^&*=")
    
    if (recoverEmailTextField.text?.characters.count)! < 5 ||
    recoverEmailTextField.text?.rangeOfCharacter(from: characterSetEmail as CharacterSet,
                                                 options: .caseInsensitive ) == nil ||
    recoverEmailTextField.text?.rangeOfCharacter(from: characterSetEmail1 as CharacterSet,
                                                 options: .caseInsensitive ) == nil ||
    recoverEmailTextField.text?.rangeOfCharacter(from: badCharacterSetEmail as CharacterSet,
                                                 options: .caseInsensitive ) != nil {
      
      recoverPasswordButton.isEnabled = false
      
      UIView.animate(withDuration: 0.5, animations: {
        self.recoverPasswordButton.alpha = 0.6 })
      
    } else {
      recoverPasswordButton.isEnabled = true
      
      UIView.animate(withDuration: 0.5, animations: {
        self.recoverPasswordButton.alpha = 1.0 })

    }
    
  }
  
}
