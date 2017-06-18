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
    
    let alert = UIAlertController(title: "Ваш заказ успешно отправлен",
                                  message: "Наш менеджер свяжется с вами в ближайшее время, спасибо за доверие.",
                                  preferredStyle: UIAlertControllerStyle.alert)
    
    alert.addAction(UIAlertAction(title: "Oк", style: UIAlertActionStyle.default) { UIAlertAction in
      
      self.dismiss(animated: true, completion: nil)
    })
    
    self.view.isUserInteractionEnabled = true
    self.present(alert, animated: true, completion: nil)
  }

  
  func placeOrderTapped () {
    
    print("tapped")
    self.view.isUserInteractionEnabled = false
    ARSLineProgress.showWithProgress(initialValue: 0) {
      self.view.isUserInteractionEnabled = true
      self.orderSent()
    }
    
    let date = Date()
    let calendar = Calendar.current
    
    let day = calendar.component(.day, from: date)
    let month = calendar.component(.month, from: date)
    let year = calendar.component(.year, from: date)
    
    var monthString = String()
    
    if month == 1 { monthString = "января" }
    if month == 2 { monthString = "февраля" }
    if month == 3 { monthString = "марта" }
    if month == 4 { monthString = "апреля" }
    if month == 5 { monthString = "мая" }
    if month == 6 { monthString = "июня" }
    if month == 7 { monthString = "июля" }
    if month == 8 { monthString = "августа" }
    if month == 9 { monthString = "сентября" }
    if month == 10 { monthString = "октября" }
    if month == 11 { monthString = "ноября" }
    if month == 12 { monthString = "декабря" }
    
    
    //order info
    var orderInfoBlock: FIRDatabaseReference!
    
    orderInfoBlock = FIRDatabase.database().reference().child("orders").child("Заказ № \(ordersCount + 1)")
    
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
      "dateOfPlacement": ("\(day) \(monthString) \(year)"),
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
                                                     "userUniqueID": FIRAuth.auth()?.currentUser?.uid as Any ]
    
    let userInfoToOrderInfo = orderInfoBlock.child(userInfoToOrderInfoLabel)
    userInfoToOrderInfo.setValue(userInfoToOrderInfoContent)
    
    
    //works
    let worksID = "works"
    
    orderInfoBlock.child(worksID)
    
    for i in(0..<addedItems.count) {
      
      let exactOrderID = "work\(i)"
      
      let works = addedItems[i]
      
      var contentOfWork: NSDictionary = [:]
      
      if works.layoutLink != "" { /* means if it is a shopping card with layout link (without image) */
        
        contentOfWork =  [ "mainData": works.list!,
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
          
          contentOfWork =  [ "mainData": works.list!,
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
    let ref = FIRStorage.storage().reference().child("print_Layouts").child(imageName)
    
    if let uploadData = UIImageJPEGRepresentation(image, 1.0) {
      
      let uploadTask = ref.put(uploadData, metadata: nil, completion: { (metadata, error) in
        
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
        }
      }
      
      
      uploadTask.observe(.failure) { snapshot in
        ARSLineProgress.showFail()
        print("Проверьте интернет соединение и попробуйте снова")
        
      }
    }
  }
  
}
