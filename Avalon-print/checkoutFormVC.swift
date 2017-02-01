//
//  checkoutFormVC.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 12/11/16.
//  Copyright © 2016 Константин. All rights reserved.
//

import UIKit
import DeckTransition
import FirebaseDatabase
import FirebaseAuth

var orderToFirebaseArray = [AddedItems]()

class checkoutFormVC: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var nameSurnameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var layoutLinkTF: UITextField!
    @IBOutlet weak var commentsTV: UITextView!
    @IBOutlet weak var deliveryAdress: UITextField!
    @IBOutlet weak var deliveryTime: UITextField!
    
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var layoutDevSwitch: UISwitch!
    @IBOutlet weak var deliverySwitch: UISwitch!
    
    @IBOutlet weak var checkOutButton: ButtonMockup!
    @IBOutlet weak var attachLayoutButton: UIButton!
    
     var ordersCount = Int()
  
    override func viewDidLoad() {
        super.viewDidLoad()
         managedObjextContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        commentsTV.clipsToBounds = true
        commentsTV.layer.cornerRadius = 5
        
        mainScrollView.delegate = self
        nameSurnameTF.delegate = self
        emailTF.delegate = self
        phoneTF.delegate = self
        layoutLinkTF.delegate = self
        deliveryAdress.delegate = self
        deliveryTime.delegate = self
        
        self.hideKeyboardWhenTappedAround()

        setFontsForControllers(textfield: [nameSurnameTF,phoneTF, emailTF, layoutLinkTF, deliveryAdress, deliveryTime], textview: commentsTV, label: commentsLabel)
        
        localyRetrieveUserData()
        validateRegistraionData()
      
      let countOfO = FIRDatabase.database().reference().child("orders")
      
      //print("Starting observing");
      countOfO.observe(.value, with: { (snapshot: FIRDataSnapshot!) in
        // print("Got snapshot");
        print(snapshot.childrenCount)
        self.ordersCount = Int(snapshot.childrenCount)
        print(self.ordersCount)
      })

      
    }
    
    
    @IBAction func layoutDevSwitchStateChanged(_ sender: Any) {
        
        if layoutDevSwitch.isOn == true {
            attachLayoutButton.isEnabled = false
            textfieldState(textField: layoutLinkTF, state: false)
        } else {
            attachLayoutButton.isEnabled = true
            textfieldState(textField: layoutLinkTF, state: true)
        }
    }
    
    
    @IBAction func deliverySwitchStateChanged(_ sender: Any) {
        
        if deliverySwitch.isOn == true {
            
            textfieldState(textField: deliveryAdress, state: true)
            textfieldState(textField: deliveryTime, state: true)
            
        } else {
            
            textfieldState(textField: deliveryAdress, state: false)
            textfieldState(textField: deliveryTime, state: false)
            
        }
    }
    
    
    @IBAction func dismissOrder(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
  
  
  var messageFrame = UIView()
  var activityIndicator = UIActivityIndicatorView()
  var strLabel = UILabel()
  
  func progressBarDisplayer(msg:String, _ indicator:Bool ) {
    print(msg)
    strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
    strLabel.text = msg
    strLabel.font = UIFont.systemFont(ofSize: 13)
    strLabel.textColor = UIColor.white
    messageFrame = UIView(frame: CGRect(x: (screenSize.width - strLabel.frame.width)/2 ,
                                        y: (screenSize.height - strLabel.frame.height)/2  , width: 180, height: 50))
    messageFrame.layer.cornerRadius = 15
    messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
    if indicator {
      activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
      activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
      activityIndicator.startAnimating()
      messageFrame.addSubview(activityIndicator)
    }
    messageFrame.addSubview(strLabel)
    view.addSubview(messageFrame)
  }

    
    @IBAction func checkOutButtonClicked(_ sender: Any) {
        print("checkOutButton clicked")
       progressBarDisplayer(msg: "Отправка заказа...", true)
       view.isUserInteractionEnabled = false
      
      let date = Date()
      let calendar = Calendar.current
      
     // let hour = calendar.component(.hour, from: date)
      //let minutes = calendar.component(.minute, from: date)
      //let seconds = calendar.component(.second, from: date)
      //let nanoSeconds = calendar.component(.nanosecond, from: date)
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
      
      
      //order info ==============
      var orderInfoBlock: FIRDatabaseReference!
     // let uuid = UUID().uuidString
     // print(uuid)
      
   
/*let ref = FIRDatabase.database().reference().child("orders")
 
 //print("Starting observing");
 ref.observe(.value, with: { (snapshot: FIRDataSnapshot!) in
// print("Got snapshot");
 print(snapshot.childrenCount)
 ordersCount.count = snapshot.childrenCount
 })
 
 print("Returning count");
 return rooms.count*/
      
      orderInfoBlock =
      FIRDatabase.database().reference().child("orders").child("Заказ № \(ordersCount + 1)")
     
      
      let orderInfoLabel = "orderInfo"
      
      let orderInfoContent: NSDictionary = [
                                "orderStatus": "Новый заказ",
                                "dateOfPlacement": ("\(day) \(monthString) \(year)"),
                                "fullPrice": totalprice,
                                "fullNDSPrice": totalNDSprice,
                                "comments": commentsTV.text!,
                                "layout": "тут будет инфа про макет",
                                "deliveryAdress": deliveryAdress.text!]
      
      
          let orderInfo = orderInfoBlock.child(orderInfoLabel) 
      
             orderInfo.setValue(orderInfoContent)
      
      
              //user info to order info
                  let userInfoToOrderInfoLabel = "userInfo"
      
                  let userInfoToOrderInfoContent: NSDictionary = [ "userEmail": emailTF.text!,
                                                                   "userName": nameSurnameTF.text!,
                                                                   "userPhone": phoneTF.text!,
                                                                   "userUniqueID": FIRAuth.auth()?.currentUser?.uid as Any ]
      
                let userInfoToOrderInfo = orderInfoBlock.child(userInfoToOrderInfoLabel)
      
                    userInfoToOrderInfo.setValue(userInfoToOrderInfoContent)
      
      
      //workss===
    let worksID = "works"
    orderInfoBlock.child(worksID)
      
      for i in(0..<addedItems.count) {
        
        let exactOrderID = "work\(i)"
        let works = addedItems[i]
        
        let contentOfWork: NSDictionary = ["mainData": works.list!,
                                           "price": works.price!,
                                           "ndsprice": works.ndsPrice!]
      
        
        let exactOrder = orderInfoBlock.child("works").child(exactOrderID)
        
        exactOrder.setValue(contentOfWork)
      }
      
      
      
      
      DispatchQueue.main.async {
        self.messageFrame.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
      }
      self.dismiss(animated: true, completion: nil)
    }
  
  
    @IBAction func nameSurnameEditingChanged(_ sender: Any) { validateRegistraionData() }
    @IBAction func phoneNumberEditingChanged(_ sender: Any) { validateRegistraionData() }
    @IBAction func emailEditingChanged(_ sender: Any) { validateRegistraionData() }

  
  fileprivate func localyRetrieveUserData () {
     if FIRAuth.auth()?.currentUser != nil && FIRAuth.auth()?.currentUser?.isEmailVerified == true {
    var ref: FIRDatabaseReference!
    ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
    
    ref.observeSingleEvent(of: .value, with: { snapshot in
      
      if !snapshot.exists() { return }
      
      let mainUserData = snapshot.value as? NSDictionary
      
      if let userNameSurname = mainUserData?["nameSurname"] as? String  {
        self.nameSurnameTF.text = userNameSurname
     
      }
      
      
      if let userPhoneNumber = mainUserData?["PhoneNumber"] as? String  {
        self.phoneTF.text = userPhoneNumber
      }
      
       self.emailTF.text = FIRAuth.auth()!.currentUser!.email!
      
    })
    
     
     } else {
       nameSurnameTF.text = ""
       phoneTF.text = ""
       emailTF.text = ""
    }
  }
  
  
    func setFontsForControllers(textfield: [UITextField], textview: UITextView, label: UILabel ) {
         if screenSize.height < 667 {
            textview.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            label.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            
            for textField in textfield {
                textField.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            }
        }
    }
    
    
    
    func textfieldState(textField: UITextField, state: Bool ) {
        
        if state == true {
            
             textField.isEnabled = true
            
             UIView.animate(withDuration: 0.3, animations: {
                textField.alpha = 0.9 })
            
        } else {
            
              textField.isEnabled = false
              textField.text = ""
            
              UIView.animate(withDuration: 0.3, animations: {
                textField.alpha = 0.5 })

        }
   
    }
    
    
    func validateRegistraionData () {
        let characterSetEmail = NSCharacterSet(charactersIn: "@")
        let characterSetEmail1 = NSCharacterSet(charactersIn: ".")
        let badCharacterSetEmail = NSCharacterSet(charactersIn: "!`~,/?|'\'';:#^&*=")
        let badCharacterSetPhoneNumber = NSCharacterSet(charactersIn: "@$%.><!`~,/?|'\'';:#^&*=_+{}[]")
        
        
        
        if (nameSurnameTF.text?.characters.count)! < 2 ||
            (phoneTF.text?.characters.count)! < 10 ||
            (phoneTF.text?.characters.count)! > 20 ||
            phoneTF.text?.rangeOfCharacter(from: badCharacterSetPhoneNumber as CharacterSet, options: .caseInsensitive ) != nil ||
            (emailTF.text?.characters.count)! < 5 ||
            emailTF.text?.rangeOfCharacter(from: characterSetEmail as CharacterSet, options: .caseInsensitive ) == nil ||
            emailTF.text?.rangeOfCharacter(from: characterSetEmail1 as CharacterSet, options: .caseInsensitive ) == nil ||
            emailTF.text?.rangeOfCharacter(from: badCharacterSetEmail as CharacterSet, options: .caseInsensitive ) != nil  {
            
            checkOutButton.isEnabled = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.checkOutButton.alpha = 0.6 })
            
        } else {
            checkOutButton.isEnabled = true
            
            UIView.animate(withDuration: 0.5, animations: {
                self.checkOutButton.alpha = 1.0 })
        }
    }
    

}

