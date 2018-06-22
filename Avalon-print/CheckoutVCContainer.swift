//
//  CheckoutVCContainer.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/18/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import Firebase


class CheckoutVCContainer: UIView {
  
  let placeOdredLocalizableTitle = NSLocalizedString("CheckoutVCContainer.placeOdredLocalizableTitle", comment: "")
  let viewLocalizableTitle = NSLocalizedString("CheckoutVCContainer.viewLocalizableTitle", comment: "")
  let deliveryLocalizableTitle = NSLocalizedString("CheckoutVCContainer.deliveryLocalizableTitle", comment: "")
  let commentsLocalizableTitle = NSLocalizedString("CheckoutVCContainer.commentsLocalizableTitle", comment: "")
  
  let namePlaceholderLocalizableTitle = NSLocalizedString("CheckoutVCContainer.namePlaceholderLocalizableTitle", comment: "")
  let phonePlaceholderLocalizableTitle = NSLocalizedString("CheckoutVCContainer.phonePlaceholderLocalizableTitle", comment: "")
  let emailPlaceholderLocalizableTitle = NSLocalizedString("CheckoutVCContainer.emailPlaceholderLocalizableTitle", comment: "")
  let adressPlaceholderLocalizableTitle = NSLocalizedString("CheckoutVCContainer.adressPlaceholderLocalizableTitle", comment: "")
  
  
  
  let dismiss: UIButton = {
    let dismiss = UIButton()
    // dismiss.addTarget(self, action: #selector(ShoppingCartVC.rightBarButtonTapped), for: .touchUpInside)
    dismiss.translatesAutoresizingMaskIntoConstraints = false
    dismiss.contentMode = .scaleAspectFit
    dismiss.setImage(UIImage(named: "ArrowDown"), for: .normal)
    
    return dismiss
  }()
  
  let placeOrder: AvalonUIButton = {
    let placeOrder = AvalonUIButton()
   
    placeOrder.addTarget(self, action: #selector(CheckoutVC.placeOrderTapped), for: .touchUpInside)
    placeOrder.translatesAutoresizingMaskIntoConstraints = false
    placeOrder.isEnabled = false
    return placeOrder
  }()
  
  
  let viewTitle: UILabel = {
    let title = UILabel()
   
    title.font =  UIFont.systemFont(ofSize: 24)
    title.translatesAutoresizingMaskIntoConstraints = false
    
    return title
  }()
  
  let deliveryTitle: UILabel = {
    let deliveryTitle = UILabel()
   
    deliveryTitle.font =  UIFont.systemFont(ofSize: 17)
    deliveryTitle.translatesAutoresizingMaskIntoConstraints = false
    
    return deliveryTitle
  }()
  
  let commentsTitle: UILabel = {
    let commentsTitle = UILabel()
    
    commentsTitle.font =  UIFont.systemFont(ofSize: 17)
    commentsTitle.translatesAutoresizingMaskIntoConstraints = false
    
    return commentsTitle
  }()
  
  let name: AvalonUITextField = {
    let name = AvalonUITextField()
   
    name.translatesAutoresizingMaskIntoConstraints = false
    name.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    
    return name
  }()
  
  let phone: AvalonUITextField = {
    let phone = AvalonUITextField()
   
    phone.translatesAutoresizingMaskIntoConstraints = false
    phone.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    phone.keyboardType = .numberPad
    
    return phone
  }()
  
  let email: AvalonUITextField = {
    let email = AvalonUITextField()
   
    email.translatesAutoresizingMaskIntoConstraints = false
    email.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    email.keyboardType = .emailAddress
    
    
    return email
  }()
  
  let deliveryAdress: AvalonUITextField = {
    let deliveryAdress = AvalonUITextField()
    deliveryAdress.isEnabled = false
   
    deliveryAdress.translatesAutoresizingMaskIntoConstraints = false
    
    return deliveryAdress
  }()
  
  let comments: UITextView = {
    let comments = UITextView()
    comments.translatesAutoresizingMaskIntoConstraints = false
    comments.layer.cornerRadius = 10
    comments.backgroundColor = AvalonPalette.avalonTextFieldBackground
  //  comments.addTarget(self, action: #selector(CheckoutVC.textViewDidBeginEditing(textView:notification:)), for: .editingChanged)
   
    return comments
  }()
  
  let deliverySelector: UISwitch = {
    let deliverySelector = UISwitch()
    deliverySelector.translatesAutoresizingMaskIntoConstraints = false
    deliverySelector.addTarget(self, action: #selector(switchValueDidChange(sender:)), for: .valueChanged)
    
    
    return deliverySelector
  }()


  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor.white
    viewTitle.backgroundColor = backgroundColor
    
    placeOrder.setTitle(placeOdredLocalizableTitle, for: .normal)
    viewTitle.text = viewLocalizableTitle
    deliveryTitle.text = deliveryLocalizableTitle
    commentsTitle.text = commentsLocalizableTitle
    name.placeholder = namePlaceholderLocalizableTitle
    phone.placeholder = phonePlaceholderLocalizableTitle
    email.placeholder = emailPlaceholderLocalizableTitle
    deliveryAdress.placeholder = adressPlaceholderLocalizableTitle
    
    // title.text = "Оформление заказа"
    
  
     addSubview(dismiss)
     dismiss.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
     dismiss.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
     dismiss.widthAnchor.constraint(equalToConstant: 33).isActive = true
     dismiss.heightAnchor.constraint(equalToConstant: 25).isActive = true
   
     addSubview(viewTitle)
     viewTitle.topAnchor.constraint(equalTo: dismiss.bottomAnchor, constant: 0).isActive = true
     viewTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    
     addSubview(name)
     name.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 25).isActive = true
     name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
     name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
     name.heightAnchor.constraint(equalToConstant: 50).isActive = true

     addSubview(phone)
     phone.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10).isActive = true
     phone.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
     phone.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
     phone.heightAnchor.constraint(equalToConstant: 50).isActive = true

