//
//  LoginViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/8/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


 extension UITextField {
     @IBInspectable var placeHolderColor: UIColor? {
         get {
             return self.placeHolderColor
         }
         set {
             self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
         }
     }
 }


class LoginViewController: UIViewController {
  
    @IBOutlet weak var LogInButton: ButtonMockup!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mainView: UIView!

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
            loginTextField.delegate = self
            passwordTextField.delegate = self
    }
  

    @IBAction func closeLoginPage(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

 
    @IBAction func onLogInButtonClicked(_ sender: Any) {
       ARSLineProgress.show()
       view.isUserInteractionEnabled = false
      
      
      FIRAuth.auth()?.signIn(withEmail: loginTextField.text!, password: passwordTextField.text!) {
        (user, error) in
       
        if error != nil  {
          //Tells the user that there is an error and then gets firebase to tell them the error
          let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
          
          let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
          alertController.addAction(defaultAction)
          
        
          ARSLineProgress.hide()
          self.view.isUserInteractionEnabled = true
        
          
          self.present(alertController, animated: true, completion: nil)
        }
        
        
        if let user = FIRAuth.auth()?.currentUser {
          if !user.isEmailVerified {
            let alertVC = UIAlertController(title: "Ошибка", message: "Извините. Ваш email еще небыл подтвержден.Хотите чтобы мы отправлили вам письмо с подтверждением повторно? \(self.loginTextField.text!).", preferredStyle: .alert)
            let alertActionOkay = UIAlertAction(title: "Отправить", style: .default) {
              (_) in
              user.sendEmailVerification(completion: nil)
            }
            let alertActionCancel = UIAlertAction(title: "Отмена", style: .default, handler: nil)
            
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

  
    @IBAction func emailFieldValidation(_ sender: Any) { validation() }
    @IBAction func passwordFieldValidation(_ sender: Any) { validation() }
    
    func validation () {
        let characterSet = NSCharacterSet(charactersIn: "@")
        let badCharacterSet = NSCharacterSet(charactersIn: "!`~,/?|'\'';:#^&*=")
        
        if (loginTextField.text?.characters.count)! < 5 || loginTextField.text?.rangeOfCharacter(from: characterSet as CharacterSet, options: .caseInsensitive ) == nil || loginTextField.text?.rangeOfCharacter(from: badCharacterSet as CharacterSet, options: .caseInsensitive ) != nil || (passwordTextField.text?.characters.count)! < 6 {
            LogInButton.isEnabled = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.LogInButton.alpha = 0.6})
           
            
        } else {
            LogInButton.isEnabled = true;
            
            UIView.animate(withDuration: 0.5, animations: {
                self.LogInButton.alpha = 1.0 })
            }
    }
    
  
    func closeKeyboard() {
        self.view.endEditing(true)
    }
  
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closeKeyboard()
    }
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

