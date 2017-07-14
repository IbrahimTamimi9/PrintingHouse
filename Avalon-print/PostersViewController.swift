//
//  PostersViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/21/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import Firebase
import JTMaterialTransition
import FirebaseDatabase


class PostersViewController: UIViewController {
  
  let scrollView = UIScrollView(frame: UIScreen.main.bounds)
  
  var topBlock = PostersStickersCanvasTopBlockView()
  
  var layoutBlock = LayoutSelectionView()
  
  var priceBlock = PriceAndAddToCartView()

  var materialInfoTransition = JTMaterialTransition()
  
  var hidingNavigationBarManager: HidingNavigationBarManager?

    override func viewDidLoad() {
        super.viewDidLoad()
      
      view.backgroundColor = UIColor.white
      scrollView.backgroundColor = view.backgroundColor
      topBlock.title.text = postersTitle
      
      //  currentPageData.viewControllersTopBlock = topBlock
        currentPageData.viewControllersPriceBlock = priceBlock /* necessary!!!! for displaying calculated price */
        currentPageData.viewControllersLayoutBlock = layoutBlock
      
        self.scrollView.delegate = self
      
        view.addSubview(scrollView)
        scrollView.addSubview(topBlock)
        scrollView.addSubview(layoutBlock)
        scrollView.addSubview(priceBlock)
      
        fetchMaterialsAndPostprint(productType: "Posters", onlyColdLamAllowed: false, onlyDefaultPrepressAllowed: true)
      
        managedObjextContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.materialInfoTransition = JTMaterialTransition(animatedView: topBlock.materialsInfo)
        self.hideKeyboardWhenTappedAround()
      
        priceBlock.addToCart.addTarget(self, action: #selector(AddToCart(_:)), for: .touchUpInside)
        topBlock.materialsInfo.addTarget(self, action: #selector(materialsInfoTapped), for: .touchUpInside)
      
        setConstraints()
      
        hidingNavigationBarManager = HidingNavigationBarManager(viewController: self, scrollView: scrollView)
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    hidingNavigationBarManager?.viewWillAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    hidingNavigationBarManager?.viewWillDisappear(animated)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let height = topBlockHeightAnchor!.constant + layoutBlockHeightAnchor!.constant + priceBlocHeightAnchor!.constant - 20
     scrollView.contentSize = CGSize(width: screenSize.width, height: height)
  }
  
 
  
  
  fileprivate func setConstraints () {
    topBlock.translatesAutoresizingMaskIntoConstraints = false
    layoutBlock.translatesAutoresizingMaskIntoConstraints = false
    priceBlock.translatesAutoresizingMaskIntoConstraints = false
    
    topBlock.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    topBlock.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
    topBlockHeightAnchor = topBlock.heightAnchor.constraint(equalToConstant: 350)
    topBlockHeightAnchor?.isActive = true
    
    layoutBlock.topAnchor.constraint(equalTo: topBlock.bottomAnchor).isActive = true
    layoutBlock.widthAnchor.constraint(equalTo: topBlock.widthAnchor).isActive = true
    layoutBlockHeightAnchor = layoutBlock.heightAnchor.constraint(equalToConstant: 400)
    layoutBlockHeightAnchor?.isActive = true
    
    priceBlock.topAnchor.constraint(equalTo: layoutBlock.bottomAnchor).isActive = true
    priceBlock.widthAnchor.constraint(equalTo: layoutBlock.widthAnchor).isActive = true
    priceBlocHeightAnchor =  priceBlock.heightAnchor.constraint(equalToConstant: 150)
    priceBlocHeightAnchor?.isActive = true
  }
}


extension PostersViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      if scrollView.isDecelerating {
        view.endEditing(true)
    }
  }
}


extension PostersViewController {
  
