//
//  OrdersHeaderVIew.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/2/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class OrdersHeaderVIew: UIView {

  
  let title: UILabel = {
    let title = UILabel()
    title.text = "Заказы"
    title.font =  UIFont.systemFont(ofSize: 34)
    title.textColor = UIColor.black
    title.translatesAutoresizingMaskIntoConstraints = false
    
    return title
  }()
  
  let segments = ["Активные", "Выполненные"]
  
  var segmentedControl = UISegmentedControl()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
    
    segmentedControl = UISegmentedControl(items: segments)
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.backgroundColor = backgroundColor
    
    title.backgroundColor = backgroundColor

    addSubview(title)
    title.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    
    addSubview(segmentedControl)
    segmentedControl.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 3).isActive = true
    segmentedControl.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
    segmentedControl.trailingAnchor.constraint(equalTo: title.trailingAnchor).isActive = true
  }
  
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  

  
}
