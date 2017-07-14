//
//  OrdersDetailTableViewCell.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/3/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class OrdersDetailTableViewCell: UITableViewCell {
  let containerView: OrdersDetailContainerView = {
    let containerView = OrdersDetailContainerView()
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    return containerView
  }()
  
  
  let separator: UIView = {
    let separator = UIView()
    
    separator.translatesAutoresizingMaskIntoConstraints = false
    separator.backgroundColor = UIColor.white
    
    return separator
    
  }()
  
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(containerView)
    containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
    containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
    containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,  constant: 10).isActive = true
    containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,  constant: -10).isActive = true
    
    containerView.mainData.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
    
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    for subview in self.subviews {
      
      if String(describing: type(of: subview.self)) == ("UITableViewCellDeleteConfirmationView") {
        
        var newFrame = subview.frame
        newFrame.origin.y = containerView.frame.origin.y
        newFrame.size.height = containerView.frame.height
        subview.frame = newFrame
      }
    }
  }
}
