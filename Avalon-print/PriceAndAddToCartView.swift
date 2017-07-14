//
//  PriceAndAddToCartView.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/21/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit


var priceBlocHeightAnchor: NSLayoutConstraint?

class PriceAndAddToCartView: UIView {
  
  let addToCartButtonTitleAfterTapping = NSLocalizedString("PriceAndAddToCartView.addToCartButtonTitleAfterTapping", comment: "")
  //"Перейти в корзину"
  
  let addToCartButtonTitleBeforeTapping = NSLocalizedString("PriceAndAddToCartView.addToCartButtonTitleBeforeTapping", comment: "")
  //"Добавить в корзину"
  
  var price: UILabel = {
    var price = UILabel()

    price.translatesAutoresizingMaskIntoConstraints = false
    price.font =  UIFont.systemFont(ofSize: 15, weight: 1)
    price.text = NSLocalizedString("PriceAndAddToCartView.price.text", comment: "")
    //"Цена: 0 грн.\nЦена с НДС: 0 грн."
    price.numberOfLines = 2
    price.textAlignment = .right
    
    return price
  }()
  
  let addToCart: AvalonUIButtonLight = {
    let addToCart = AvalonUIButtonLight()
    addToCart.translatesAutoresizingMaskIntoConstraints = false
   
    addToCart.contentHorizontalAlignment = .right
    addToCart.isEnabled = false
    
    return addToCart
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor.white
    price.backgroundColor = backgroundColor
    addToCart.backgroundColor = backgroundColor
    
    addToCart.setTitle(addToCartButtonTitleBeforeTapping, for: .normal)
    
    addSubview(price)
    price.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
    price.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    price.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    
    addSubview(addToCart)
    addToCart.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 26).isActive = true
    addToCart.trailingAnchor.constraint(equalTo: price.trailingAnchor).isActive = true
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    
  }
  
  
  func ChangeAddToCartTitleToAdd() {
    
    UIView.transition(with: addToCart, duration: 0.3, options: .transitionCrossDissolve, animations: {
      self.addToCart.setTitle(self.addToCartButtonTitleBeforeTapping, for: .normal)
    }, completion: nil)

  }
  
  
  func ChangeAddToCartTitleToAdded() {
    
    UIView.transition(with: addToCart, duration: 0.3, options: .transitionCrossDissolve, animations: {
       self.addToCart.setTitle(self.addToCartButtonTitleAfterTapping, for: .normal)
    }, completion: nil)
  
  }

}
