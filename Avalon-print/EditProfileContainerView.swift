//
//  EditProfileContainerView.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/6/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class EditProfileContainerView: UIView {

  let title: UILabel = {
    let title = UILabel()
    title.translatesAutoresizingMaskIntoConstraints = false
    title.font = UIFont.systemFont(ofSize: 34)
    title.text = "Редактирование"
  
    
    return title
  }()
  
  let nameField: AvalonUITextField = {
    let nameField = AvalonUITextField()
    nameField.placeholder = "Имя и фамилия"
    nameField.translatesAutoresizingMaskIntoConstraints = false
    nameField.addTarget(self, action: #selector(EditProfileViewController.textfieldEditingChanged(_:)), for: .editingChanged)
   // nameField.keyboardType = .emailAddress
    
    return nameField
  }()
  
  let phoneField: AvalonUITextField = {
    let phoneField = AvalonUITextField()
    phoneField.placeholder = "Номер телефона"
    phoneField.translatesAutoresizingMaskIntoConstraints = false
    phoneField.addTarget(self, action: #selector(EditProfileViewController.textfieldEditingChanged(_:)), for: .editingChanged)
    
    return phoneField
  }()
  
  let save: AvalonUIButtonLight = {
    let save = AvalonUIButtonLight()
    save.setTitle("Сохранить", for: .normal)
    save.addTarget(self, action: #selector(EditProfileViewController.saveButtonDidTap(_:)), for: .touchUpInside)
    save.translatesAutoresizingMaskIntoConstraints = false
    save.isEnabled = false
    
    return save
  }()
  
  
  let passwordReset: AvalonUIButtonLight = {
    let passwordReset = AvalonUIButtonLight()//..(type: UIButtonType.infoDark )
    passwordReset.translatesAutoresizingMaskIntoConstraints = false
    passwordReset.setTitle("Изменить пароль", for: .normal)
    passwordReset.contentHorizontalAlignment = .left
   passwordReset.addTarget(self, action: #selector(EditProfileViewController.resetPasswordButtonTapped), for: .touchUpInside)
  
    return passwordReset
  }()
  
   override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(title)
    title.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
    title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    
    addSubview(phoneField)
    phoneField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -66).isActive = true
    phoneField.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
    phoneField.trailingAnchor.constraint(equalTo: title.trailingAnchor).isActive = true
    phoneField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    addSubview(nameField)
    nameField.bottomAnchor.constraint(equalTo: phoneField.topAnchor, constant: -16).isActive = true
    nameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    nameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    nameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
  
    addSubview(passwordReset)
    passwordReset.topAnchor.constraint(equalTo: phoneField.bottomAnchor, constant: 16).isActive = true
    passwordReset.leadingAnchor.constraint(equalTo: phoneField.leadingAnchor).isActive = true
    passwordReset.heightAnchor.constraint(equalToConstant: 21).isActive = true
    
    addSubview(save)
    save.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
    save.leadingAnchor.constraint(equalTo: phoneField.leadingAnchor).isActive = true
    save.trailingAnchor.constraint(equalTo: phoneField.trailingAnchor).isActive = true
    save.heightAnchor.constraint(equalToConstant: 50).isActive = true
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
}
