//
//  LoginContainerView.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/30/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class LoginContainerView: UIView {
  
  let logo: UIImageView = {
    let logo = UIImageView()
    logo.translatesAutoresizingMaskIntoConstraints = false
    logo.image = UIImage(named: "Ladybug")
    logo.contentMode = .scaleAspectFit
    logo.layer.masksToBounds = true
  
    return logo
  }()
  
  let emailField: AvalonUITextField = {
    let emailField = AvalonUITextField()
    emailField.placeholder =  NSLocalizedString("LoginContainerView.emailField.placeholder", comment: "")
    emailField.translatesAutoresizingMaskIntoConstraints = false
    emailField.addTarget(self, action: #selector(LoginViewController.fieldsValidation(_:)), for: .editingChanged)
    emailField.keyboardType = .emailAddress
    
    return emailField
  }()
  
  let passwordField: AvalonUITextField = {
    let passwordField = AvalonUITextField()
    passwordField.placeholder = NSLocalizedString("LoginContainerView.passwordField.placeholder", comment: "")
    passwordField.isSecureTextEntry = true
    passwordField.translatesAutoresizingMaskIntoConstraints = false
    passwordField.addTarget(self, action: #selector(LoginViewController.fieldsValidation(_:)), for: .editingChanged)
    
    return passwordField
  }()
  
  let login: AvalonUIButton = {
    let login = AvalonUIButton()
    
    login.setTitle(NSLocalizedString("LoginContainerView.loginButton.title", comment: ""), for: .normal)
    login.addTarget(self, action: #selector(LoginViewController.onLogInButtonClicked(_:)), for: .touchUpInside)
    login.translatesAutoresizingMaskIntoConstraints = false
    login.isEnabled = false
    
    return login
  }()
  
  let registraion: AvalonUIButtonLight = {
    let registraion = AvalonUIButtonLight()
    registraion.translatesAutoresizingMaskIntoConstraints = false
    registraion.setTitle(NSLocalizedString("LoginContainerView.registraionButton.title", comment: ""), for: .normal)
    registraion.contentHorizontalAlignment = .left
    registraion.addTarget(self, action: #selector(LoginViewController.registerButtonTapped), for: .touchUpInside)
    
    return registraion
  }()
  
  let passwordReset: AvalonUIButtonLight = {
    let passwordReset = AvalonUIButtonLight()
    passwordReset.translatesAutoresizingMaskIntoConstraints = false
    passwordReset.setTitle( NSLocalizedString("LoginContainerView.passwordResetButton.title", comment: "") , for: .normal)
    passwordReset.contentHorizontalAlignment = .left
    passwordReset.addTarget(self, action: #selector(LoginViewController.resetPasswordButtonTapped), for: .touchUpInside)
    
    return passwordReset
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
  
    addSubview(logo)
    logo.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
    logo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    logo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    
    addSubview(emailField)
    emailField.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 40).isActive = true
    emailField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    emailField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    emailField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    addSubview(passwordField)
    passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16).isActive = true
    passwordField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor).isActive = true
    passwordField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor).isActive = true
    passwordField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    addSubview(login)
    login.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 16).isActive = true
    login.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor).isActive = true
    login.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor).isActive = true
    login.heightAnchor.constraint(equalToConstant: 50).isActive = true

    addSubview(registraion)
    registraion.topAnchor.constraint(equalTo: login.bottomAnchor, constant: 36).isActive = true
    registraion.leadingAnchor.constraint(equalTo: login.leadingAnchor).isActive = true
    registraion.heightAnchor.constraint(equalToConstant: 21).isActive = true
    
    addSubview(passwordReset)
    passwordReset.topAnchor.constraint(equalTo: registraion.bottomAnchor, constant: 16).isActive = true
    passwordReset.leadingAnchor.constraint(equalTo: registraion.leadingAnchor).isActive = true
    passwordReset.heightAnchor.constraint(equalToConstant: 21).isActive = true

  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
}
