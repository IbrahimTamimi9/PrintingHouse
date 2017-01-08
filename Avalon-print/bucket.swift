//
//  bucket.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/7/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//

import UIKit
import CoreData

  var list = [String]()
  var price = [String]()
  var ndsPrice = [String]()

 




  var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  var offset: CGFloat = 70


class bucket: UIViewController, UITabBarDelegate, UITableViewDataSource, UICollisionBehaviorDelegate, NSFetchedResultsControllerDelegate {
    
   
    
    
   //  var managedObjectContext: NSManagedObjectContext? = nvar    
    @IBOutlet var bottomViewWithButton: UIView!
    @IBOutlet var mainSumLabel: UILabel!
   
    @IBOutlet var purchaseTableView: UITableView!
    @IBOutlet weak var mainView: UIView!
    
    @IBAction func dismissBucket(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    
let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
          mainPriceSumCounter()
          bottomViewVisibility()
       
        
        
        mainView.backgroundColor = UIColor.clear
        blurEffectView.frame = mainView.bounds
        mainView.insertSubview(blurEffectView, at: 0)
        blurEffectView.layer.masksToBounds = true
        
       
    }
    
    
    
    func bottomViewVisibility() {
        
        if price.count == 0 {
            bottomViewWithButton.isHidden = true
    
        } else {
            bottomViewWithButton.isHidden = false
        }
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        mainPriceSumCounter()
        purchaseTableView.reloadData()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:bucketTableViewCell = self.purchaseTableView.dequeueReusableCell(withIdentifier: "cell") as! bucketTableViewCell
        
        cell.mainData?.text = list[indexPath.row]
        cell.purchasePrice?.text = price[indexPath.row]
        cell.purchaseNDSPrice?.text = ndsPrice[indexPath.row]
        mainPriceSumCounter()
    
        return cell
    }
    
     public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            purchaseTableView.beginUpdates()
            list.remove(at: indexPath.row)
            price.remove(at: indexPath.row)
            ndsPrice.remove(at: indexPath.row)
            purchaseTableView.deleteRows(at: [indexPath], with: .fade)

            
            bucketDefaults.removeObject(forKey: "ListStringArray")
            bucketDefaults.removeObject(forKey: "PriceStringArray")
            bucketDefaults.removeObject(forKey: "NdsPriceStringArray")
            
          
            
            let keyValue = bucketDefaults.array(forKey: "ListStringArray")
            let keyValue1 = bucketDefaults.array(forKey: "PriceStringArray")
            let keyValue2 = bucketDefaults.array(forKey: "NdsPriceStringArray")
            print("Key Value \(keyValue),\(keyValue1),\(keyValue2)")
            
            bucketDefaults.set(list, forKey: "ListStringArray")
            bucketDefaults.set(price, forKey: "PriceStringArray")
            bucketDefaults.set(ndsPrice, forKey: "NdsPriceStringArray")
           
            let keyValue3 = bucketDefaults.array(forKey: "ListStringArray")
            let keyValue4 = bucketDefaults.array(forKey: "PriceStringArray")
            let keyValue5 = bucketDefaults.array(forKey: "NdsPriceStringArray")
            print("Key Value \(keyValue3),\(keyValue4),\(keyValue5)")
        
            
            purchaseTableView.endUpdates()
            
    
            bottomViewVisibility()
            mainPriceSumCounter()
            
            //updatingRedBadgeNumber
            rightBarButton?.badgeValue = "\(price.count)"
           
        }
    }
    
    
    func mainPriceSumCounter () {
        
        //MARK: PRICE SUM COUNTER!!!
        let doubleArrayPrice = price.flatMap{ Double($0) }
        let doubleArrayNDSPrice = ndsPrice.flatMap{ Double($0) }
        let arraySum = doubleArrayPrice.reduce(0, +)
        let arrayNDSSum = doubleArrayNDSPrice.reduce(0, +)
        
        mainSumLabel.text = "Сумма: \(arraySum) грн, с НДС: \(arrayNDSSum) грн."
        if (price.count == 0) {
            mainSumLabel.text = ""
            
       }
    }
}
