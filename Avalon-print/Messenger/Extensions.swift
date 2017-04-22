//
//  Extensions.swift
//  gameofchats
//
//  Created by Brian Voong on 7/5/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase


let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        //self.image = nil
      
      self.sd_setImage(with: URL(string: urlString), placeholderImage: nil, options: [.progressiveDownload, .continueInBackground, .highPriority])
      
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
