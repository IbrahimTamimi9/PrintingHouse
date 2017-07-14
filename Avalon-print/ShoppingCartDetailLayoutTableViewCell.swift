//
//  ShoppingCartDetailLayoutTableViewCell.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/26/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class ShoppingCartDetailLayoutTableViewCell: UITableViewCell {
  
  
    let layout: UIImageView = {
      let layout = UIImageView()
  
      layout.translatesAutoresizingMaskIntoConstraints = false
      layout.layer.cornerRadius = 11
      layout.contentMode = .scaleAspectFill
      layout.isUserInteractionEnabled = true
      layout.layer.masksToBounds = true
    
      return layout
    }()

  
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = AvalonPalette.avalonControllerBackground
    layout.backgroundColor = backgroundColor
    
    contentView.addSubview(layout)
    layout.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    layout.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    layout.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
  
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
