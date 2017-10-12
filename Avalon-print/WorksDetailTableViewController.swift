//
//  WorksDetailTableViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/3/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import SDWebImage



class WorksDetailTableViewController: UITableViewController {

  var productType = String()
  var mainData = String()
  var postprint = String()
  var price = String()
  var layoutURL = String()
  
  let cellIdWithData = "CellWithData"
  let cellIdWithLayouts = "CellWithLayouts"

  
  var startingFrame: CGRect?
  
  var blackBackgroundView: UIView?
  
  var startingImageView: UIImageView?
  
  var fullSizeOpeningImage = UIImage()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Информация"
    
    tableView.separatorStyle = .none
    tableView.backgroundColor = UIColor.white
    tableView.allowsSelection = false
    
    tableView.register(WorksDetailTextTableViewCell.self, forCellReuseIdentifier: cellIdWithData)
    tableView.register(WorksDetailImageTableViewCell.self, forCellReuseIdentifier: cellIdWithLayouts)
    
    tableView.estimatedRowHeight = 44.0
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
    if indexPath.section == 0 {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: cellIdWithData, for: indexPath) as! WorksDetailTextTableViewCell
      
      cell.mainData.attributedText = attributedOrderInfo(titleFromCell: "\(productType)\n", mainDataFromCell: "\n\(mainData)\n\n\(postprint)",priceFromCell: "\n\n\(price)")
      
      return cell
      
    } else {
      
      let urlVerified = verifyUrl(urlString: layoutURL)
    
      if urlVerified {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdWithLayouts, for: indexPath) as! WorksDetailImageTableViewCell
       
        let loadLayout = UITapGestureRecognizer(target: self, action: #selector(handleLayoutLoading))
        let tapOnPreview = UITapGestureRecognizer(target: self, action: #selector(handleZoomTap))
       

        if cell.layout.image == nil {
          
          if SDWebImageManager.shared().cachedImageExists(for: URL(string: layoutURL)) {

            
            cell.layout.removeGestureRecognizer(loadLayout)
            cell.layout.addGestureRecognizer(tapOnPreview)
            cell.previewTitle.isHidden = true
            cell.layotHeightConstraint?.isActive = false
            cell.layoutWidthConstraint?.isActive = false
           
            
            let loadedImageView = UIImageView()
            
            loadedImageView.sd_setImage(with: URL(string: self.layoutURL), placeholderImage: nil, options: [.continueInBackground, .progressiveDownload]) { (image, error, cacheType, url) in
              
              self.fullSizeOpeningImage = loadedImageView.image!
            
             
              cell.layout.image = imageWithImage(sourceImage: loadedImageView.image!, scaledToWidth: screenSize.width - 20)
              
              self.tableView.reloadData()
              
            }
            
          } else {

              cell.layout.addGestureRecognizer(loadLayout)
          }

        } else {
          
          cell.layout.removeGestureRecognizer(loadLayout)
          cell.layout.addGestureRecognizer(tapOnPreview)
          cell.previewTitle.isHidden = true
          cell.layotHeightConstraint?.isActive = false
          cell.layoutWidthConstraint?.isActive = false
        }
        
        return cell
        
      } else {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdWithData, for: indexPath) as! WorksDetailTextTableViewCell
      
        cell.mainData.text = "Макет: \(layoutURL)"
        
        return cell
      }
    }
  }
  

    func verifyUrl (urlString: String?) -> Bool {
      if let urlString = urlString {
        if let url  = NSURL(string: urlString) {
          return UIApplication.shared.canOpenURL(url as URL)
        }
      }
      return false
    }
  
  
  fileprivate func attributedOrderInfo( titleFromCell: String, mainDataFromCell: String, priceFromCell: String ) -> NSMutableAttributedString {
    
    let titleAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20) ]
    
    let bodyAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17) ]
    
    let bodyAttributesBold = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight(rawValue: 17)) ]
    
    let combination = NSMutableAttributedString()
    
    let title = titleFromCell
    
    let mainData = mainDataFromCell
    
    let price = priceFromCell
    
    let titleString = NSMutableAttributedString(string: title, attributes: titleAttributes)
    let mainDataString = NSMutableAttributedString(string: mainData, attributes: bodyAttributes)
    let priceString = NSMutableAttributedString(string: price, attributes: bodyAttributesBold)
    
    
    combination.append(titleString)
    combination.append(mainDataString)
    combination.append(priceString)
    
    
    return combination
  }
}
