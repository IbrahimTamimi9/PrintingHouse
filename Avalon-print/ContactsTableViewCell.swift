//
//  ContactsTableViewCell.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/23/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

 
  
  var contentTextView: UITextView = {
    var contentTextView = UITextView()
    contentTextView.isEditable = false
    contentTextView.isScrollEnabled = false
    contentTextView.translatesAutoresizingMaskIntoConstraints = false
    contentTextView.font = UIFont.systemFont(ofSize: 17)
    contentTextView.dataDetectorTypes = .all
  
    return contentTextView
  }()
  

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    
    
    selectionStyle = .none
    addSubview(contentTextView)
    contentTextView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
    contentTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    contentTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    contentTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
   // backgroundColor = UIColor.white
   // contentTextView.backgroundColor = backgroundColor
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
