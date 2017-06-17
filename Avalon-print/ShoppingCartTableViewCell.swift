//
//  ShoppingCartTableViewCell.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/17/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class ShoppingCartTableViewCell: UITableViewCell {

 let containerView: ShoppingCellContainerView = {
     let containerView = ShoppingCellContainerView()
    containerView.translatesAutoresizingMaskIntoConstraints = false
  
   return containerView
 }()
    

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
   
    contentView.addSubview(containerView)
    containerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    
    containerView.mainData.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
