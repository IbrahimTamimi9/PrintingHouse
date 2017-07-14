//
//  PictureZoomHandling.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/27/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import Foundation


func imageWithImage (sourceImage:UIImage, scaledToWidth: CGFloat) -> UIImage {
  let oldWidth = sourceImage.size.width
  let scaleFactor = scaledToWidth / oldWidth
  
  let newHeight = sourceImage.size.height * scaleFactor
  let newWidth = oldWidth * scaleFactor
  
  UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
  sourceImage.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
  let newImage = UIGraphicsGetImageFromCurrentImageContext()
  UIGraphicsEndImageContext()
  return newImage!
}


extension LayoutSelectionView {
  
  func handleZoomTap(_ tapGesture: UITapGestureRecognizer) {
    if let imageView = tapGesture.view as? UIImageView {
      //PRO Tip: don't perform a lot of custom logic inside of a view class
      
      performZoomInForStartingImageView(imageView)
    }
  }
  
  
  func performZoomInForStartingImageView(_ initialImageView: UIImageView) {
    
    self.startingImageView = initialImageView
    
    self.startingImageView?.isHidden = true
    
    self.startingFrame = initialImageView.superview?.convert(initialImageView.frame, to: nil)
    
    let zoomingImageView = UIImageView(frame: self.startingFrame!)
    
    zoomingImageView.image = self.fullSizeOpeningImage
    
    zoomingImageView.isUserInteractionEnabled = true
    
    zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
    
    
    if let keyWindow = UIApplication.shared.keyWindow {
      self.blackBackgroundView = UIView(frame: keyWindow.frame)
      self.blackBackgroundView?.backgroundColor = UIColor.black
      self.blackBackgroundView?.alpha = 0
      
      keyWindow.addSubview(self.blackBackgroundView!)
      keyWindow.addSubview(zoomingImageView)
      
      let scaledImage =  imageWithImage(sourceImage: zoomingImageView.image!, scaledToWidth: screenSize.width)
      let centerY = blackBackgroundView!.center.y - (scaledImage.size.height/2)

      
      UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
        
        self.blackBackgroundView?.alpha = 1
        
      //  zoomingImageView.contentMode = .scaleAspectFit
       // zoomingImageView.frame = UIScreen.main.bounds
        zoomingImageView.frame = CGRect(x: 0, y: centerY , width: scaledImage.size.width, height: scaledImage.size.height)

        
        //  zoomingImageView.center = keyWindow.center
        
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
        
        zoomOutImageView.layer.cornerRadius = 11
        
      }, completion: { (completed) in
        
        zoomOutImageView.removeFromSuperview()
        
        self.startingImageView?.isHidden = false
      })
    }
  }  
}


extension ShoppingCartDetailTableViewController {
  
  func handleZoomTap(_ tapGesture: UITapGestureRecognizer) {
    if let imageView = tapGesture.view as? UIImageView {
      print("tapped")
      //PRO Tip: don't perform a lot of custom logic inside of a view class
      
      performZoomInForStartingImageView(imageView)
    }
  }
  
  
  func performZoomInForStartingImageView(_ initialImageView: UIImageView) {
    
    self.startingImageView = initialImageView
    
    self.startingImageView?.isHidden = true
    
    self.startingFrame = initialImageView.superview?.convert(initialImageView.frame, to: nil)
    
    let zoomingImageView = UIImageView(frame: self.startingFrame!)
    
    zoomingImageView.image = initialImageView.image//self.fullSizeOpeningImage
    
    zoomingImageView.isUserInteractionEnabled = true
    
    zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
    
    
    if let keyWindow = UIApplication.shared.keyWindow {
      self.blackBackgroundView = UIView(frame: keyWindow.frame)
      self.blackBackgroundView?.backgroundColor = UIColor.black
      self.blackBackgroundView?.alpha = 0
      
      keyWindow.addSubview(self.blackBackgroundView!)
      keyWindow.addSubview(zoomingImageView)
      
      let scaledImage =  imageWithImage(sourceImage: zoomingImageView.image!, scaledToWidth: screenSize.width)
      let centerY = blackBackgroundView!.center.y - (scaledImage.size.height/2)
      
      UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
        
        self.blackBackgroundView?.alpha = 1
        
      //  zoomingImageView.contentMode = .scaleAspectFit
      //  zoomingImageView.frame = UIScreen.main.bounds
         zoomingImageView.frame = CGRect(x: 0, y: centerY , width: scaledImage.size.width, height: scaledImage.size.height)
        
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
        
        zoomOutImageView.layer.cornerRadius = 11
        
      }, completion: { (completed) in
        
        zoomOutImageView.removeFromSuperview()
        
        self.startingImageView?.isHidden = false
      })
    }
  }
}