func localyRetrieveUserData () {
  
  var ref: FIRDatabaseReference!
  ref = FIRDatabase.database().reference().child("orders")//..child((FIRAuth.auth()?.currentUser?.uid)!)
  
  
  let name = "order1"
  //var data: NSData = NSData()
  
  //let base64String = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
  
  let user: NSDictionary = ["order1": name]
  
  
 
  
  
  //add firebase child node
  let profile = ref.child(name) //child(byAppendingPath: name)
  
  // Write data to Firebase
  profile.setValue(user)
  
  
  //=========
  
  
   ref = FIRDatabase.database().reference().child("orders").child("order1")
  
  let exactOrderID = "work1"
  
  let contentOfWork: NSDictionary = ["amount": "11", "material": "citylight", "size": "100x100", "postPrint": "without", "price": "1000", "ndsprice": "1200"]
  let exactOrder = ref.child(exactOrderID)//child(byAppendingPath: exactOrderID)
   exactOrder.setValue(contentOfWork)
  
  
  
}


 extension checkoutFormVC: UIScrollViewDelegate {
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isEqual(mainScrollView) else {
            return
        }
        
        if let delegate = transitioningDelegate as? DeckTransitioningDelegate {
            if scrollView.contentOffset.y > 0 {
                // Normal behaviour if the `scrollView` isn't scrolled to the top
                scrollView.bounces = true
                delegate.isDismissEnabled = false
            } else {
                if scrollView.isDecelerating {
                    // If the `scrollView` is scrolled to the top but is decelerating
                    // that means a swipe has been performed. The view and scrollview are
                    // both translated in response to this.
                    view.transform = CGAffineTransform(translationX: 0, y: -scrollView.contentOffset.y)
                    scrollView.transform = CGAffineTransform(translationX: 0, y: scrollView.contentOffset.y)
                } else {
                    // If the user has panned to the top, the scrollview doesnʼt bounce and
                    // the dismiss gesture is enabled.
                    scrollView.bounces = false
                    delegate.isDismissEnabled = true
                }
            }
        }
    }
}


 extension checkoutFormVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}




