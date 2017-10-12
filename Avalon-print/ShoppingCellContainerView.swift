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
    
    productionType.font = UIFont.systemFont(ofSize: 20)
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
    
    price.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 21))
    price.translatesAutoresizingMaskIntoConstraints = false
    price.numberOfLines = 0
    price.lineBreakMode = .byWordWrapping
    
    return price
  }()
  
  
  let moreButton: UIButton = {
    let moreButton = UIButton()
    
    moreButton.translatesAutoresizingMaskIntoConstraints = false
    moreButton.setTitle("...", for: .normal)
    moreButton.setTitleColor(AvalonPalette.avalonBlue, for: .normal)
    moreButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
    moreButton.contentHorizontalAlignment = .right
    moreButton.addTarget(self, action: #selector(ShoppingCartVC.moreButtonTapped(_:)), for: .touchUpInside)

    return moreButton
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
   
    addSubview(productionType)
    productionType.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
    productionType.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
    productionType.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    
    addSubview(mainData)
    mainData.topAnchor.constraint(equalTo: productionType.bottomAnchor, constant: 0).isActive = true
    mainData.leadingAnchor.constraint(equalTo: productionType.leadingAnchor).isActive = true
    mainData.heightAnchor.constraint(equalToConstant: 80).isActive = true
 
    addSubview(price)
    price.leadingAnchor.constraint(equalTo: mainData.leadingAnchor).isActive = true
    price.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
  
    addSubview(moreButton)
    moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    moreButton.leadingAnchor.constraint(equalTo: price.trailingAnchor, constant: 0).isActive = true
    moreButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
   
    layer.cornerRadius = 8
    layer.masksToBounds = true
    
    for subview in subviews {
      subview.backgroundColor = AvalonPalette.avalonUiViewGray
    }
    
    backgroundColor = AvalonPalette.avalonUiViewGray
    moreButton.titleLabel?.backgroundColor = backgroundColor

  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
}
