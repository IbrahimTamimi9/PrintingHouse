//
//  HomeVC.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/3/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.


import UIKit
import CoreData
import JTMaterialTransition
import FirebaseAuth
import FirebaseDatabase
import SystemConfiguration

var rightBarButton: ENMBadgedBarButtonItem?
var leftBarButton: ENMBadgedBarButtonItem?
let screenSize: CGRect = UIScreen.main.bounds



func lout() {
  
  let firebaseAuth = FIRAuth.auth()
  do {
    try firebaseAuth?.signOut()
   // dismiss(animated: true, completion: nil)
  } catch let signOutError as NSError {
    print ("Error signing out: %@", signOutError)
  }
  
}

 public func updateBadgeValue () {
     managedObjextContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
     do {
         addedItems = try managedObjextContext.fetch(presentRequest)
     } catch {
         print(error)
     }
   rightBarButton?.badgeValue = "\(addedItems.count)"
 }


 public func applyMotionEffect (toView view: UIView, magnitude: Float ) {
     let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
     xMotion.minimumRelativeValue = -magnitude
     xMotion.maximumRelativeValue = magnitude
    
     let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
     yMotion.minimumRelativeValue = -magnitude
     yMotion.maximumRelativeValue = magnitude
    
     let group = UIMotionEffectGroup()
     group.motionEffects = [xMotion, yMotion]
     view.addMotionEffect(group)
 }



protocol Utilities {
  
}

extension NSObject: Utilities{
  
