//
//  ViewController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/3/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.


import UIKit
import CoreData
import avalonExtBridge
import JTMaterialTransition



var rightBarButton: ENMBadgedBarButtonItem?
var leftBarButton: ENMBadgedBarButtonItem?
let screenSize: CGRect = UIScreen.main.bounds

func updateBadgeValue () {
    managedObjextContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    do {
        addedItems = try managedObjextContext.fetch(presentRequest)
    } catch {
        print(error)
    }
  rightBarButton?.badgeValue = "\(addedItems.count)"
}


func applyMotionEffect (toView view: UIView, magnitude: Float ) {
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



class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet var mainView: UIView!
    let button = UIButton(type: .custom)
    
    let postersPageButton = PageStartButton()
    let bannersPageButton = PageStartButton()
    let stickersPageButton = PageStartButton()
    let canvasPageButton = PageStartButton()
    let contactsPageButton = PageStartButton()
    let informationPageButton = PageStartButton()
    
    var bucketTransition = JTMaterialTransition()
    var profileButtonTransition = JTMaterialTransition()
    
    let profileButton = UIButton(type: .custom)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         applyMotionEffect(toView: backgroundImageView, magnitude: 25)
        
         self.bucketTransition = JTMaterialTransition(animatedView: self.button)
         self.profileButtonTransition = JTMaterialTransition(animatedView: self.profileButton)
        
        getVariablesFromJSON()
        setUpRightBarButton()
        setUpLeftBarButton()
        updateBadgeValue()
        
        
    
        let postersIMG = UIImage(named: "bannersmain") as UIImage?
        let bannersIMG = UIImage(named: "banermain") as UIImage?
        let stickersIMG = UIImage(named: "stickersmain") as UIImage?
        let canvasIMG = UIImage(named: "canvasmain") as UIImage?
        let contactsIMG = UIImage(named: "emailmain") as UIImage?
        let infoIMG = UIImage(named: "infomain") as UIImage?
        
        
        postersPageButton.frame = CGRect(x: (screenSize.width/15), y: screenSize.height/20, width: screenSize.width/2.5 , height: screenSize.width/2.5 )
        postersPageButton.setBackgroundImage(postersIMG, for: UIControlState.normal)
        postersPageButton.setTitle("Плакаты", for: .normal)
        postersPageButton.addTarget(self, action: #selector(openPostersPage), for: .touchUpInside)
        
        
        
        bannersPageButton.frame = CGRect(x: (screenSize.width/1.9), y: screenSize.height/20, width: screenSize.width/2.5, height: screenSize.width/2.5 )
        bannersPageButton.setBackgroundImage(bannersIMG, for: UIControlState.normal)
        bannersPageButton.setTitle("Баннеры", for: .normal)
        bannersPageButton.addTarget(self, action: #selector(openBannersPage), for: .touchUpInside)
        
        
        stickersPageButton.frame =  CGRect(x: (screenSize.width/15), y: screenSize.height/3.05, width: screenSize.width/2.5, height: screenSize.width/2.5)
        stickersPageButton.setBackgroundImage(stickersIMG, for: UIControlState.normal)
        stickersPageButton.setTitle("Наклейки", for: .normal)
        stickersPageButton.addTarget(self, action: #selector(openStickersPage), for: .touchUpInside)
        
    
        canvasPageButton.frame =  CGRect(x: (screenSize.width/1.9), y: screenSize.height/3.05, width: screenSize.width/2.5, height: screenSize.width/2.5)
        canvasPageButton.setBackgroundImage(canvasIMG, for: UIControlState.normal)
        canvasPageButton.setTitle("Холсты", for: .normal)
        canvasPageButton.addTarget(self, action: #selector(openCanvasPage), for: .touchUpInside)
        
        
        contactsPageButton.frame = CGRect(x: (screenSize.width/15), y: screenSize.height/1.65, width: screenSize.width/2.5, height: screenSize.width/2.5)
        contactsPageButton.setBackgroundImage(contactsIMG, for: UIControlState.normal)
        contactsPageButton.setTitle("Контакты", for: .normal)
        contactsPageButton.addTarget(self, action: #selector(openContactsPage), for: .touchUpInside)
        
        
        informationPageButton.frame =  CGRect(x: (screenSize.width/1.9), y: screenSize.height/1.65, width: screenSize.width/2.5, height: screenSize.width/2.5)
        informationPageButton.setBackgroundImage(infoIMG, for: UIControlState.normal)
        informationPageButton.setTitle("Информация", for: .normal)
        informationPageButton.addTarget(self, action: #selector(openInformationPage), for: .touchUpInside)
        
        self.view.addSubview(postersPageButton)
        self.view.addSubview(bannersPageButton)
        self.view.addSubview(stickersPageButton)
        self.view.addSubview(canvasPageButton)
        self.view.addSubview(contactsPageButton)
        self.view.addSubview(informationPageButton)
    }
    
      
    func setUpRightBarButton() {
        let image = UIImage(named: "shoppingCart")
        
        if let knownImage = image {
            button.frame = CGRect(x: 0.0, y: 0.0, width: knownImage.size.width, height: knownImage.size.height)
        } else {
            button.frame = CGRect.zero
        }
        
        button.setBackgroundImage(image, for: UIControlState())
        button.addTarget(self, action: #selector(ViewController.rightButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        
        let newBarButton = ENMBadgedBarButtonItem(customView: button, value: "0")
        rightBarButton = newBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func rightButtonPressed(_ sender: UIButton) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "shoppingCartVC") as! shoppingCartVC
            controller.modalPresentationStyle = .custom
            controller.transitioningDelegate = self.bucketTransition
        
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func setUpLeftBarButton() {
        let image = UIImage(named: "accountv2")
        
        if let knownImage = image {
            profileButton.frame = CGRect(x: 0.0, y: 0.0, width: knownImage.size.width, height: knownImage.size.height)
        } else {
            profileButton.frame = CGRect.zero;
        }
        
        profileButton.setBackgroundImage(image, for: UIControlState())
        profileButton.tintColor = UIColor.white
    
        profileButton.addTarget(self, action: #selector(ViewController.leftButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        
        let newBarButton = ENMBadgedBarButtonItem(customView: profileButton, value: "0")
        leftBarButton = newBarButton
        navigationItem.leftBarButtonItem = leftBarButton
    }

   
    
    func leftButtonPressed(_ sender: UIButton) {
        
        if (defaults.object(forKey: "loggedIn") as? Bool) == true {
            let controller =  storyboard?.instantiateViewController(withIdentifier: "UserProfile")// as! UserProfile
            controller?.modalPresentationStyle = .custom
            controller?.transitioningDelegate = self.profileButtonTransition
            self.present(controller!, animated: true, completion: nil)
        
            
        } else  {
            let controller =  storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            //as! LoginViewController
            controller?.modalPresentationStyle = .custom
            controller?.transitioningDelegate = self.profileButtonTransition
            self.present(controller!, animated: true, completion: nil)
        }
    }

    
    func openPostersPage(sender: UIButton!) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "postersVC") as! postersVC
                navigationController?.pushViewController(destination, animated: true)
        
        //UNCHECKING CHECKED VALUES. IN POSTERS COMPUTING (postersComputing.swift)
          reset(page: "posters")
    }
    

    func openBannersPage(sender: UIButton!) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "bannersVC") as! bannersVC
        navigationController?.pushViewController(destination, animated: true)
    }
    
    
    func openStickersPage(sender: UIButton!) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "stickersVC") as! stickersVC
        navigationController?.pushViewController(destination, animated: true)
        
        //UNCHECKING CHECKED VALUES. IN POSTERS COMPUTING (postersComputing.swift)
         reset(page: "stickers")
       
    }
    
    
    func openCanvasPage(sender: UIButton!) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "canvasVC") as! canvasVC
        navigationController?.pushViewController(destination, animated: true)
        
        //UNCHECKING CHECKED VALUES. IN POSTERS COMPUTING (canvasComputing.swift)
        reset(page: "canvas")
    }
    
    
    func openContactsPage(sender: UIButton!) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "ContactsPageController") as! ContactsPageController
        navigationController?.pushViewController(destination, animated: true)

    }
    
    func openInformationPage(sender: UIButton!) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "InformationPageController") as! InformationPageController
        navigationController?.pushViewController(destination, animated: true)

    }
 
}

