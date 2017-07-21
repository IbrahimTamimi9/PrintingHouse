//
//  CheckoutVCOrderSender.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/18/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage




extension CheckoutVC { /* handling sending order to firebase */
  
  func orderSent () {
    
    let localizableOrderPlacedAlertTitle = NSLocalizedString("CheckoutVCOrderSender.orderSent.alert.title", comment: "")
    let localizableOrderPlacedAlertMessage = NSLocalizedString("CheckoutVCOrderSender.orderSent.alert.message", comment: "")
    
    let alert = UIAlertController(title: localizableOrderPlacedAlertTitle,
                                  message: localizableOrderPlacedAlertMessage,
                                  preferredStyle: UIAlertControllerStyle.alert)
    
    alert.addAction(UIAlertAction(title: "Oк", style: UIAlertActionStyle.default) { UIAlertAction in
      
      self.dismiss(animated: true, completion: nil)
    })
    
    self.view.isUserInteractionEnabled = true
    self.present(alert, animated: true, completion: nil)
  }

  
  func placeOrderTapped () {
    
    print("tapped")
   
    ARSLineProgress.showWithProgress(initialValue: 0.0, onView: self.view) {
      self.view.isUserInteractionEnabled = true
      self.orderSent()
    }

     self.view.isUserInteractionEnabled = false
    
    let date = Date()
    let calendar = Calendar.current
    
    let day = calendar.component(.day, from: date)
    let month = calendar.component(.month, from: date)
    let year = calendar.component(.year, from: date)
    
    var monthString = String()
    
    if month == 1 { monthString = "01" }
    if month == 2 { monthString = "02" }
    if month == 3 { monthString = "03" }
    if month == 4 { monthString = "04" }
    if month == 5 { monthString = "05" }
    if month == 6 { monthString = "06" }
    if month == 7 { monthString = "07" }
    if month == 8 { monthString = "08" }
    if month == 9 { monthString = "09" }
    if month == 10 { monthString = "10" }
    if month == 11 { monthString = "11" }
    if month == 12 { monthString = "12" }

    
    
    //order info
    var orderInfoBlock: DatabaseReference!
    
   //  let orderId = FIRDatabase.database().reference().child("orders").childByAutoId()
    orderInfoBlock = Database.database().reference().child("orders").childByAutoId()//.child("Заказ \(orderId.key))")
   
    
    
    let orderInfoLabel = "orderInfo"
    let createdAtLabel = "createdAt"
    let createdAtValue = "\(date)"
    let createdAt = orderInfoBlock.child(createdAtLabel)
    createdAt.setValue(createdAtValue)
    
    var deliveryFinal = ""
    
    if containerView.deliverySelector.isOn {
      deliveryFinal = containerView.deliveryAdress.text!
    } else {
      deliveryFinal =  "Самовывоз"
    }
    
    
    let orderInfoContent: NSDictionary = [
      "orderStatus": "Новый заказ",
      "dateOfPlacement": ("\(day).\(monthString).\(year)"),
      "fullPrice": totalprice,
      "fullNDSPrice": totalNDSprice,
      "comments": containerView.comments.text!,
      "deliveryAdress": deliveryFinal ]
    
    
    let orderInfo = orderInfoBlock.child(orderInfoLabel)
    
    orderInfo.setValue(orderInfoContent)
    
    
    //user info to order info
    let userInfoToOrderInfoLabel = "userInfo"
    
    let userInfoToOrderInfoContent: NSDictionary = [ "userEmail": containerView.email.text!,
                                                     "userName": containerView.name.text!,
                                                     "userPhone": containerView.phone.text!,
                                                     "userUniqueID": Auth.auth().currentUser?.uid as Any ]
    
    let userInfoToOrderInfo = orderInfoBlock.child(userInfoToOrderInfoLabel)
    userInfoToOrderInfo.setValue(userInfoToOrderInfoContent)
    
    
    //works
    let worksID = "works"
    
    orderInfoBlock.child(worksID)
    
    for i in(0..<addedItems.count) {
      
      let exactOrderID = orderInfoBlock.childByAutoId().key
      
      let works = addedItems[i]
      
      var contentOfWork: NSDictionary = [:]
      
      if works.layoutLink != "" { /* means if it is a shopping card with layout link (without image) */
        
        contentOfWork =  [ "productionType": works.productType!,
                           "mainData": works.list!,
                           "postprint": works.postprint!,
                           "price": works.price!,
                           "ndsprice": works.ndsPrice!,
                           "printLayoutURL": works.layoutLink! ]
        
        let exactOrder = orderInfoBlock.child("works").child(exactOrderID)
        
        exactOrder.setValue(contentOfWork, withCompletionBlock: { (error, ref) in
          
          ARSLineProgress.updateWithProgress(100)
          
        })
        
      } else { /* means if it is a shopping card with attached print layout image */
        
        let layoutForRow = UIImage(data: works.layoutImage! as Data)
        
        uploadToFirebaseStorageUsingImage(layoutForRow!, completion: { (imageUrl) in
          
          contentOfWork =  [ "productionType": works.productType!,
                             "mainData": works.list!,
                             "postprint": works.postprint!,
                             "price": works.price!,
                             "ndsprice": works.ndsPrice!,
                             "printLayoutURL": imageUrl ]
          
          let exactOrder = orderInfoBlock.child("works").child(exactOrderID)
          
          exactOrder.setValue(contentOfWork)
          
        })
      }
    }
    
  }
  
   
  /* Number of shopping cards with print Layout images */
  fileprivate func attachedImagesCount ()  {
    
    var attachedImages = 0
    
    for works in addedItems {
      if works.layoutLink == "" {
        attachedImages += 1
      }
    }
    
    attachedImagesNumber = attachedImages
  }

  
  fileprivate func uploadToFirebaseStorageUsingImage(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
    
    let imageName = UUID().uuidString
    let ref = Storage.storage().reference().child("print_Layouts").child(imageName)
    
    if let uploadData = UIImageJPEGRepresentation(image, 1.0) {
      
      let uploadTask = ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
        
        if error != nil {
          print("Failed to upload image:", error as Any)
          return
        }
        
        if let imageUrl = metadata?.downloadURL()?.absoluteString {
          completion(imageUrl)
        }
        
      })
      
      // gets num of shopping cards without print layout image
      attachedImagesCount()
      
      uploadTask.observe(.progress) { snapshot in
        print(snapshot.progress!)
        
        let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)/Double(snapshot.progress!.totalUnitCount)
        
        print("\n", percentComplete, "\n")
        
        let uploadingProgress = CGFloat(percentComplete / Double(self.attachedImagesNumber))
        
        ARSLineProgress.updateWithProgress(uploadingProgress)
      }
      
      uploadTask.observe(.success) { snapshot in
        print("in success")
        
        self.attachedImagesNumber -= 1 /* means that one image is uploaded */
        print("in decreasing")
        
        if self.attachedImagesNumber == 0 {
          ARSLineProgress.updateWithProgress(100)
          self.view.isUserInteractionEnabled = true
        }
      }
      
      
      uploadTask.observe(.failure) { snapshot in
        ARSLineProgress.showFail()
        print("Проверьте интернет соединение и попробуйте снова")
        
      }
    }
  }
  
}
