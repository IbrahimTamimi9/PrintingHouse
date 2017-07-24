//
//  User.swift
//  Avalon-print
//
//  Created by Roman Mizin on 3/25/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//


import UIKit

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    var phoneNumber: String?
    var type: String?
  
  init(dictionary: [String: AnyObject]) {
    self.id = dictionary["id"] as? String
    self.name = dictionary["name"] as? String
    self.email = dictionary["email"] as? String
    self.profileImageUrl = dictionary["profileImageUrl"] as? String
    self.phoneNumber = dictionary["PhoneNumber"] as? String
    self.type = dictionary["type"] as? String
  }
  
}
