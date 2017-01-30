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
  
  
  var messageFrame = UIView()
  var activityIndicator = UIActivityIndicatorView()
  var strLabel = UILabel()
  
  func progressBarDisplayer(msg:String, _ indicator:Bool ) {
    print(msg)
    strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
    strLabel.text = msg
    strLabel.font = UIFont.systemFont(ofSize: 13)
    strLabel.textColor = UIColor.white
    messageFrame = UIView(frame: CGRect(x: (screenSize.width - strLabel.frame.width)/2 ,
                                        y: (screenSize.height - strLabel.frame.height)/2  , width: 180, height: 50))
    messageFrame.layer.cornerRadius = 15
    messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
    if indicator {
      activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
      activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
      activityIndicator.startAnimating()
      messageFrame.addSubview(activityIndicator)
    }
    messageFrame.addSubview(strLabel)
    view.addSubview(messageFrame)
  }
  
  
    @IBAction func closeLoginPage(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

 
    @IBAction func onLogInButtonClicked(_ sender: Any) {
       progressBarDisplayer(msg: "Выполняется вход...", true)
       view.isUserInteractionEnabled = false
      
      FIRAuth.auth()?.signIn(withEmail: loginTextField.text!, password: passwordTextField.text!) {
        (user, error) in
       
        if error != nil  {
          //Tells the user that there is an error and then gets firebase to tell them the error
          let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
          
          let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
          alertController.addAction(defaultAction)
          
          DispatchQueue.main.async {
            self.messageFrame.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
          }
          
          self.present(alertController, animated: true, completion: nil)
        }
        
        
        if let user = FIRAuth.auth()?.currentUser {
          if !user.isEmailVerified{
            let alertVC = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \(self.loginTextField.text!).", preferredStyle: .alert)
            let alertActionOkay = UIAlertAction(title: "Send", style: .default) {
              (_) in
              user.sendEmailVerification(completion: nil)
            }
            let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alertVC.addAction(alertActionOkay)
            alertVC.addAction(alertActionCancel)
            DispatchQueue.main.async {
              self.messageFrame.removeFromSuperview()
              self.view.isUserInteractionEnabled = true
            }
            self.present(alertVC, animated: true, completion: nil)
          } else {
            
            print ("Email verified. Signing in...")
            DispatchQueue.main.async {
              self.messageFrame.removeFromSuperview()
              self.view.isUserInteractionEnabled = true
            }
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

