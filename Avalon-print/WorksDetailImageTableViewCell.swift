//
//  WorksDetailImageTableViewCell.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/3/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class WorksDetailImageTableViewCell: UITableViewCell {

  let layout: UIImageView = {
    let layout = UIImageView()
    
    layout.translatesAutoresizingMaskIntoConstraints = false
    layout.layer.cornerRadius = 11
    layout.contentMode = .scaleAspectFill
    layout.isUserInteractionEnabled = true
    layout.layer.masksToBounds = true
    
    return layout
  }()
  
  let previewTitle: UILabel = {
    let previewTitle = UILabel()
    
    previewTitle.text = "Загрузить превью макета"
    previewTitle.numberOfLines = 2
    previewTitle.textColor = UIColor(red:0.34, green:0.59, blue:0.96, alpha:1.0)
    previewTitle.font = UIFont.systemFont(ofSize: 17)
    previewTitle.textAlignment = .center
    previewTitle.translatesAutoresizingMaskIntoConstraints = false
    previewTitle.numberOfLines = 0
    previewTitle.lineBreakMode = .byWordWrapping
    previewTitle.restorationIdentifier = "previewTitle"
    
    return previewTitle
  }()
  
  
  let previewProgressView: UIProgressView = {
    let previewProgressView = UIProgressView()
    previewProgressView.translatesAutoresizingMaskIntoConstraints = false
    previewProgressView.progressViewStyle = .default
    previewProgressView.restorationIdentifier = "progressView"
    previewProgressView.isHidden = true
    
    return previewProgressView
  }()
    
  var layoutWidthConstraint: NSLayoutConstraint?
  var layotHeightConstraint: NSLayoutConstraint?

  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = AvalonPalette.avalonControllerBackground
    layout.backgroundColor = backgroundColor

    contentView.addSubview(layout)
    layout.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
    layout.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    layout.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    layoutWidthConstraint = layout.widthAnchor.constraint(equalToConstant: screenSize.width - 20)
    layotHeightConstraint = layout.heightAnchor.constraint(equalToConstant: 103)
    
    layoutWidthConstraint?.isActive = true
    layotHeightConstraint?.isActive = true
    
    layout.addSubview(previewTitle)
    previewTitle.topAnchor.constraint(equalTo: layout.topAnchor, constant: 5).isActive = true
    previewTitle.leadingAnchor.constraint(equalTo: layout.leadingAnchor, constant: 5).isActive = true
    previewTitle.trailingAnchor.constraint(equalTo: layout.trailingAnchor, constant: -5).isActive = true
    previewTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    
    layout.addSubview(previewProgressView)
    previewProgressView.centerXAnchor.constraint(equalTo: layout.centerXAnchor).isActive = true
    previewProgressView.widthAnchor.constraint(equalToConstant: 250).isActive = true
    previewProgressView.topAnchor.constraint(equalTo: layout.topAnchor, constant: 10).isActive = true
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
