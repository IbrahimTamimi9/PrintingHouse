//
//  CheckoutVC.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/18/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit


class CheckoutVC: UIViewController {
  
  var ordersCount = Int()  /* using in CheckoutVCOrderSender */
  var attachedImagesNumber = 0 /* using in CheckoutVCOrderSender */
  
  let scrollView = UIScrollView(frame: UIScreen.main.bounds)
  let containerView = CheckoutVCContainer(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 730))
  
  let background: UIImageView = {
    let background = UIImageView()
    
    background.image = UIImage(named: "bucketAndPlaceOrderBGv3")
    background.frame = UIScreen.main.bounds
    
    return background
  }()
  

    override func viewDidLoad() {
        super.viewDidLoad()
      
        containerView.localyRetrieveUserData()
        hideKeyboardWhenTappedAround()

        self.scrollView.delegate = self
        self.view.addSubview(background)
        self.view.addSubview(scrollView)
        scrollView.addSubview(containerView)
    }
  
  
   override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
       scrollView.contentSize = CGSize(width: screenSize.width, height: 730)
   }
  
}


extension CheckoutVC: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard scrollView.isEqual(scrollView) else {
      return
    }
    
    if let delegate = transitioningDelegate as? DeckTransitioningDelegate {
      if scrollView.contentOffset.y > 0 {
        // Normal behaviour if the `scrollView` isn't scrolled to the top
        scrollView.bounces = true
        delegate.isDismissEnabled = false
      } else {
        if scrollView.isDecelerating {
          // If the `scrollView` is scrolled to the top but is decelerating
          // that means a swipe has been performed. The view and scrollview are
          // both translated in response to this.
          view.transform = CGAffineTransform(translationX: 0, y: -scrollView.contentOffset.y)
          scrollView.transform = CGAffineTransform(translationX: 0, y: scrollView.contentOffset.y)
        } else {
          // If the user has panned to the top, the scrollview doesnʼt bounce and
          // the dismiss gesture is enabled.
          scrollView.bounces = false
          delegate.isDismissEnabled = true
        }
      }
    }
  }

}
