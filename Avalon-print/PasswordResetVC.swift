//
//  passwordResetVC.swift
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
  
  
  @IBAction func recoverPasswordButtonDidTouch(_ sender: Any) {
    progressBarDisplayer(msg: "Выполнение...", true)
    view.isUserInteractionEnabled = false
    
    FIRAuth.auth()?.sendPasswordReset(withEmail: recoverEmailTextField.text!) { (error) in
      // ...
      if error != nil {
        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        DispatchQueue.main.async {
          self.messageFrame.removeFromSuperview()
           self.view.isUserInteractionEnabled = true
        }
        
        self.present(alertController, animated: true, completion: nil)
        
      } else {
        let alert = UIAlertController(title: "Recover E-mail sent", message: "Recovery e-mail has been sent to your E-mail adress.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
          UIAlertAction in
          
          self.dismiss(animated: true, completion: nil)
        } )
        
        DispatchQueue.main.async {
          self.messageFrame.removeFromSuperview()
           self.view.isUserInteractionEnabled = true
        }
        
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
