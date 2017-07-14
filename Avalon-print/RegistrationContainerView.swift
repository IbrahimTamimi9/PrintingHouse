//
//  RegistrationContainerView.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/30/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class RegistrationContainerView: UIView {
  
  
  let dismiss: UIButton = {
    let dismiss = UIButton()
    // dismiss.addTarget(self, action: #selector(ShoppingCartVC.rightBarButtonTapped), for: .touchUpInside)
    dismiss.translatesAutoresizingMaskIntoConstraints = false
    dismiss.contentMode = .scaleAspectFit
    dismiss.setImage(UIImage(named: "ArrowDown"), for: .normal)
    
    return dismiss
  }()
 
  let viewTitle: UILabel = {
    let viewTitle = UILabel()
    viewTitle.text = "Регистрация"
    viewTitle.font =  UIFont.systemFont(ofSize: 24)
    viewTitle.translatesAutoresizingMaskIntoConstraints = false
    
    return viewTitle
  }()

  let name: AvalonUITextField = {
    let name = AvalonUITextField()
    name.placeholder = "Имя и фамилия"
    name.translatesAutoresizingMaskIntoConstraints = false
    name.addTarget(self, action: #selector(RegistrationViewController.textFieldEditingChanged(_:)), for: .editingChanged)
    
    return name
  }()
  
  let phone: AvalonUITextField = {
    let phone = AvalonUITextField()
    phone.placeholder = "Номер телефона"
    phone.translatesAutoresizingMaskIntoConstraints = false
    phone.addTarget(self, action: #selector(RegistrationViewController.textFieldEditingChanged(_:)), for: .editingChanged)
    phone.keyboardType = .numberPad
    
    return phone
  }()
  
  let email: AvalonUITextField = {
    let email = AvalonUITextField()
    email.placeholder = "Эл. почта"
    email.translatesAutoresizingMaskIntoConstraints = false
    email.addTarget(self, action: #selector(RegistrationViewController.textFieldEditingChanged(_:)), for: .editingChanged)
    email.keyboardType = .emailAddress
    
    return email
  }()
  
  let password: AvalonUITextField = {
    let password = AvalonUITextField()
    password.placeholder = "Пароль"
    password.isSecureTextEntry = true
    password.translatesAutoresizingMaskIntoConstraints = false
    password.addTarget(self, action: #selector(RegistrationViewController.textFieldEditingChanged(_:)), for: .editingChanged)
    
    return password
  }()
  
  let passwordAgain: AvalonUITextField = {
    let passwordAgain = AvalonUITextField()
    passwordAgain.placeholder = "Пароль повторно"
    passwordAgain.isSecureTextEntry = true
    passwordAgain.translatesAutoresizingMaskIntoConstraints = false
    passwordAgain.addTarget(self, action: #selector(RegistrationViewController.textFieldEditingChanged(_:)), for: .editingChanged)
    
    return passwordAgain
  }()

  
  let register: AvalonUIButton = {
    let register = AvalonUIButton()
    register.setTitle("Зарегистрироваться", for: .normal)
    register.addTarget(self, action: #selector(RegistrationViewController.registerButtonDidTap(_:)), for: .touchUpInside)
    register.translatesAutoresizingMaskIntoConstraints = false
    register.isEnabled = false
    
    return register
  }()

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
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
    name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    name.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    addSubview(phone)
    phone.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 16).isActive = true
    phone.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    phone.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    phone.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    addSubview(email)
    email.topAnchor.constraint(equalTo: phone.bottomAnchor, constant: 16).isActive = true
    email.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    email.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    email.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    addSubview(password)
    password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 16).isActive = true
    password.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    password.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    password.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    addSubview(passwordAgain)
    passwordAgain.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 16).isActive = true
    passwordAgain.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    passwordAgain.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    passwordAgain.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    addSubview(register)
    register.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
    register.leadingAnchor.constraint(equalTo: passwordAgain.leadingAnchor).isActive = true
    register.trailingAnchor.constraint(equalTo: passwordAgain.trailingAnchor).isActive = true
    register.heightAnchor.constraint(equalToConstant: 50).isActive = true
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
}
