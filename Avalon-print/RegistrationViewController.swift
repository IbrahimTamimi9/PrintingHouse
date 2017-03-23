//
//  RegistrationViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/17/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//

import UIKit
import  FirebaseAuth
import FirebaseDatabase



class RegistrationViewController: UIViewController {
   
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var nameTFHeight: NSLayoutConstraint!
    @IBOutlet weak var numTFHeight: NSLayoutConstraint!
    @IBOutlet weak var mailTFHeight: NSLayoutConstraint!
    @IBOutlet weak var passTFHeight: NSLayoutConstraint!
    @IBOutlet weak var repeatPassTFHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nameSurname: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    
    @IBOutlet weak var registrationButton: ButtonMockup!

  
      override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        nameSurname.delegate = self
        phoneNumber.delegate = self
        email.delegate = self
        password.delegate = self
        repeatPassword.delegate = self
       
       
        setUpUI(textfields: [nameSurname, phoneNumber, email, password, repeatPassword], constraints: [nameTFHeight, numTFHeight, mailTFHeight, passTFHeight, repeatPassTFHeight])
        
    }
    
    
    func setUpUI(textfields: [UITextField], constraints: [NSLayoutConstraint]) {
        
      
        if screenSize.height < 667 {
            for Constraints in constraints {
                Constraints.constant = 40
            }
            
            for Textfields in textfields {
                Textfields.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            }
            
        }
        
        if screenSize.height == 736 {
            for Constraints in constraints {
                Constraints.constant = 55
            }
            
        }
    }
    
    
    @IBAction func nameSurnameEditingChanged(_ sender: Any) {  validateRegistraionData() }
    @IBAction func phoneNumberEditingChanged(_ sender: Any) { validateRegistraionData() }
    @IBAction func emailEditingChanged(_ sender: Any) { validateRegistraionData() }
    @IBAction func passwordEditingChanged(_ sender: Any) { validateRegistraionData() }
    @IBAction func repeatPassEditingChanged(_ sender: Any) { validateRegistraionData() }
  
  
    @IBAction func closeRegistrationPage(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
  
  
   func validateRegistraionData () {
    let characterSetEmail = NSCharacterSet(charactersIn: "@")
    let characterSetEmail1 = NSCharacterSet(charactersIn: ".")
    let badCharacterSetEmail = NSCharacterSet(charactersIn: "!`~,/?|'\'';:#^&*=")
    let badCharacterSetPhoneNumber = NSCharacterSet(charactersIn: "@$%.><!`~,/?|'\'';:#^&*=_+{}[]")

    
     if (nameSurname.text?.characters.count)! < 2 ||
        (phoneNumber.text?.characters.count)! < 10 ||
        (phoneNumber.text?.characters.count)! > 12 ||
         phoneNumber.text?.rangeOfCharacter(from: badCharacterSetPhoneNumber as CharacterSet, options: .caseInsensitive ) != nil ||
        (email.text?.characters.count)! < 5 ||
         email.text?.rangeOfCharacter(from: characterSetEmail as CharacterSet, options: .caseInsensitive ) == nil ||
         email.text?.rangeOfCharacter(from: characterSetEmail1 as CharacterSet, options: .caseInsensitive ) == nil ||
         email.text?.rangeOfCharacter(from: badCharacterSetEmail as CharacterSet, options: .caseInsensitive ) != nil ||
        (password.text?.characters.count)! < 6 ||
        (password.text != repeatPassword.text) {
        
         registrationButton.isEnabled = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.registrationButton.alpha = 0.6 })
        
     } else {
        registrationButton.isEnabled = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.registrationButton.alpha = 1.0 })
       }
    }
 

    @IBAction func doRegistrate(_ sender: Any) {
      
       ARSLineProgress.show()
       view.isUserInteractionEnabled = false
      
      FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: { authData, error  in
        if error == nil {
          let userData = ["name": self.nameSurname.text!,
                          "email": self.email.text!,
                          "PhoneNumber": self.phoneNumber.text!,
                          "type": "user" ]
          
          let ref = FIRDatabase.database().reference()
          ref.child("users").child(authData!.uid).setValue(userData)
          print("Successfuly registered")
          
          FIRAuth.auth()?.currentUser!.sendEmailVerification(completion: { (error) in
          })
          
          
          let alert = UIAlertController(title: "Регистрация прошла успешно", message: "Вам было выслано письмо для подтверждения вашего e-mail.", preferredStyle: UIAlertControllerStyle.alert)
          alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
            UIAlertAction in
           
            self.dismiss(animated: true, completion: nil)

          } )
          
             ARSLineProgress.hide()
             self.view.isUserInteractionEnabled = true
        
          
          self.present(alert, animated: true, completion: nil)
          
          
        } else {
          let alert = UIAlertController(title: "Пользователь с таким e-mail уже существует", message: "Пожалуйста, используйте другой e-mail, или выполните вход.", preferredStyle: UIAlertControllerStyle.alert)
          alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
          
          ARSLineProgress.hide()
          self.view.isUserInteractionEnabled = true
        
          
          self.present(alert, animated: true, completion: nil)

        }
      })
      
    }

    
    @IBAction func undo(_ sender: Any) {
           dismiss(animated: true, completion: nil)
    }    
}


extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