  func pickTheLayout(_ sender: Any) {
    
    if (layoutBlock.layout.image == nil) {
      //no image set
      layoutBlock.layoutPicker.allowsEditing = false
      layoutBlock.layoutPicker.sourceType = .photoLibrary
      layoutBlock.layoutPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
      
      self.present(layoutBlock.layoutPicker, animated: true, completion: nil)
    
    } else {
      //image set
     layoutBlock.layout.image = nil
     layoutBlock.managingStatesOfElements()
    }
  }

  
  func materialsInfoTapped(_ sender: Any) {
    resetTableView()
    
    let controller = ViewController()//ExpandingMaterialViewController()
    let navigationController = MainNavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .custom
    navigationController.transitioningDelegate = self.materialInfoTransition
    self.present(navigationController, animated: true, completion: nil)
    
    items = [("citylightPicture", "Citylight"),("lomondPicture", "Lomond"),("photoPPictue", "Photo paper premium")]
    gottenSignal.postersSignal = true
  }
 }


extension PostersViewController {
  
  func AddToCart(_ sender: Any) {
    
    if priceBlock.addToCart.titleLabel?.text == priceBlock.addToCartButtonTitleAfterTapping {

      
      let destination = ShoppingCartVC ()
      let navigationController = MainNavigationController(rootViewController: destination)
      navigationController.modalPresentationStyle = .currentContext
      self.present(navigationController, animated: true, completion: nil)
      
    } else {
      
      let newItem = AddedItems(context: managedObjextContext)
      
      newItem.productType =  topBlock.title.text //navigationItem.title!
      
      var postprint = ""
      if topBlock.postprintField.text == "" {
        postprint = topBlock.postprintField.placeholder!
      } else {
        postprint = topBlock.postprintField.text!
      }
      
      newItem.list = ("Тираж: \(topBlock.amountField.text!) шт.\nМатериал: \(topBlock.materialField.text!)\nРазмер: \(topBlock.widthField.text!) .м. x \(topBlock.heightField.text!) м." )
      
      newItem.postprint = "\n\(postprint)"
      
      newItem.price =  currentPageData.price // (priceBlock.text!)
      newItem.ndsPrice = currentPageData.ndsPrice//(postersNDSPrice.text!)
      
      
      
      if layoutBlock.layout.image == nil {
        
        print("NO LAYOUT")
        
        
        if layoutBlock.layoutDevSwitch.isOn {
          newItem.layoutLink = NSLocalizedString("OrderingViewControllers.SelectedLayoutDevelopment", comment: "")
        }
        
        if layoutBlock.layoutLinkField.text != "" {
          newItem.layoutLink = layoutBlock.layoutLinkField.text
        }
        
      } else {
        
        newItem.layoutLink = ""
        
        if let imageData = UIImageJPEGRepresentation(layoutBlock.fullSizeOpeningImage, 1.0) as NSData? {
          newItem.layoutImage = imageData
        }
        
        if let imageData = UIImageJPEGRepresentation(layoutBlock.layout.image!, 1.0) as NSData? {
          newItem.layoutImagePreview = imageData
        }
      }
      
      
      
      do {
        try managedObjextContext.save()
      }catch {
        print("Could not save data \(error.localizedDescription)")
      }
      
      updateBadgeValue()
      priceBlock.ChangeAddToCartTitleToAdded()
    }
  }
}


/*
 
 func compressImage (_ image: UIImage) -> UIImage {
 
 let actualHeight:CGFloat = image.size.height
 let actualWidth:CGFloat = image.size.width
 let imgRatio:CGFloat = actualWidth/actualHeight
 let maxWidth:CGFloat = 1024.0
 let resizedHeight:CGFloat = maxWidth/imgRatio
 let compressionQuality:CGFloat = 0.8
 
 let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
 UIGraphicsBeginImageContext(rect.size)
 image.draw(in: rect)
 let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
 let imageData:Data = UIImageJPEGRepresentation(img, compressionQuality)!
 UIGraphicsEndImageContext()
 
 return UIImage(data: imageData)!
 
 }
 
 */