extension WorksDetailTableViewController {
  
  func handleLayoutLoading(_ tapGesture: UITapGestureRecognizer) {
    var progressView = UIProgressView()
    var progressLabel = UILabel()
    
    if let imageView = tapGesture.view as? UIImageView {
      print("tapped")
      for subview in imageView.subviews {
        
        if subview.restorationIdentifier == "progressView" {
          progressView = subview as! UIProgressView
        }
        
        if subview.restorationIdentifier == "previewTitle" {
          progressLabel = subview as! UILabel
          
        }
      }
      downloadPreview(imageView, progressView: progressView, progresslabel: progressLabel)
      //PRO Tip: don't perform a lot of custom logic inside of a view class
      
     // performZoomInForStartingImageView(imageView)
    }
  }
  
  func downloadPreview(_ initialImageView: UIImageView, progressView: UIProgressView, progresslabel: UILabel) {
    let loadedImageView = UIImageView()
    
   // var progress = Int()
    progressView.isHidden = false
    
    loadedImageView.sd_setImage(with: URL(string: self.layoutURL), placeholderImage: nil, options: [.continueInBackground], progress: { (downloadedSize, expectedSize) in
      
   //   progress =  ((downloadedSize * 100) / (expectedSize * 100) )
      
   //   print(100 * downloadedSize/expectedSize)
      let progress = Double(100 * downloadedSize/expectedSize)

   print("Downloading progress:", progress * 0.01 , "%")
     // let progress =
      
      DispatchQueue.main.async {
        progressView.setProgress( Float(progress * 0.01), animated: true)
        progresslabel.text = "\(100 * downloadedSize/expectedSize) %"//"\(100 * downloadedSize/expectedSize) %"

      }
      
      
     
      
    }) { (image, error, cacheType, url) in
      
      
      if error == nil {
        progressView.removeFromSuperview()
        
        self.fullSizeOpeningImage = loadedImageView.image!
        
        initialImageView.image = imageWithImage(sourceImage: loadedImageView.image!, scaledToWidth: screenSize.width - 20)
        
        self.tableView.reloadData()
      } else {
        progresslabel.font = UIFont.systemFont(ofSize: 14)
        progresslabel.text = "Ошибка, проверьте подключение к интернету"
        
      }
      
    
    }
    

  }
  
  
  
  func handleZoomTap(_ tapGesture: UITapGestureRecognizer) {
    if let imageView = tapGesture.view as? UIImageView {
      print("tapped")
      //PRO Tip: don't perform a lot of custom logic inside of a view class
      
      performZoomInForStartingImageView(imageView)
    }
  }
 
  
  func performZoomInForStartingImageView(_ initialImageView: UIImageView) {
    
    self.startingImageView = initialImageView
    
    self.startingImageView?.isHidden = true
    
    self.startingFrame = initialImageView.superview?.convert(initialImageView.frame, to: nil)
    
    let zoomingImageView = UIImageView(frame: self.startingFrame!)
    
    zoomingImageView.image = self.fullSizeOpeningImage
    
    zoomingImageView.isUserInteractionEnabled = true
    
    zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
    
    
    if let keyWindow = UIApplication.shared.keyWindow {
      self.blackBackgroundView = UIView(frame: keyWindow.frame)
      self.blackBackgroundView?.backgroundColor = UIColor.black
      self.blackBackgroundView?.alpha = 0
      
      keyWindow.addSubview(self.blackBackgroundView!)
      keyWindow.addSubview(zoomingImageView)
      
      let scaledImage = imageWithImage(sourceImage: zoomingImageView.image!, scaledToWidth: screenSize.width)
      let centerY = blackBackgroundView!.center.y - (scaledImage.size.height/2)
      
      UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
        
        self.blackBackgroundView?.alpha = 1
        
        //  zoomingImageView.contentMode = .scaleAspectFit
        //  zoomingImageView.frame = UIScreen.main.bounds
        zoomingImageView.frame = CGRect(x: 0, y: centerY , width: scaledImage.size.width, height: scaledImage.size.height)
        
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
        
        zoomOutImageView.layer.cornerRadius = 11
        
      }, completion: { (completed) in
        
        zoomOutImageView.removeFromSuperview()
        
        self.startingImageView?.isHidden = false
      })
    }
  }
}

/*
 extension ShoppingCartVC {
 
 
 func handleZoomTap(_ tapGesture: UITapGestureRecognizer) {
 
 if let imageView = tapGesture.view as? UIImageView {
 
 guard let cell = tapGesture.view?.superview?.superview?.superview as? ShoppingCartTableViewCell else {
 return
 }
 
 if let indexPath = shoppingCardsTableView.indexPath(for: cell) {
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
 */
