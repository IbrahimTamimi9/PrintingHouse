//
//  UpdateUserProfile.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 1/29/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class UpdateUserProfile: UIViewController {

  
  @IBOutlet weak var nameSurname: UITextField!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var phoneNumber: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var saveButton: ButtonMockup!
  
  var emailChanged = false
  var phoneChanged = false
  var nameChanged = false
  

    override func viewDidLoad() {
        super.viewDidLoad()
      
      nameSurname.delegate = self
      email.delegate = self
      phoneNumber.delegate = self
      
      email.alpha = 0
      nameSurname.alpha = 0
      phoneNumber.alpha = 0
      saveButton.alpha = 0
      
      localyRetrieveUserData()
      hideKeyboardWhenTappedAround()
      
    }
  
  
  @IBAction func nameSurnameEditingChanged(_ sender: Any) { validateData (); nameChanged = true }
  @IBAction func emailEditingChanged(_ sender: Any) { validateData (); emailChanged = true }
  @IBAction func phoneNumberEditingChanged(_ sender: Any) { validateData (); phoneChanged = true }
  @IBAction func passwordEditingChanged(_ sender: Any) { validateData (); }

  
  
  @IBAction func saveButtonDidTap(_ sender: Any) {
    
    ARSLineProgress.show()
    view.isUserInteractionEnabled = false

    if emailChanged == true {
       print("email!!!!!")
       self.performAlert()
      
       }
   
    
    let userRef = FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid)
   
    if nameChanged == true {
      
    print("nam!!!!e")
    if let newName = nameSurname!.text {
      
      userRef.updateChildValues(["nameSurname" : newName ], withCompletionBlock: {(error, reference)   in
        
        if error == nil{
             self.performAlert()

        } else {
          
          //Tells the user that there is an error and then gets firebase to tell them the error
          let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
          
          let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
          alertController.addAction(defaultAction)
        
            ARSLineProgress.showFail()
            self.view.isUserInteractionEnabled = true
          
          
          self.present(alertController, animated: true, completion: nil)
        }
      })
    }
    
    }
    
    if phoneChanged == true {
    print("phone!!!")
    if  let newPhone = phoneNumber!.text {
      userRef.updateChildValues(["PhoneNumber" : newPhone ], withCompletionBlock: {(error, reference)   in
        
        if error == nil{
          self.performAlert()
          
          } else {
          
          //Tells the user that there is an error and then gets firebase to tell them the error
          let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
          
          let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
          alertController.addAction(defaultAction)

            ARSLineProgress.showFail()
            self.view.isUserInteractionEnabled = true

            self.present(alertController, animated: true, completion: nil)
         }
        
       })
      
      }
      
    }
    
  }
  
  
  func performAlert () {
    
    if emailChanged == true && (phoneChanged == true || emailChanged == true) {
      FIRAuth.auth()?.currentUser?.updateEmail(email.text!) { (error) in
        
        if error != nil  {
          
          //Tells the user that there is an error and then gets firebase to tell them the error
          let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
          
          let defaultAction = UIAlertAction(title: "OK", style: .cancel) {
            UIAlertAction in
            self.emailChanged = false
            self.phoneChanged = false
            self.nameChanged = false
            self.dismiss(animated: true, completion: nil)
          }

          alertController.addAction(defaultAction)
          
          ARSLineProgress.showFail()
          self.view.isUserInteractionEnabled = true
        
          
          self.present(alertController, animated: true, completion: nil)
        } else {
          self.alertOfSuccess()
        }
      }

    } else {
       alertOfSuccess()
    }
   
  }
  
  
  func alertOfSuccess () {
    
        let alert = UIAlertController(title: "Выполнено", message: "Ваши данные были успешно изменены, выполните повторный вход, чтобы изменения вступили в силу, так-же если вы изменили E-mail, вам будет выслано письмо для подтверждения", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { UIAlertAction in
        
        self.emailChanged = false
        self.phoneChanged = false
        self.nameChanged = false
        self.dismiss(animated: true, completion: nil)
      } )
      
    
        ARSLineProgress.hide()
        self.view.isUserInteractionEnabled = true
      
      self.present(alert, animated: true, completion: nil)
  }
  
  
  func validateData () {
    
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
        email.text?.rangeOfCharacter(from: badCharacterSetEmail as CharacterSet, options: .caseInsensitive ) != nil  {
      
      saveButton.isEnabled = false
      
      UIView.animate(withDuration: 0.5, animations: {
        self.saveButton.alpha = 0.6 })
      
    } else {
      saveButton.isEnabled = true
      
      UIView.animate(withDuration: 0.5, animations: {
        self.saveButton.alpha = 1.0 })
    }
  }
  
  
  func localyRetrieveUserData () {
    ARSLineProgress.show()
    var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
    
        ref.observeSingleEvent(of: .value, with: { snapshot in
      
      if !snapshot.exists() { return }
      
      let mainUserData = snapshot.value as? NSDictionary
      
      if let userNameSurname = mainUserData?["nameSurname"] as? String  {
        self.nameSurname.text = userNameSurname
      
      }
      
      
      if let userPhoneNumber = mainUserData?["PhoneNumber"] as? String  {
        self.phoneNumber.text = userPhoneNumber
      }
      
      self.email.text = FIRAuth.auth()!.currentUser!.email!
          
          ARSLineProgress.hide()
          UIView.animate(withDuration: 0.2, animations: {
            self.email.alpha = 1
            self.nameSurname.alpha = 1
            self.phoneNumber.alpha = 1
            self.saveButton.alpha = 1
          })

    })
  
  }

}


extension UpdateUserProfile: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
