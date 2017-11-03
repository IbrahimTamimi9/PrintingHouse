//
//  EditProfileViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/6/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EditProfileViewController: UIViewController {
  
  let editProfileContainerView = EditProfileContainerView()

    override func viewDidLoad() {
        super.viewDidLoad()
      
      view.backgroundColor = AvalonPalette.avalonControllerBackground
      view.addSubview(editProfileContainerView)
      
      setConstraints()
      localyRetrieveUserData()
      hideKeyboardWhenTappedAround()
    }
  
  
  fileprivate func setConstraints () {
    editProfileContainerView.translatesAutoresizingMaskIntoConstraints = false
    editProfileContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    editProfileContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    editProfileContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    editProfileContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
  }

}


extension EditProfileViewController {
  
 @objc func textfieldEditingChanged(_ sender: Any) { validateData () }
  
 @objc func saveButtonDidTap(_ sender: Any) {
    
    ARSLineProgress.show()
    
    view.isUserInteractionEnabled = false
    
    let userRef = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
    
    
    if let newName = editProfileContainerView.nameField.text {
      
      userRef.updateChildValues(["name" : newName ], withCompletionBlock: {(error, reference)   in
        
        if error == nil{
          
          self.alertOfSuccess()
          
        } else {
          
          let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
          
          let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
          
          alertController.addAction(defaultAction)
          
          ARSLineProgress.showFail()
          
          self.view.isUserInteractionEnabled = true
          
          self.present(alertController, animated: true, completion: nil)
        }
      })
    }
    
    
    if  let newPhone = editProfileContainerView.phoneField.text {
      
      userRef.updateChildValues(["PhoneNumber" : newPhone ], withCompletionBlock: {(error, reference)   in
        
        if error == nil {
          
          self.alertOfSuccess()
          
        } else {
          
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
  
  
  func alertOfSuccess () {
    
    let alert = UIAlertController(title: "Выполнено", message: "Ваши данные были успешно изменены", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { UIAlertAction in
      
      self.dismiss(animated: true, completion: nil)
    })
    
    ARSLineProgress.hide()
    
    self.view.isUserInteractionEnabled = true
    
    self.present(alert, animated: true, completion: nil)
  }
  
  
  func validateData () {
    
    let badCharacterSetPhoneNumber = NSCharacterSet(charactersIn: "@$%.><!`~,/?|'\'';:#^&*=_+{}[]")
  
    
    if (editProfileContainerView.nameField.text?.count)! < 2 ||
       (editProfileContainerView.phoneField.text?.count)! < 10 ||
       (editProfileContainerView.phoneField.text?.count)! > 12 ||
        editProfileContainerView.phoneField.text?.rangeOfCharacter(from: badCharacterSetPhoneNumber as CharacterSet, options: .caseInsensitive ) != nil  {
      
        editProfileContainerView.save.isEnabled = false
      
    } else {
      editProfileContainerView.save.isEnabled = true
    }
  }
  
 @objc func resetPasswordButtonTapped () {
    
    let controller = ResetPasswordViewController()
    let transitionDelegate = DeckTransitioningDelegate()
    controller.transitioningDelegate = transitionDelegate
    controller.modalPresentationStyle = .custom
    present(controller, animated: true, completion: nil)
  }

  
  func checkInternetConnectionForFutureActivityIndicatorBehavior () {
    
    if  currentReachabilityStatus != .notReachable {
      //connected
      ARSLineProgress.show()
    } else {
      //not connected
    }
  }
  
  
  func localyRetrieveUserData () {
    
    //  ARSLineProgress.show()
    checkInternetConnectionForFutureActivityIndicatorBehavior ()
    
    var ref: DatabaseReference!
    ref = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
    
    ref.observeSingleEvent(of: .value, with: { snapshot in
      
      if !snapshot.exists() { return }
      
      let mainUserData = snapshot.value as? NSDictionary
      
      if let userNameSurname = mainUserData?["name"] as? String  {
        self.editProfileContainerView.nameField.text = userNameSurname
        
      }
      
      if let userPhoneNumber = mainUserData?["PhoneNumber"] as? String  {
        self.editProfileContainerView.phoneField.text = userPhoneNumber
      }
      
      // self.email.text = FIRAuth.auth()!.currentUser!.email!
      
      ARSLineProgress.hide()
      
      UIView.animate(withDuration: 0.2, animations: {
        
        self.editProfileContainerView.nameField.alpha = 1
        self.editProfileContainerView.phoneField.alpha = 1
        self.editProfileContainerView.save.alpha = 1
        
      })
    })
   }

}
