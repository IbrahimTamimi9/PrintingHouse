//
//  CheckOutButtonView.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/17/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

struct AvalonPalette {
  static let avalonBlue = UIColor(red:0.00, green:0.50, blue:1.00, alpha:0.85)
}

class CheckoutButtonView: UIView {

  let checkout: AvalonUIButton = {
    let checkout = AvalonUIButton()
   // checkout.layer.cornerRadius = 10
    checkout.addTarget(self, action: #selector(ShoppingCartVC.checkoutButtonTapped), for: .touchUpInside)
    checkout.translatesAutoresizingMaskIntoConstraints = false
    //checkout.backgroundColor = AvalonPalette.avalonBlue//UIColor(red:0.00, green:0.50, blue:1.00, alpha:0.85)
    checkout.setTitle("Оформить заказ", for: .normal)
    
  
    return checkout
  }()
  
  let totalPrice: UILabel = {
    let totalPrice = UILabel()
    totalPrice.text = "вся цена"
    totalPrice.font =  UIFont.systemFont(ofSize: 13, weight: 21)
    totalPrice.textColor = UIColor.white
    totalPrice.translatesAutoresizingMaskIntoConstraints = false
    
    return totalPrice
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(checkout)
    checkout.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
    checkout.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    checkout.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
    checkout.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    
    addSubview(totalPrice)
    totalPrice.bottomAnchor.constraint(equalTo: checkout.topAnchor, constant: 0).isActive = true
    totalPrice.rightAnchor.constraint(equalTo: checkout.rightAnchor, constant: 0).isActive = true
    
    
    
    
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    
  }

}
