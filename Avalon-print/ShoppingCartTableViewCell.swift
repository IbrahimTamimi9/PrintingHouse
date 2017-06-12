//
//  ShoppingCartTableViewCell.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/7/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//

import UIKit
 
class ShoppingCartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainData: UITextView!
  
    @IBOutlet weak var purchasePrice: UILabel!
  
    @IBOutlet weak var purchaseNDSPrice: UILabel!
  
    @IBOutlet weak var layout: UIImageView!
  
    let previewLabel: UILabel = {
      
      let previewLabel = UILabel()
      
      previewLabel.text = "Нажмите чтобы открыть превью"
      previewLabel.numberOfLines = 2
      previewLabel.textColor = UIColor(red:0.34, green:0.59, blue:0.96, alpha:1.0)
      previewLabel.font = UIFont.systemFont(ofSize: 12)
      previewLabel.textAlignment = .center
      previewLabel.translatesAutoresizingMaskIntoConstraints = false

    return previewLabel
  }()
  
 
  override func awakeFromNib() {
    super.awakeFromNib()
    
    layout.layer.cornerRadius = 16
    layout.layer.borderWidth = 1
    layout.layer.borderColor = UIColor.lightGray.cgColor
    
    
    layout.addSubview(previewLabel)
    previewLabel.leftAnchor.constraint(equalTo: layout.leftAnchor, constant: 5).isActive = true
    previewLabel.rightAnchor.constraint(equalTo: layout.rightAnchor, constant: -5).isActive = true
    previewLabel.topAnchor.constraint(equalTo: layout.topAnchor, constant: 5).isActive = true
    previewLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
  }
  
}
