//
//  OrdersTableViewCell.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/2/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {

  var number: UILabel = {
    var number = UILabel()
    number.translatesAutoresizingMaskIntoConstraints = false
    number.text = "1"
    number.font = UIFont.systemFont(ofSize: 17)
    
    return number
  }()
  
  var title: UILabel = {
    var title = UILabel()
    title.translatesAutoresizingMaskIntoConstraints = false
    title.text = "Заказ за 13 июня 2017"
    title.font = UIFont.systemFont(ofSize: 17)
    
    return title
  }()

  
  var subtitle: UILabel = {
    var subtitle = UILabel()
    subtitle.translatesAutoresizingMaskIntoConstraints = false
    subtitle.text = "Статус заказа: новый заказ"
    subtitle.textColor = UIColor.lightGray
    subtitle.font = UIFont.systemFont(ofSize: 13)
    
    return subtitle
  }()

  
  let newAccessoryView: UIImageView = {
    let newAccessoryView = UIImageView()
    newAccessoryView.contentMode = .scaleAspectFit
    newAccessoryView.translatesAutoresizingMaskIntoConstraints = false
    newAccessoryView.image = UIImage(named: "OpenButton")
    return newAccessoryView
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = UIColor.white
    number.backgroundColor = backgroundColor
    title.backgroundColor = backgroundColor
    subtitle.backgroundColor = backgroundColor
   // newAccessoryView.backgroundColor = backgroundColor
  
    contentView.addSubview(number)
    number.topAnchor.constraint(equalTo: topAnchor, constant: 13).isActive = true
    number.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    
    contentView.addSubview(title)
    title.topAnchor.constraint(equalTo: number.topAnchor, constant: 0).isActive = true
    title.leadingAnchor.constraint(equalTo: number.trailingAnchor, constant: 16).isActive = true
    
    contentView.addSubview(subtitle)
    subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 3).isActive = true
    subtitle.leadingAnchor.constraint(equalTo: title.leadingAnchor, constant: 0).isActive = true
    subtitle.trailingAnchor.constraint(equalTo: title.trailingAnchor, constant: 0).isActive = true
    
    contentView.addSubview(newAccessoryView)
    newAccessoryView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
    newAccessoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
    newAccessoryView.heightAnchor.constraint(equalToConstant: 28).isActive = true
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}
