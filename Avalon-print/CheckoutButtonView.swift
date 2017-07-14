//
//  CheckOutButtonView.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/17/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit



class CheckoutButtonView: UIView {

  let checkout: AvalonUIButton = {
    let checkout = AvalonUIButton()
    
    checkout.addTarget(self, action: #selector(ShoppingCartVC.checkoutButtonTapped), for: .touchUpInside)
    checkout.translatesAutoresizingMaskIntoConstraints = false
    checkout.setTitle(NSLocalizedString("CheckoutButtonView.checkout.title", comment: ""), for: .normal)
    
    return checkout
  }()
  
  let totalPrice: UILabel = {
    let totalPrice = UILabel()
    
    totalPrice.text = ""
    totalPrice.font =  UIFont.systemFont(ofSize: 13, weight: 21)
    totalPrice.textColor = UIColor.black
    totalPrice.translatesAutoresizingMaskIntoConstraints = false
    totalPrice.textAlignment = .right
    totalPrice.backgroundColor = UIColor.white
    
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
    totalPrice.trailingAnchor.constraint(equalTo: checkout.trailingAnchor, constant: 0).isActive = true
    totalPrice.leadingAnchor.constraint(equalTo: checkout.leadingAnchor).isActive = true
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    
  }

}
