//
//  ShoppingCartDetailTableViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/26/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class ShoppingCartDetailTableViewController: UITableViewController {
  
  var selectedShoppingCard = Int()
  
  let cellIdWithData = "CellWithData"
  
  let cellIdWithLayouts = "CellWithLayouts"
  
  var startingFrame: CGRect?
  
  var blackBackgroundView: UIView?
  
  var startingImageView: UIImageView?
  
  var fullSizeOpeningImage = UIImage()

  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      self.title = NSLocalizedString("ShoppingCartDetailTableViewController.title", comment: "")
      
      tableView.separatorStyle = .none
      tableView.backgroundColor = UIColor.white
      tableView.allowsSelection = false
   
      tableView.register(ShoppingCartDetailTextTableViewCell.self, forCellReuseIdentifier: cellIdWithData)
      tableView.register(ShoppingCartDetailLayoutTableViewCell.self, forCellReuseIdentifier: cellIdWithLayouts)
      tableView.estimatedRowHeight = 44.0
      tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

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
      
      print("it s in cell for row at indexPath ,\(selectedShoppingCard)")
      let presentItem = addedItems[selectedShoppingCard]
      
      if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdWithData, for: indexPath) as! ShoppingCartDetailTextTableViewCell
        
        cell.mainData.attributedText = attributedOrderInfo(titleFromCell: "\(presentItem.productType!)\n",
                                                 mainDataFromCell: "\n\(presentItem.list!)\n\( presentItem.postprint!)",
                                                 priceFromCell: "\n\n\(priceLocalizedLabel): \(presentItem.price!) \(currencyTypeLocalizedLabel).\n\(ndsPriceLocalizedLabel): \(presentItem.ndsPrice!) \(currencyTypeLocalizedLabel).")

        return cell
        
      } else {
        
        if presentItem.layoutImage != nil {
          let cell = tableView.dequeueReusableCell(withIdentifier: cellIdWithLayouts, for: indexPath) as! ShoppingCartDetailLayoutTableViewCell
          
          
          
          let tapOnPreview = UITapGestureRecognizer(target: self, action: #selector(handleZoomTap))
          cell.layout.addGestureRecognizer(tapOnPreview)
          
          let layoutFullSize = UIImage(data: presentItem.layoutImage! as Data)
          
          let needdedWidth = screenSize.width - 20
          
          fullSizeOpeningImage = layoutFullSize!
          
          cell.layout.image = imageWithImage(sourceImage: layoutFullSize!, scaledToWidth: CGFloat(needdedWidth))//layoutFullSize
        
          return cell
          
        } else {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: cellIdWithData, for: indexPath) as! ShoppingCartDetailTextTableViewCell
          cell.mainData.text =  "\(NSLocalizedString("LayoutSelectionView.layoutTitle.text", comment: "")): \(presentItem.layoutLink!)"
          
          return cell
        }
      }
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
