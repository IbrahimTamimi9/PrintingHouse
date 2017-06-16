//
//  ShoppingCartVC.swift
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
    @IBOutlet weak var editButton: UIButton!
  
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?


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
  
    
    @IBAction func editButtonClicked(_ sender: Any) {
      
      purchaseTableView.setEditing(!purchaseTableView.isEditing, animated: true)
  
    if  purchaseTableView.isEditing == true {
        let doneImage = UIImage(named: "done.png")
            editButton.setImage(doneImage, for: .normal)
     } else {
          let editImage = UIImage(named: "edit.png")
              editButton.setImage(editImage, for: .normal)
      }
          
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

      if presentItem.layoutImage == nil {
        
          cell.layout.isUserInteractionEnabled = false
        
          cell.mainData?.text = presentItem.list
          cell.purchasePrice?.text = presentItem.price
          cell.purchaseNDSPrice?.text = presentItem.ndsPrice
          cell.previewLabel.text = presentItem.layoutLink
          cell.previewLabel.textColor = UIColor.darkGray
        
      } else {
        
        let tapOnPreview = UITapGestureRecognizer(target: self, action: #selector(handleZoomTap))
        cell.layout.addGestureRecognizer(tapOnPreview)
      
        cell.layout.isUserInteractionEnabled = true
        cell.mainData?.text = presentItem.list
        cell.purchasePrice?.text = presentItem.price
        cell.purchaseNDSPrice?.text = presentItem.ndsPrice
        cell.previewLabel.text = "Нажмите чтобы открыть превью"
        cell.previewLabel.textColor = UIColor(red:0.34, green:0.59, blue:0.96, alpha:1.0)
      }
      
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
  
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    purchaseTableView.setEditing(editing, animated: animated)
  }
  
}



/* thumbnail
 
 func compressImage (_ image: UIImage) -> UIImage {
 
 let size = CGSize(width: 100, height: 100)
 
 // Define rect for thumbnail
 let scale = max(size.width/image.size.width, size.height/image.size.height)
 let width = image.size.width * scale
 let height = image.size.height * scale
 let x = (size.width - width) / CGFloat(2)
 let y = (size.height - height) / CGFloat(2)
 let thumbnailRect = CGRect(x: x, y: y, width: width, height: height)
 
 // Generate thumbnail from image
 UIGraphicsBeginImageContextWithOptions(size, false, 0)
 image.draw(in: thumbnailRect)
 let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
 UIGraphicsEndImageContext()
 
 return thumbnail!
 
 }
 */


/* just compression
 
 func compressImage (_ image: UIImage) -> UIImage {
 
 //    let actualHeight:CGFloat = image.size.height
 //    let actualWidth:CGFloat = image.size.width
 //    let imgRatio:CGFloat = actualWidth/actualHeight
 //    let maxWidth:CGFloat = 1024.0
 //    let resizedHeight:CGFloat = maxWidth/imgRatio
 //    let compressionQuality:CGFloat = 0.5
 //
 //    let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
 //    UIGraphicsBeginImageContext(rect.size)
 //    image.draw(in: rect)
 //    let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
 //    let imageData:Data = UIImageJPEGRepresentation(img, compressionQuality)!
 //    UIGraphicsEndImageContext()
 
 return UIImage(data: imageData)!
 
 }
 */




