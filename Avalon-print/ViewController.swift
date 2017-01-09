//
//  ViewController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/3/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.


import UIKit

//let closeProgram = UIAlertController(title: "Нет подключения к интернету", message: "Пожалуйта, для использования программы подключитесь к интернету", preferredStyle: UIAlertControllerStyle.alert)
//let close = UIAlertAction(title: "Закрыть", style: UIAlertActionStyle.destructive ) {
//    UIAlertAction in
//    exit(0)
//}hjk

var rightBarButton: ENMBadgedBarButtonItem?

 let bucketDefaults = UserDefaults.standard


class ViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "ChevronLeft")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ChevronLeft")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : (UIFont(name: "Exo2-Light", size: 17))!, NSForegroundColorAttributeName: UIColor.white]
       
        

        getVariablesFromJSON()
        setUpRightBarButton()
        
        var savedList = bucketDefaults.stringArray(forKey: "ListStringArray") ?? [String]()
        var savedPrice = bucketDefaults.stringArray(forKey: "PriceStringArray") ?? [String]()
        var savedNDSPrice = bucketDefaults.stringArray(forKey: "NdsPriceStringArray") ?? [String]()

        list = savedList
        price = savedPrice
        ndsPrice = savedNDSPrice
        rightBarButton?.badgeValue = "\(price.count)"
        
        if (list.count == 0 || savedList.count == 0 || price.count == 0 || savedPrice.count == 0 || ndsPrice.count == 0 || savedNDSPrice.count == 0)  {
            
            list.removeAll()
            savedList.removeAll()
            price.removeAll()
            savedPrice.removeAll()
            ndsPrice.removeAll()
            savedNDSPrice.removeAll()
            
        }
       
        
        
        let postersIMG = UIImage(named: "bannersmain") as UIImage?
        let bannersIMG = UIImage(named: "banermain") as UIImage?
        let stickersIMG = UIImage(named: "stickersmain") as UIImage?
        let canvasIMG = UIImage(named: "canvasmain") as UIImage?
        let contactsIMG = UIImage(named: "emailmain") as UIImage?
        let infoIMG = UIImage(named: "infomain") as UIImage?
        
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let postersPageButton = PageStartButton(frame: CGRect(x: (screenSize.width/15), y: screenSize.height/20, width: screenSize.width/2.5 , height: screenSize.width/2.5 ))

        postersPageButton.setBackgroundImage(postersIMG, for: UIControlState.normal)
        postersPageButton.setTitle("Плакаты", for: .normal)
        postersPageButton.addTarget(self, action: #selector(openPostersPage), for: .touchUpInside)
        
        
        let bannersPageButton = PageStartButton(frame: CGRect(x: (screenSize.width/1.9), y: screenSize.height/20, width: screenSize.width/2.5, height: screenSize.width/2.5 ))
        
        bannersPageButton.setBackgroundImage(bannersIMG, for: UIControlState.normal)
        bannersPageButton.setTitle("Баннеры", for: .normal)
        bannersPageButton.addTarget(self, action: #selector(openBannersPage), for: .touchUpInside)
        
        
        let stickersPageButton = PageStartButton(frame: CGRect(x: (screenSize.width/15), y: screenSize.height/3.05, width: screenSize.width/2.5, height: screenSize.width/2.5))
        
        stickersPageButton.setBackgroundImage(stickersIMG, for: UIControlState.normal)
        stickersPageButton.setTitle("Наклейки", for: .normal)
        stickersPageButton.addTarget(self, action: #selector(openStickersPage), for: .touchUpInside)
        
        
        let canvasPageButton = PageStartButton(frame: CGRect(x: (screenSize.width/1.9), y: screenSize.height/3.05, width: screenSize.width/2.5, height: screenSize.width/2.5))
        
        canvasPageButton.setBackgroundImage(canvasIMG, for: UIControlState.normal)
        canvasPageButton.setTitle("Холсты", for: .normal)
        canvasPageButton.addTarget(self, action: #selector(openCanvasPage), for: .touchUpInside)
        
        
        let contactsPageButton = PageStartButton(frame: CGRect(x: (screenSize.width/15), y: screenSize.height/1.65, width: screenSize.width/2.5, height: screenSize.width/2.5))
        
        contactsPageButton.setBackgroundImage(contactsIMG, for: UIControlState.normal)
        contactsPageButton.setTitle("Контакты", for: .normal)
        contactsPageButton.addTarget(self, action: #selector(openContactsPage), for: .touchUpInside)
        
        
        let informationPageButton = PageStartButton(frame: CGRect(x: (screenSize.width/1.9), y: screenSize.height/1.65, width: screenSize.width/2.5, height: screenSize.width/2.5))
      
        informationPageButton.setBackgroundImage(infoIMG, for: UIControlState.normal)
        informationPageButton.setTitle("Информация", for: .normal)
        informationPageButton.addTarget(self, action: #selector(openInformationPage), for: .touchUpInside)
        
        
        self.view.addSubview(postersPageButton)
        self.view.addSubview(bannersPageButton)
        self.view.addSubview(stickersPageButton)
        self.view.addSubview(canvasPageButton)
        self.view.addSubview(contactsPageButton)
        self.view.addSubview(informationPageButton)
        
//        if internet.enabled == false {
//            closeProgram.addAction(close)
//            self.present(closeProgram, animated: true, completion: nil)
//        } else {
//            print("internet works")
//        }
        
    }
    
    func setUpRightBarButton() {
        let image = UIImage(named: "shoppingCart")
        let button = UIButton(type: .custom)
        if let knownImage = image {
            button.frame = CGRect(x: 0.0, y: 0.0, width: knownImage.size.width, height: knownImage.size.height)
        } else {
            button.frame = CGRect.zero;
        }
        
        button.setBackgroundImage(image, for: UIControlState())
        button.addTarget(self,
                         action: #selector(ViewController.rightButtonPressed(_:)),
                         for: UIControlEvents.touchUpInside)
        
        let newBarButton = ENMBadgedBarButtonItem(customView: button, value: "0")
        rightBarButton = newBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func rightButtonPressed(_ sender: UIButton) {
               //rightBarButton?.badgeValue = "1"
        
        let destination = storyboard?.instantiateViewController(withIdentifier: "bucket") as! bucket
        let navigationController = UINavigationController(rootViewController: destination)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navigationController.isNavigationBarHidden = true
        self.present(navigationController, animated: true, completion: nil)

        
    }

    
    func openPostersPage(sender: UIButton!) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "postersVC") as! postersVC
                navigationController?.pushViewController(destination, animated: true)
            
       
        
                //MARK: UNCHECKING CHECKED VALUES. IN POSTERS COMPUTING (postersComputing.swift)
        
                  postersBoolVariables.amountDidNotInputed = true
                  postersBoolVariables.amount = ""
        
                  postersBoolVariables.materialDidnNotChosen = true
                  postersBoolVariables.cityC = false
                  postersBoolVariables.lomondC = false
                  postersBoolVariables.photoC = false
                  postersBoolVariables.postersWidhOrHeightDidNotInputed = true
                  postersBoolVariables.postersWidthSet = ""
                  postersBoolVariables.postersHeightSet = ""

        
                  postersBoolVariables.withoutPostPrint = true
                  postersBoolVariables.gloss1_0C = false
                  postersBoolVariables.matt1_0C = false
                  postersBoolVariables.gloss1_1C = false
                  postersBoolVariables.matt1_1C = false
        
                  postersBoolVariables.priceToLabel = "0"
                  postersBoolVariables.ndsPriceToLabel = "0"
        
                  

    }
    
    @IBAction func openLoginOrProfile(_ sender: Any) {
        
       
      
        
        if (defaults.object(forKey: "loggedIn") as? Bool) == true {
           // UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.slide)
//            let destination = storyboard?.instantiateViewController(withIdentifier: "UserProfile") as! UserProfile
//            navigationController?.present(destination, animated: true, completion: nil)
//            //navigationController?.pushViewController(destination, animated: true)
            
            
            let destination = storyboard?.instantiateViewController(withIdentifier: "UserProfile") as! UserProfile
            let navigationController = UINavigationController(rootViewController: destination)
            navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            navigationController.isNavigationBarHidden = true
            self.present(navigationController, animated: true, completion: nil)

            
            
        } else  {
            
            let destination = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navigationController = UINavigationController(rootViewController: destination)
            navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            navigationController.isNavigationBarHidden = true
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    
    func openBannersPage(sender: UIButton!) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "bannersVC") as! bannersVC
        navigationController?.pushViewController(destination, animated: true)
        
        
        
    }
    
    
    func openStickersPage(sender: UIButton!) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "stickersVC") as! stickersVC
        navigationController?.pushViewController(destination, animated: true)
        
        //MARK: UNCHECKING CHECKED VALUES. IN POSTERS COMPUTING (postersComputing.swift)
        
        stickersBoolVariables.amountDidNotInputed = true
        stickersBoolVariables.amount = ""
        
        stickersBoolVariables.materialDidnNotChosen = true
        stickersBoolVariables.whiteStickerC = false
        stickersBoolVariables.transparentStickerC = false
        stickersBoolVariables.oneWayVisionC = false
        stickersBoolVariables.stickersWidhOrHeightDidNotInputed = true
        stickersBoolVariables.stickersWidthSet = ""
        stickersBoolVariables.stickersHeightSet = ""
        
        
        stickersBoolVariables.withoutPostPrint = true
        stickersBoolVariables.coldLaminationC = false
        
        stickersBoolVariables.priceToLabel = "0"
        stickersBoolVariables.ndsPriceToLabel = "0"

        
        

    }
    
    
    func openCanvasPage(sender: UIButton!) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "canvasVC") as! canvasVC
        navigationController?.pushViewController(destination, animated: true)
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

