//
//  Extensions.swift
//  Avalon-print
//
//  Created by Roman Mizin on 3/25/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import SDWebImage

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        //self.image = nil
       // let placeholderIMG = UIImage(named: "placeholderProfileImage.png")
      
//      if SDWebImageManager.shared().cachedImageExists(for: URL(string: urlString)) {
//        
//      }
       DispatchQueue.global(qos: .default).async(execute: {() -> Void in
          self.sd_setImage(with: URL(string: urlString), placeholderImage: nil, options: [.progressiveDownload, .lowPriority, .continueInBackground])
      })
  
      
    //  sd_setImage(with: URL(string: urlString))
     // let sss = UIImageView.self
    
//
//        //check cache for image first
//        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
//            self.image = cachedImage
//            return
//        }
//        
//        //otherwise fire off a new download
//        let url = URL(string: urlString)
//      
//        URLSession.shared.dataTask(with: url!) { (data, response, error) in
//            
//            //download hit an error so lets return out
//            if error != nil {
//                print(error as Any)
//                return
//            }
//            
//            DispatchQueue.main.async(execute: {
//                
//                if let downloadedImage = UIImage(data: data!) {
//                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
//                    
//                    self.image = downloadedImage
//                }
//            })
//            
//        }.resume()
    }
}
