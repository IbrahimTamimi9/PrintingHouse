//
//  PreviewZoomHandling.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/12/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import Foundation



extension ShoppingCartVC {
  
  
  func handleZoomTap(_ tapGesture: UITapGestureRecognizer) {
    
    if let imageView = tapGesture.view as? UIImageView {
  
        guard let cell = tapGesture.view?.superview?.superview as? ShoppingCartTableViewCell else {
          return
        }
        
      if let indexPath = purchaseTableView.indexPath(for: cell) {
         let row = indexPath.row
        
         performZoomInForStartingImageView(imageView, row: row)
         //print( row, "2134567865432")
      }
    }
  }
  
  
  func performZoomInForStartingImageView(_ startingImageView: UIImageView, row: Int) {
    
    let presentItem = addedItems[row]
    let layoutFullSize = UIImage(data: presentItem.layoutImage! as Data)
    
    self.startingImageView = startingImageView
    
    startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
    
    let zoomingImageView = UIImageView(frame: startingFrame!)
    
    zoomingImageView.image = layoutFullSize
    zoomingImageView.isUserInteractionEnabled = true
    zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
    
    if let keyWindow = UIApplication.shared.keyWindow {
      blackBackgroundView = UIView(frame: keyWindow.frame)
      blackBackgroundView?.backgroundColor = UIColor.black
      blackBackgroundView?.alpha = 0
      
      keyWindow.addSubview(blackBackgroundView!)
      keyWindow.addSubview(zoomingImageView)
      
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        
        self.blackBackgroundView?.alpha = 1
        zoomingImageView.contentMode = .scaleAspectFit
        zoomingImageView.frame = UIScreen.main.bounds
        
      }, completion: { (completed) in
        // do nothing
      })
    }
  }
  
  
  func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
    if let zoomOutImageView = tapGesture.view {
      //need to animate back out to controller
      zoomOutImageView.clipsToBounds = true
      
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        
        zoomOutImageView.frame = self.startingFrame!
        self.blackBackgroundView?.alpha = 0
        
        
      }, completion: { (completed) in
        zoomOutImageView.removeFromSuperview()
      })
    }
  }
}
