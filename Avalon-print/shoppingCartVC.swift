//
//  shoppingCartVC.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/7/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//

import UIKit
import CoreData

 
  let presentRequest:NSFetchRequest<AddedItems> = AddedItems.fetchRequest()

  var addedItems = [AddedItems]()

  var managedObjextContext:NSManagedObjectContext!

  var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

  var offset: CGFloat = 70

  var totalprice = 0.0

  var totalNDSprice = 0.0


 class ShoppingCartVC: UIViewController {
    
    @IBOutlet weak var bottomViewWithButton: UIView!
    @IBOutlet weak var mainSumLabel: UILabel!
   
    @IBOutlet weak var purchaseTableView: UITableView!
    @IBOutlet weak var mainView: UIView!
  

    override func viewDidAppear(_ animated: Bool) {
        mainPriceSumCounter()
        purchaseTableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObjextContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      
        loadData()
        mainPriceSumCounter()
        bottomViewVisibility()
    }
    
    
    @IBAction func dismissBucket(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func loadData () {
        do {
            addedItems = try managedObjextContext.fetch(presentRequest)
            self.purchaseTableView.reloadData()
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
    }
    
  

    func bottomViewVisibility() {
        
        if addedItems.count == 0 {
            viewMoveIn(view: bottomViewWithButton)
        }
    }
    
    func mainPriceSumCounter () {
      
       totalprice = 0.0
      
       totalNDSprice = 0.0

      
        
        do {
            addedItems = try managedObjextContext.fetch(presentRequest)
        } catch {
            print(error)
        }
        
        
        for item in addedItems {
            totalprice += item.price!.doubleValue
            totalNDSprice += item.ndsPrice!.doubleValue
        }
        
                mainSumLabel.text = "Сумма: \(totalprice) грн, с НДС: \(totalNDSprice) грн."
                if (addedItems.count == 0) {
                     UIView.animate(withDuration: 0.2, animations: { self.mainSumLabel.alpha = 0.0 })
         }
        
     }
    
    //ANIMATIONS
    func viewMoveIn(view: UIView) {
        let animation = CABasicAnimation()
        
        animation.keyPath = "position.y"
        animation.fromValue  = 0
        animation.toValue = 100
        
        animation.duration = 0.4
        animation.isAdditive = true
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        view.isUserInteractionEnabled = false
        
        
        view.layer.add(animation, forKey: "fade")
    }


}



extension ShoppingCartVC: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedItems.count
    }
  
  
  
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ShoppingCartTableViewCell = self.purchaseTableView.dequeueReusableCell(withIdentifier: "cell") as! ShoppingCartTableViewCell
        
        let presentItem = addedItems[indexPath.row]
        
        cell.mainData?.text = presentItem.list
        cell.purchasePrice?.text = presentItem.price
        cell.purchaseNDSPrice?.text = presentItem.ndsPrice
      
    
      
    
      
        mainPriceSumCounter()
        
        return cell
    }
    
    
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context:NSManagedObjectContext = managedObjextContext
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            purchaseTableView.beginUpdates()
            
            context.delete(addedItems[indexPath.row] )
            addedItems.remove(at: indexPath.row)
            do {
                try context.save()
            } catch  {
                print("error : \(error)")
            }
            
            purchaseTableView.deleteRows(at: [indexPath], with: .fade )
            purchaseTableView.endUpdates()
            
            do {
                try managedObjextContext.save()
            } catch {
                print("error : \(error)")
            }
            
            bottomViewVisibility()
            mainPriceSumCounter()
            updateBadgeValue()
            
        }
    }
}

