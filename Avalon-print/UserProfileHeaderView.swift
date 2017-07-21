//
//  UserProfileHeaderView.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/2/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class UserProfileHeaderView: UIView {
  
  let name: UILabel = {
    let name = UILabel()
    name.text = ""
    name.font =  UIFont.systemFont(ofSize: 34)
    name.translatesAutoresizingMaskIntoConstraints = false
    
    return name
  }()
  
  let email: UILabel = {
    let email = UILabel()
    email.text = ""
    email.font =  UIFont.systemFont(ofSize: 17)
    email.textColor = UIColor.lightGray
    email.translatesAutoresizingMaskIntoConstraints = false
    
    return email
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  
    backgroundColor = UIColor.white
    name.backgroundColor = backgroundColor
    email.backgroundColor = backgroundColor
    
    addSubview(name)
    name.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    
    addSubview(email)
    email.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 0).isActive = true
    email.leadingAnchor.constraint(equalTo: name.leadingAnchor).isActive = true
    email.trailingAnchor.constraint(equalTo: name.trailingAnchor).isActive = true
  }
  
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }

  

}
