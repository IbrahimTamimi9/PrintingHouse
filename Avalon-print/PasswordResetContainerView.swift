//
//  PasswordResetContainerView.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/30/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class PasswordResetContainerView: UIView {

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
    viewTitle.text = "Восстановление пароля"
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
  
  let reset: AvalonUIButton = {
    let reset = AvalonUIButton()
    reset.setTitle("Восстановить пароль", for: .normal)
    reset.addTarget(self, action: #selector(PasswordResetViewController.recoverPasswordButtonDidTap(_:)), for: .touchUpInside)
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
    email.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    email.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -26).isActive = true
    email.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    email.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    email.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    addSubview(reset)
    reset.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
    reset.leadingAnchor.constraint(equalTo: email.leadingAnchor).isActive = true
    reset.trailingAnchor.constraint(equalTo: email.trailingAnchor).isActive = true
    reset.heightAnchor.constraint(equalToConstant: 50).isActive = true
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }



}
