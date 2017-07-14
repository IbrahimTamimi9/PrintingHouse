//
//  CheckoutVC.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/18/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit


class CheckoutVC: UIViewController {
  
 // var ordersCount = Int()  /* using in CheckoutVCOrderSender */
  
  var attachedImagesNumber = 0 /* using in CheckoutVCOrderSender */
  
  let scrollView = UIScrollView(frame: UIScreen.main.bounds)
  
  let containerView = CheckoutVCContainer(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 730))

    override func viewDidLoad() {
        super.viewDidLoad()
      
        containerView.localyRetrieveUserData()
        hideKeyboardWhenTappedAround()
        setupKeyboardObservers()
      
        view.backgroundColor = UIColor.white
      
        self.scrollView.delegate = self
      
        self.view.addSubview(scrollView)
        scrollView.addSubview(containerView)
    }
  
  
   override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
       scrollView.contentSize = CGSize(width: screenSize.width, height: 730)
   }
}


extension CheckoutVC {/* keyboard */
  
  func setupKeyboardObservers() {
   NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
   NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  
  func handleKeyboardWillShow(_ notification: Notification) {
    let keyboardFrame = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
    let keyboardDuration = ((notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
    
  if  containerView.comments.isFirstResponder || containerView.deliveryAdress.isFirstResponder {
       containerView.frame.origin.y = -keyboardFrame!.height
    }
 
    UIView.animate(withDuration: keyboardDuration!, animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  
  func handleKeyboardWillHide(_ notification: Notification) {
    let keyboardDuration = ((notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
    
  
   containerView.frame.origin.y = 0
    
    UIView.animate(withDuration: keyboardDuration!, animations: {
      self.view.layoutIfNeeded()
    })
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
