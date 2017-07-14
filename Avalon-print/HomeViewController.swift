//
//  HomeViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/21/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import CoreData
import JTMaterialTransition
import FirebaseAuth
import FirebaseDatabase
import SystemConfiguration

var rightBarButton: ENMBadgedBarButtonItem?
var leftBarButton: ENMBadgedBarButtonItem?
let screenSize: CGRect = UIScreen.main.bounds
let statusBarSize = UIApplication.shared.statusBarFrame.size



protocol Utilities {
  
}

extension NSObject: Utilities {
  
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





class HomeViewController: UIViewController {
  
  let shoppingCartButton = UIButton(type: .custom)
  
  let profileButton = UIButton(type: .custom)
  
  var shoppingCartTransition = JTMaterialTransition()
  
  var profileTransition = JTMaterialTransition()
  
  
  
  typealias ItemInfo = (imageName: String, title: String)
  
  var items: [ItemInfo] = [("Posters", NSLocalizedString("HomeViewController.items.posters", comment: "")),
                           ("Banners", NSLocalizedString("HomeViewController.items.banners", comment: "")),
                           ("Stickers", NSLocalizedString("HomeViewController.items.stickers", comment: "")),
                           ("Canvas", NSLocalizedString("HomeViewController.items.canvas", comment: "")),
                           ("Contacts", NSLocalizedString("HomeViewController.items.contacts", comment: "")),
                           ("Information", NSLocalizedString("HomeViewController.items.information", comment: ""))]
  
  var startCollectionView: UICollectionView!


    override func viewDidLoad() {
        super.viewDidLoad()
      self.title =  NSLocalizedString("HomeViewController.NavigationItem.title", comment: "")
   
      
      let backButton = UIBarButtonItem(title: "", style:.plain, target: nil, action: nil)
      navigationItem.backBarButtonItem = backButton
     
      setUpRightBarButton()
      
      setUpLeftBarButton()
      
      registerCell()
      
      DispatchQueue.main.async {
        
        updateBadgeValue()
        
        self.checkInternetConnection()
        
        fetchGeneralDataForCalculations()
      }
      
       self.shoppingCartTransition = JTMaterialTransition(animatedView: self.shoppingCartButton)
       self.profileTransition = JTMaterialTransition(animatedView: self.profileButton)

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

}


extension HomeViewController { /* setting up bar buttons */
  
