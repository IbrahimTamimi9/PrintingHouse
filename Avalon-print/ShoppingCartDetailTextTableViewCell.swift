//
//  ShoppingCartDetailTextTableViewCell.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/26/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class ShoppingCartDetailTextTableViewCell: UITableViewCell {
  
  let containerView: UIView = {
    let containerView = UIView()
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.layer.cornerRadius = 11
    containerView.backgroundColor = AvalonPalette.avalonUiViewGray
    return containerView
  }()
  
  
  var mainData: UILabel = {
    var mainData = UILabel()
    
    mainData.font = UIFont.systemFont(ofSize: 15)
    mainData.translatesAutoresizingMaskIntoConstraints = false
    mainData.backgroundColor = AvalonPalette.avalonUiViewGray
    mainData.numberOfLines = 0
    mainData.lineBreakMode = .byWordWrapping
    
    return mainData
  }()
  

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(containerView)
    containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
    containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
    containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,  constant: 10).isActive = true
    containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,  constant: -10).isActive = true

    containerView.addSubview(mainData)
    mainData.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5).isActive = true
    mainData.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5).isActive = true
    mainData.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,  constant: 10).isActive = true
    mainData.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,  constant: -10).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
