//
//  TypingIndicatorCell.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/18/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class TypingIndicatorCell: UICollectionViewCell {
  
  var typingIndicator: UIImageView = {
    var typingIndicator = UIImageView()
    typingIndicator.image = UIImage.sd_animatedGIFNamed("typingIndicator")
    typingIndicator.translatesAutoresizingMaskIntoConstraints = false
    typingIndicator.backgroundColor = .clear
    return typingIndicator
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(typingIndicator)
    typingIndicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    typingIndicator.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
    typingIndicator.widthAnchor.constraint(equalToConstant: 60).isActive = true
    typingIndicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func prepareForReuse() {
    super.prepareForReuse()
       typingIndicator.image = UIImage.sd_animatedGIFNamed("typingIndicator")
  }
    
}