  enum ReachabilityStatus {
    case notReachable
    case reachableViaWWAN
    case reachableViaWiFi
  }
  
  
  var currentReachabilityStatus: ReachabilityStatus {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        SCNetworkReachabilityCreateWithAddress(nil, $0)
      }
    }) else {
      return .notReachable
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
      return .notReachable
    }
    
    if flags.contains(.reachable) == false {
      // The target host is not reachable.
      return .notReachable
    }
    else if flags.contains(.isWWAN) == true {
      // WWAN connections are OK if the calling application is using the CFNetwork APIs.
      return .reachableViaWWAN
    }
    else if flags.contains(.connectionRequired) == false {
      // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
      return .reachableViaWiFi
    }
    else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
      // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
      return .reachableViaWiFi
    }
    else {
      return .notReachable
    }
  }
  
}

 class HomeVC: UIViewController {
  
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
  
    let button = UIButton(type: .custom)
  
    var bucketTransition = JTMaterialTransition()
  
    var profileButtonTransition = JTMaterialTransition()
    
    let profileButton = UIButton(type: .custom)
  
    typealias ItemInfo = (imageName: String, title: String)
  
    var items: [ItemInfo] = [("bannersmain", "Плакаты"),("banermain", "Баннеры"),("stickersmain", "Наклейки"), ("canvasmain", "Холсты"), ("emailmain", "Контакты"),("infomain", "Информация")]
  
    var startCollectionView: UICollectionView!

 
    override func viewDidLoad() {
        super.viewDidLoad()

        checkInternetConnection()
  
        bucketTransition = JTMaterialTransition(animatedView: button)
        profileButtonTransition = JTMaterialTransition(animatedView: profileButton)
      
        applyMotionEffect(toView: backgroundImageView, magnitude: 25)
      
        setUpRightBarButton()
        setUpLeftBarButton()
        updateBadgeValue()
        registerCell()
        getVariablesFromJSON()
      
     // lout()
  }
  
  
  func checkInternetConnection () {
    
    if  currentReachabilityStatus != .notReachable {
      //true connected
    
    } else {
      //no internet
      let alertController = UIAlertController(title: "Ошибка подключения к интернету", message: "Для совершения покупок, пожалуйста, подключитесь к интернету.", preferredStyle: .alert)
      
      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      
      alertController.addAction(defaultAction)
      
      self.present(alertController, animated: true, completion: nil)

      
    }
    
  }

  
   fileprivate func registerCell() {
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let edgeInsets = screenSize.width/18
    let cornerInsets = screenSize.width/15
    
    layout.sectionInset = UIEdgeInsets(top: edgeInsets, left: cornerInsets, bottom: 10, right: cornerInsets)
    layout.itemSize = CGSize(width: screenSize.width/2.5, height: screenSize.width/2.1)
    
    startCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    startCollectionView.dataSource = self
    startCollectionView.delegate = self
    startCollectionView.backgroundColor = UIColor.clear
    
    let nib = UINib(nibName: String(describing: HomeVCCell.self), bundle: nil)
        startCollectionView?.register(nib, forCellWithReuseIdentifier: String(describing: HomeVCCell.self))
        self.view.addSubview(startCollectionView)
  }
  
  
  
   fileprivate func setUpRightBarButton() {
        let image = UIImage(named: "shoppingCart")
        
        if let knownImage = image {
            button.frame = CGRect(x: 0.0, y: 0.0, width: knownImage.size.width, height: knownImage.size.height)
        } else {
            button.frame = CGRect.zero
        }
        
        button.setBackgroundImage(image, for: UIControlState())
        button.addTarget(self, action: #selector(HomeVC.rightButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        
        let newBarButton = ENMBadgedBarButtonItem(customView: button, value: "0")
        rightBarButton = newBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func rightButtonPressed(_ sender: UIButton) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "ShoppingCartVC") as! ShoppingCartVC
            controller.modalPresentationStyle = .custom
            controller.transitioningDelegate = self.bucketTransition
        
        self.present(controller, animated: true, completion: nil)
       }
  
    
  fileprivate  func setUpLeftBarButton() {
        let image = UIImage(named: "accountv2")
        
        if let knownImage = image {
            profileButton.frame = CGRect(x: 0.0, y: 0.0, width: knownImage.size.width, height: knownImage.size.height)
        } else {
            profileButton.frame = CGRect.zero;
        }
        
        profileButton.setBackgroundImage(image, for: UIControlState())
        profileButton.tintColor = UIColor.white
    
        profileButton.addTarget(self, action: #selector(HomeVC.leftButtonPressed(_:)), for: UIControlEvents.touchUpInside)
    
        let newBarButton = ENMBadgedBarButtonItem(customView: profileButton, value: "0")
            leftBarButton = newBarButton
            navigationItem.leftBarButtonItem = leftBarButton
    }

   
    
     func leftButtonPressed(_ sender: UIButton) {
     
      FIRAuth.auth()?.addStateDidChangeListener { auth, user in
        if FIRAuth.auth()?.currentUser != nil && FIRAuth.auth()?.currentUser?.isEmailVerified == true {
          // User is signed in.
          
          let controller =  self.storyboard?.instantiateViewController(withIdentifier: "UserProfile")
          controller?.modalPresentationStyle = .custom
          controller?.transitioningDelegate = self.profileButtonTransition
          
          self.present(controller!, animated: true, completion: nil)
        
        } else {
          
          // No user is signed in.
          let controller =  self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
          controller?.modalPresentationStyle = .custom
          controller?.transitioningDelegate = self.profileButtonTransition
          self.present(controller!, animated: true, completion: nil)
        }
      }
    }
  }


extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
       let cell = collectionView.cellForItem(at: indexPath)
  
    UIView.animate(withDuration: 0.1, animations: {
      cell?.alpha = 0.6})
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath)

    UIView.animate(withDuration: 0.3, animations: {
      cell?.alpha = 1})
  }
  

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
 
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomeVCCell.self), for: indexPath)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
    guard let cell = cell as? HomeVCCell else { return }
    let index = (indexPath as NSIndexPath).row % items.count
    let info = items[index]
    cell.startImage.image = UIImage(named: info.imageName)
    cell.startLabel.text = info.title
  
  }


  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
    
    currentPageData.resetDataBeforeChangingPage()
    
       if indexPath.row == 0 {
              let destination = storyboard?.instantiateViewController(withIdentifier: "PostersVC") as! PostersVC
                      navigationController?.pushViewController(destination, animated: true)
      
    }
  
    if indexPath.row == 1 {
              let destination = storyboard?.instantiateViewController(withIdentifier: "BannersVC") as! BannersVC
                  navigationController?.pushViewController(destination, animated: true)
      
             //UNCHECKING CHECKED VALUES. IN POSTERS COMPUTING (postersComputing.swift)
               reset(page: "banners")
      
    }
    if indexPath.row == 2 {
      let destination = storyboard?.instantiateViewController(withIdentifier: "StickersVC") as! StickersVC
          navigationController?.pushViewController(destination, animated: true)
      
              //UNCHECKING CHECKED VALUES. IN POSTERS COMPUTING (postersComputing.swift)
              //  reset(page: "stickers")
       //currentPageData.resetDataBeforeChangingPage()
    }
    if indexPath.row == 3 {
      let destination = storyboard?.instantiateViewController(withIdentifier: "CanvasVC") as! CanvasVC
          navigationController?.pushViewController(destination, animated: true)
      
              //UNCHECKING CHECKED VALUES. IN POSTERS COMPUTING (canvasComputing.swift)
                reset(page: "canvas")
    }
    if indexPath.row == 4 {
      let destination = storyboard?.instantiateViewController(withIdentifier: "ContactsPageController") as! ContactsPageController
          navigationController?.pushViewController(destination, animated: true)
    }
    if indexPath.row == 5 {
      let destination = storyboard?.instantiateViewController(withIdentifier: "InformationPageController") as! InformationPageController
          navigationController?.pushViewController(destination, animated: true)
    }
    
  }

}
