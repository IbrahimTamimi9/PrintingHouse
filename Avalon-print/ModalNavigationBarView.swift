//
//  ModalNavigationBarView.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/17/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class ModalNavigationBarView: UIView {
  
  
  let leftBarButton: UIButton = {
    let leftBarButton = UIButton()
    leftBarButton.addTarget(self, action: #selector(ShoppingCartVC.leftBarButtonTapped), for: .touchUpInside)
    leftBarButton.translatesAutoresizingMaskIntoConstraints = false
    leftBarButton.setImage(UIImage(named: "ChevronLeft"), for: .normal)
    
    return leftBarButton
  }()
  
  let rightBarButton: UIButton = {
    let rightBarButton = UIButton()
    rightBarButton.addTarget(self, action: #selector(ShoppingCartVC.rightBarButtonTapped), for: .touchUpInside)
    rightBarButton.translatesAutoresizingMaskIntoConstraints = false
    rightBarButton.setImage(UIImage(named: "edit"), for: .normal)
    
    return rightBarButton
  }()
  
  let title: UILabel = {
    let title = UILabel()
    title.text = "Корзина"
    title.font =  UIFont.systemFont(ofSize: 18, weight: 21)
    title.textColor = UIColor.white
    title.translatesAutoresizingMaskIntoConstraints = false
    
    return title
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  
    backgroundColor = UIColor.clear
    
    addSubview(leftBarButton)
    leftBarButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    leftBarButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
    leftBarButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
    leftBarButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    addSubview(rightBarButton)
    rightBarButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    rightBarButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
    rightBarButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    rightBarButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    addSubview(title)
    title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    
  }
}
