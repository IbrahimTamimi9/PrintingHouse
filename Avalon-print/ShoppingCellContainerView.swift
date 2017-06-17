//
//  ShoppingCellContainerView.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/17/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class ShoppingCellContainerView: UIView {

  var productionType: UILabel = {
    var productionType = UILabel()
    
    productionType.font = UIFont.systemFont(ofSize: 21, weight: 21)
    productionType.translatesAutoresizingMaskIntoConstraints = false

    productionType.numberOfLines = 0
    productionType.lineBreakMode = .byWordWrapping
    
    return productionType
  }()
  
  var mainData: UILabel = {
    var mainData = UILabel()
    
    mainData.font = UIFont.systemFont(ofSize: 15)
    mainData.translatesAutoresizingMaskIntoConstraints = false
   
    mainData.numberOfLines = 0
    mainData.lineBreakMode = .byWordWrapping

    return mainData
  }()
  
  
  let price : UILabel = {
    let price = UILabel()
    
    price.font = UIFont.systemFont(ofSize: 16, weight: 21)
    price.translatesAutoresizingMaskIntoConstraints = false
    
    price.numberOfLines = 0
    price.lineBreakMode = .byWordWrapping
    
    return price
  }()
  
  
  let layoutTitle : UILabel = {
    let layoutTitle = UILabel()
    
    layoutTitle.text = "Макет"
    layoutTitle.font =  UIFont.systemFont(ofSize: 20, weight: 1)
    layoutTitle.translatesAutoresizingMaskIntoConstraints = false
    layoutTitle.numberOfLines = 0
    layoutTitle.lineBreakMode = .byWordWrapping
    
    return layoutTitle
  }()
  
  let previewTitle: UILabel = {
    let previewTitle = UILabel()
    
    previewTitle.text = "Нажмите чтобы открыть превью"
    previewTitle.numberOfLines = 2
    previewTitle.textColor = UIColor(red:0.34, green:0.59, blue:0.96, alpha:1.0)
    previewTitle.font = UIFont.systemFont(ofSize: 12)
    previewTitle.textAlignment = .center
    previewTitle.translatesAutoresizingMaskIntoConstraints = false
    previewTitle.numberOfLines = 0
    previewTitle.lineBreakMode = .byWordWrapping
    
    return previewTitle
  }()
  
  let layout: UIImageView = {
    let layout = UIImageView()
    
    layout.translatesAutoresizingMaskIntoConstraints = false
    layout.layer.cornerRadius = 16
    layout.layer.borderColor = UIColor.lightGray.cgColor
    layout.layer.borderWidth = 1
    layout.image = UIImage(named: "upload_image_icon")
    layout.contentMode = .bottom
    layout.isUserInteractionEnabled = true
    layout.clipsToBounds = true
    
    return layout
  }()

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(productionType)
    productionType.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
    productionType.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
    productionType.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
    
    addSubview(mainData)
    mainData.topAnchor.constraint(equalTo: productionType.bottomAnchor, constant: 5).isActive = true
    mainData.leadingAnchor.constraint(equalTo: productionType.leadingAnchor).isActive = true
   
    addSubview(price)
    price.leadingAnchor.constraint(equalTo: mainData.leadingAnchor).isActive = true
    price.topAnchor.constraint(equalTo: mainData.bottomAnchor, constant: 10).isActive = true
   
    addSubview(layout)
    layout.leadingAnchor.constraint(equalTo: price.leadingAnchor).isActive = true
    layout.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    layout.widthAnchor.constraint(equalToConstant: 130).isActive = true
    layout.heightAnchor.constraint(equalToConstant: 104).isActive = true
    
    addSubview(layoutTitle)
    layoutTitle.leadingAnchor.constraint(equalTo: price.leadingAnchor).isActive = true
    layoutTitle.bottomAnchor.constraint(equalTo: layout.topAnchor, constant: -10).isActive = true
    
    layout.addSubview(previewTitle)
    previewTitle.topAnchor.constraint(equalTo: layout.topAnchor, constant: 5).isActive = true
    previewTitle.leadingAnchor.constraint(equalTo: layout.leadingAnchor, constant: 5).isActive = true
    previewTitle.trailingAnchor.constraint(equalTo: layout.trailingAnchor, constant: -5).isActive = true
    previewTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true

  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
}
