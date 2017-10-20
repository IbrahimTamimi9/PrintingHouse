//
//  BannersViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/23/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import JTMaterialTransition

class BannersViewController: UIViewController {
  
  let scrollView = UIScrollView(frame: UIScreen.main.bounds)
  
  var topBlock = PostersStickersCanvasTopBlockView()
  
  var postPrintBlock = BannersPostprintView()
  
  var layoutBlock = LayoutSelectionView()
  
  var priceBlock = PriceAndAddToCartView()
  
  var materialInfoTransition = JTMaterialTransition()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.white
    topBlock.title.text = bannersTitle
    extendedLayoutIncludesOpaqueBars = true
    
    currentPageData.viewControllersPriceBlock = priceBlock  /* necessary!!!! for displaying calculated price */
    currentPageData.viewControllersLayoutBlock = layoutBlock
    
    self.scrollView.delegate = self
    
    view.addSubview(scrollView)
    scrollView.addSubview(topBlock)
    scrollView.addSubview(postPrintBlock)
    scrollView.addSubview(layoutBlock)
    scrollView.addSubview(priceBlock)

    fetchMaterialsForBanners(productType: "Banners")
    fetchPostprintForBanners()
    managedObjextContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    self.materialInfoTransition = JTMaterialTransition(animatedView: topBlock.materialsInfo)
    self.hideKeyboardWhenTappedAround()
    
    priceBlock.addToCart.addTarget(self, action: #selector(AddToCart(_:)), for: .touchUpInside)
    topBlock.materialsInfo.addTarget(self, action: #selector(materialsInfoTapped), for: .touchUpInside)
    
    topBlock.postprintField.isEnabled = false
    
    setConstraints()
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let height = topBlockHeightAnchor!.constant + postprintBlockHeightAnchor!.constant + layoutBlockHeightAnchor!.constant + priceBlocHeightAnchor!.constant - 20
    
    scrollView.contentSize = CGSize(width: screenSize.width, height: height)
  }
  
  fileprivate func setConstraints () {
    topBlock.translatesAutoresizingMaskIntoConstraints = false
    postPrintBlock.translatesAutoresizingMaskIntoConstraints = false
    layoutBlock.translatesAutoresizingMaskIntoConstraints = false
    priceBlock.translatesAutoresizingMaskIntoConstraints = false
    
    topBlock.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    topBlock.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
    topBlockHeightAnchor = topBlock.heightAnchor.constraint(equalToConstant: 350)
    topBlockHeightAnchor?.isActive = true
    
    postPrintBlock.topAnchor.constraint(equalTo: topBlock.bottomAnchor).isActive = true
    postPrintBlock.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
    postprintBlockHeightAnchor = postPrintBlock.heightAnchor.constraint(equalToConstant: 250)
    postprintBlockHeightAnchor?.isActive = true
    
    layoutBlock.topAnchor.constraint(equalTo: postPrintBlock.bottomAnchor).isActive = true
    layoutBlock.widthAnchor.constraint(equalTo: postPrintBlock.widthAnchor).isActive = true
    layoutBlockHeightAnchor = layoutBlock.heightAnchor.constraint(equalToConstant: 400)
    layoutBlockHeightAnchor?.isActive = true
    
    priceBlock.topAnchor.constraint(equalTo: layoutBlock.bottomAnchor).isActive = true
    priceBlock.widthAnchor.constraint(equalTo: layoutBlock.widthAnchor).isActive = true
    priceBlocHeightAnchor =  priceBlock.heightAnchor.constraint(equalToConstant: 150)
    priceBlocHeightAnchor?.isActive = true
  }
}



extension BannersViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.isDecelerating {
      view.endEditing(true)
    }
  }
}

extension BannersViewController {
  
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
  
  @objc func materialsInfoTapped(_ sender: Any) {
    resetTableView()
    
    let controller = ViewController()
    let navigationController = MainNavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .custom
    navigationController.transitioningDelegate = self.materialInfoTransition
    self.present(navigationController, animated: true, completion: nil)

    
    items = [("bannerLaminPicture", "Баннер ламинированный"), ("bannerLitoyPicture", "Баннер литой"), ("backlitPicture", "Backlit"), ("meshPicture", "Mesh")]
    gottenSignal.bannersSignal = true
  }
  
  
  
}


extension BannersViewController {
  
  @objc func AddToCart(_ sender: Any) {
    
    if priceBlock.addToCart.titleLabel?.text == priceBlock.addToCartButtonTitleAfterTapping {
      
      let destination = ShoppingCartVC ()
      let navigationController = MainNavigationController(rootViewController: destination)
      navigationController.modalPresentationStyle = .currentContext
      self.present(navigationController, animated: true, completion: nil)
      
    } else {
      
      let newItem = AddedItems(context: managedObjextContext)
      
      newItem.productType = topBlock.title.text //navigationItem.title!
    
      var setupLuversCoreData = ""
      
      var setupPocketSeamsCoreData = ""
      
      if postPrintBlock.luversSwitch.isOn {
        setupLuversCoreData = "Люверсы: по \(postPrintBlock.luversAmountField.text!) шт. на изделие"
      } else {
        setupLuversCoreData = "Люверсы: нет"
      }
      
      if postPrintBlock.pocketsSwitch.isOn {
        setupPocketSeamsCoreData = "Проварка швов: по \(postPrintBlock.pocketsLengthField.text!) м. на изделие"
      } else {
        setupPocketSeamsCoreData = "Проварка карманов: нет"
      }
            
      
   //   newItem.list = ("Тираж: \(topBlock.amountField.text!) шт.\nМатериал: \(topBlock.materialField.text!)\nРазмер: \(topBlock.widthField.text!) .м. x \(topBlock.heightField.text!) м.\n\(setupLuversCoreData) \n\(setupPocketSeamsCoreData)" )
      
      newItem.list = ("Тираж: \(topBlock.amountField.text!) шт.\nМатериал: \(topBlock.materialField.text!)\nРазмер: \(topBlock.widthField.text!) .м. x \(topBlock.heightField.text!) м." )
      
      newItem.postprint = "\n\(setupLuversCoreData) \n\(setupPocketSeamsCoreData)"
      
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
          newItem.layoutImage = imageData as Data
        }
        
        if let imageData = UIImageJPEGRepresentation(layoutBlock.layout.image!, 1.0) as NSData? {
          newItem.layoutImagePreview = imageData as Data
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