  fileprivate func setUpRightBarButton() {
    let image = UIImage(named: "ShoppingCart")
    
    if let knownImage = image {
      shoppingCartButton.frame = CGRect(x: 0.0, y: 0.0, width: knownImage.size.width, height: knownImage.size.height)
    } else {
      shoppingCartButton.frame = CGRect.zero
    }
    
    shoppingCartButton.setBackgroundImage(image, for: UIControlState())
    shoppingCartButton.addTarget(self, action: #selector(HomeViewController.rightButtonPressed(_:)), for: UIControlEvents.touchUpInside)
    
    let newBarButton = ENMBadgedBarButtonItem(customView: shoppingCartButton, value: "0")
    rightBarButton = newBarButton
    navigationItem.rightBarButtonItem = rightBarButton
  }
  
  
  fileprivate  func setUpLeftBarButton() {
    let image = UIImage(named: "Profile")
    
    if let knownImage = image {
      profileButton.frame = CGRect(x: 0.0, y: 0.0, width: knownImage.size.width, height: knownImage.size.height)
    } else {
      profileButton.frame = CGRect.zero;
    }
    
    profileButton.setBackgroundImage(image, for: UIControlState())
    profileButton.tintColor = UIColor.white
    
    profileButton.addTarget(self, action: #selector(HomeViewController.leftButtonPressed(_:)), for: UIControlEvents.touchUpInside)
    
    let newBarButton = ENMBadgedBarButtonItem(customView: profileButton, value: "0")
    leftBarButton = newBarButton
    navigationItem.leftBarButtonItem = leftBarButton
  }

  
  
  func rightButtonPressed(_ sender: UIButton) {
    
    let refactoredController = ShoppingCartVC()
    let navigationController = MainNavigationController(rootViewController: refactoredController)
    navigationController.modalPresentationStyle = .custom
    navigationController.transitioningDelegate = self.shoppingCartTransition
    self.present(navigationController, animated: true, completion: nil)
    
  }
  
  
  func leftButtonPressed(_ sender: UIButton) {
    
    Auth.auth().addStateDidChangeListener { auth, user in
      if Auth.auth().currentUser != nil && Auth.auth().currentUser?.isEmailVerified == true {
        
        // User is signed in.
        let refactoredController = UserProfileViewController()
        let navigationController = MainNavigationController(rootViewController: refactoredController)
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = self.profileTransition
        self.present(navigationController, animated: true, completion: nil)
        
      } else {
        
        // No user is signed in.
        let refactoredController = LoginViewController()
        let navigationController = MainNavigationController(rootViewController: refactoredController)
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = self.profileTransition
        
        self.present(navigationController, animated: true, completion: nil)
      }
    }
  }
  
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  fileprivate func registerCell() {
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let edgeInsets = screenSize.width/18
    let cornerInsets = screenSize.width/15
    
    layout.sectionInset = UIEdgeInsets(top: edgeInsets, left: cornerInsets, bottom: 10, right: cornerInsets)
    layout.itemSize = CGSize(width: screenSize.width/2.5, height: screenSize.width/2.1)
    
    startCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    startCollectionView.dataSource = self
    startCollectionView.delegate = self
    
    startCollectionView.backgroundColor = UIColor.white
    startCollectionView.isOpaque = true
    
    let nib = UINib(nibName: String(describing: HomeViewControllerCell.self), bundle: nil)
    startCollectionView?.register(nib, forCellWithReuseIdentifier: String(describing: HomeViewControllerCell.self))
    self.view.addSubview(startCollectionView)
  }

  
  
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
    
    return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomeViewControllerCell.self), for: indexPath)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
    guard let cell = cell as? HomeViewControllerCell else { return }
    
    let index = (indexPath as NSIndexPath).row % items.count
    
    let info = items[index]
    
    //cell.backgroundColor = UIColor.white
    cell.startImage.image = UIImage(named: info.imageName)
    cell.startLabel.text = info.title
 
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    currentPageData.resetDataBeforeChangingPage()
    
    if indexPath.row == 0 {
      let destination = PostersViewController()// UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostersVC") as! PostersVC   
      navigationController?.pushViewController(destination, animated: true)
    }
    
    
    if indexPath.row == 1 {
      let destination = BannersViewController()//UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BannersVC") as! BannersVC//storyboard?.instantiateViewController(withIdentifier: "BannersVC") as! BannersVC
      navigationController?.pushViewController(destination, animated: true)
      //UNCHECKING CHECKED VALUES. IN POSTERS COMPUTING (postersComputing.swift)
    // reset(page: "banners")
    }
    
    
    if indexPath.row == 2 {
      let destination = StickersViewController()//UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StickersVC") as! StickersVC//storyboard?.instantiateViewController(withIdentifier: "StickersVC") as! StickersVC
      navigationController?.pushViewController(destination, animated: true)
    }
    
    
    if indexPath.row == 3 {
      let destination = CanvasViewController()//UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CanvasVC") as! CanvasVC//storyboard?.instantiateViewController(withIdentifier: "CanvasVC") as! CanvasVC
      navigationController?.pushViewController(destination, animated: true)
    }
    
    
    if indexPath.row == 4 {
      let destination = ContactsTableViewController()// UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactsPageController") as! ContactsPageController//storyboard?.instantiateViewController(withIdentifier: "ContactsPageController") as! ContactsPageController
      navigationController?.pushViewController(destination, animated: true)
    }
    
    
    if indexPath.row == 5 {
      let destination = InformationTableViewController()//UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InformationPageController") as! InformationPageController//storyboard?.instantiateViewController(withIdentifier: "InformationPageController") as! InformationPageController
      navigationController?.pushViewController(destination, animated: true)
    }
    
    
  }
  
}