     addSubview(email)
     email.topAnchor.constraint(equalTo: phone.bottomAnchor, constant: 10).isActive = true
     email.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
     email.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
     email.heightAnchor.constraint(equalToConstant: 50).isActive = true

     addSubview(deliveryTitle)
     deliveryTitle.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 25).isActive = true
     deliveryTitle.leadingAnchor.constraint(equalTo: email.leadingAnchor, constant: 0).isActive = true
    
     addSubview(deliverySelector)
     deliverySelector.trailingAnchor.constraint(equalTo: email.trailingAnchor, constant: 0).isActive = true
     deliverySelector.centerYAnchor.constraint(equalTo: deliveryTitle.centerYAnchor, constant: 0).isActive = true
    
     addSubview(deliveryAdress)
     deliveryAdress.topAnchor.constraint(equalTo: deliveryTitle.bottomAnchor, constant: 10).isActive = true
     deliveryAdress.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
     deliveryAdress.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
     deliveryAdress.heightAnchor.constraint(equalToConstant: 50).isActive = true

     addSubview(commentsTitle)
     commentsTitle.topAnchor.constraint(equalTo: deliveryAdress.bottomAnchor, constant: 25).isActive = true
     commentsTitle.leadingAnchor.constraint(equalTo: deliveryAdress.leadingAnchor, constant: 0).isActive = true

     addSubview(comments)
     comments.topAnchor.constraint(equalTo: commentsTitle.bottomAnchor, constant: 10).isActive = true
     comments.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
     comments.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
     comments.heightAnchor.constraint(equalToConstant: 200).isActive = true

     addSubview(placeOrder)
     placeOrder.topAnchor.constraint(equalTo: comments.bottomAnchor, constant: 10).isActive = true
     placeOrder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
     placeOrder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
     placeOrder.heightAnchor.constraint(equalToConstant: 50).isActive = true
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
}


extension CheckoutVCContainer { /* handling text fields */
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    validateRegistraionData()
  }
  
  func validateRegistraionData () {
    print("validation...")
    let characterSetEmail = NSCharacterSet(charactersIn: "@")
    let characterSetEmail1 = NSCharacterSet(charactersIn: ".")
    let badCharacterSetEmail = NSCharacterSet(charactersIn: "!`~,/?|'\'';:#^&*=")
    let badCharacterSetPhoneNumber = NSCharacterSet(charactersIn: "@$%.><!`~,/?|'\'';:#^&*=_+{}[]")
    
    if (name.text?.count)! < 2 ||
      (phone.text?.count)! < 10 ||
      (phone.text?.count)! > 20 ||
      phone.text?.rangeOfCharacter(from: badCharacterSetPhoneNumber as CharacterSet, options: .caseInsensitive ) != nil ||
      (email.text?.count)! < 5 ||
      email.text?.rangeOfCharacter(from: characterSetEmail as CharacterSet, options: .caseInsensitive ) == nil ||
      email.text?.rangeOfCharacter(from: characterSetEmail1 as CharacterSet, options: .caseInsensitive ) == nil ||
      email.text?.rangeOfCharacter(from: badCharacterSetEmail as CharacterSet, options: .caseInsensitive ) != nil  {
      
      placeOrder.isEnabled = false
      
    } else {
      
      placeOrder.isEnabled = true
    }
  }

}


extension CheckoutVCContainer { /* handling switch */
  
  @objc func switchValueDidChange(sender: UISwitch!) {
    if sender.isOn {
      deliveryAdress.isEnabled = true
    } else {
      deliveryAdress.isEnabled = false
    }
  }

}


extension CheckoutVCContainer { /* firebase user data observing */
  
  func localyRetrieveUserData () {  /* fills name phone and email text fields if user is logged in  */
    
    if Auth.auth().currentUser != nil && Auth.auth().currentUser?.isEmailVerified == true {
      
      var ref: DatabaseReference!
      ref = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
      
      ref.observeSingleEvent(of: .value, with: { snapshot in
        
        if !snapshot.exists() { return }
        
        let mainUserData = snapshot.value as? NSDictionary
        
        if let userNameSurname = mainUserData?["name"] as? String  {
          self.name.text = userNameSurname
          
        }
        
        if let userPhoneNumber = mainUserData?["PhoneNumber"] as? String  {
          self.phone.text = userPhoneNumber
        }
        
        self.email.text = Auth.auth().currentUser!.email!
        self.validateRegistraionData()
      })
      
    } else {
      
      name.text = ""
      phone.text = ""
      email.text = ""
    }
  }

}


