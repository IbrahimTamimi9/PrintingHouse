//
//  ResetPasswordContainerView.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/6/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class ResetPasswordContainerView: UIView {

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
    viewTitle.text = "Изменение пароля"
    viewTitle.font =  UIFont.systemFont(ofSize: 24)
    viewTitle.translatesAutoresizingMaskIntoConstraints = false
    
    return viewTitle
  }()
  
  let email: AvalonUITextField = {
    let email = AvalonUITextField()
    email.placeholder = "Эл. почта"
    email.translatesAutoresizingMaskIntoConstraints = false
    email.addTarget(self, action: #selector(PasswordResetViewController.recoverEmailTextFieldEditingChanged(_:)), for: .editingChanged)
    email.keyboardType = .emailAddress
    
    return email
  }()
  
  let oldPassword: AvalonUITextField = {
    let oldPassword = AvalonUITextField()
    oldPassword.placeholder = "Старый пароль"
    oldPassword.translatesAutoresizingMaskIntoConstraints = false
    oldPassword.addTarget(self, action: #selector(PasswordResetViewController.recoverEmailTextFieldEditingChanged(_:)), for: .editingChanged)
    oldPassword.isSecureTextEntry = true
    
    return oldPassword
  }()

  let newPassword: AvalonUITextField = {
    let newPassword = AvalonUITextField()
    newPassword.placeholder = "Новый пароль"
    newPassword.translatesAutoresizingMaskIntoConstraints = false
    newPassword.addTarget(self, action: #selector(PasswordResetViewController.recoverEmailTextFieldEditingChanged(_:)), for: .editingChanged)
   newPassword.isSecureTextEntry = true
    
    return newPassword
  }()
  
  
  let reset: AvalonUIButton = {
    let reset = AvalonUIButton()
    reset.setTitle("Изменить пароль", for: .normal)
    reset.addTarget(self, action: #selector(ResetPasswordViewController.recoverPasswordButtonDidTap(_:)), for: .touchUpInside)
    reset.translatesAutoresizingMaskIntoConstraints = false
    reset.isEnabled = false
    
    return reset
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
    
    addSubview(email)
    email.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 50).isActive = true
    email.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    email.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    email.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    addSubview(oldPassword)
    oldPassword.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 16).isActive = true
    oldPassword.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    oldPassword.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    oldPassword.heightAnchor.constraint(equalToConstant: 50).isActive = true

    addSubview(newPassword)
    newPassword.topAnchor.constraint(equalTo: oldPassword.bottomAnchor, constant: 16).isActive = true
    newPassword.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    newPassword.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    newPassword.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    addSubview(reset)
    reset.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
    reset.leadingAnchor.constraint(equalTo: newPassword.leadingAnchor).isActive = true
    reset.trailingAnchor.constraint(equalTo: newPassword.trailingAnchor).isActive = true
    reset.heightAnchor.constraint(equalToConstant: 50).isActive = true
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  


}
