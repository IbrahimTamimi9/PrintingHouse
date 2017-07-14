//
//  LayoutSelectionView.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/21/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit


var layoutBlockHeightAnchor: NSLayoutConstraint?

class LayoutSelectionView: UIView {
  
  let layoutPicker = UIImagePickerController()
  let attachLayoutTitleBeforeTapping = NSLocalizedString("LayoutSelectionView.attachLayoutTitleBeforeTapping", comment: "")
  let attachLayoutTitleAfterTapping = NSLocalizedString("LayoutSelectionView.attachLayoutTitleAfterTapping", comment: "")

  
 
  
  var layoutTitle: UILabel = {
    var layoutTitle = UILabel()
    layoutTitle.translatesAutoresizingMaskIntoConstraints = false
    layoutTitle.font =  UIFont.systemFont(ofSize: 24)
    layoutTitle.text = NSLocalizedString("LayoutSelectionView.layoutTitle.text", comment: "")//"Макет"
    layoutTitle.textAlignment = .center
    
    return layoutTitle
  }()
  
  var layoutDevelopmentTitle: UILabel = {
    var layoutDevelopmentTitle = UILabel()
    layoutDevelopmentTitle.translatesAutoresizingMaskIntoConstraints = false
    layoutDevelopmentTitle.font =  UIFont.systemFont(ofSize: 17)
    layoutDevelopmentTitle.text = NSLocalizedString("LayoutSelectionView.layoutDevelopmentTitle.text", comment: "")//"Разработка макета"
    
    return layoutDevelopmentTitle
  }()

  let layoutDevSwitch: UISwitch = {
    let layoutDevSwitch = UISwitch()
    layoutDevSwitch.translatesAutoresizingMaskIntoConstraints = false
    layoutDevSwitch.addTarget(self, action: #selector(layoutDevSwitchValueDidChange(_:)), for: .valueChanged)

   
    
    return layoutDevSwitch
  }()
  
  let layoutLinkField: AvalonUITextField = {
    let layoutLinkField = AvalonUITextField()
    layoutLinkField.placeholder = NSLocalizedString("LayoutSelectionView.layoutLinkField.text", comment: "")//"Ссылка на макет"
    layoutLinkField.translatesAutoresizingMaskIntoConstraints = false
    layoutLinkField.addTarget(self, action: #selector(layoutLinkTextFielDidChange(_:)), for: .editingChanged)
    layoutLinkField.keyboardType = .URL
    
    
    return layoutLinkField
  }()
  
  let attachLayout: AvalonUIButtonLight = {
    let attachLayout = AvalonUIButtonLight()//..(type: UIButtonType.infoDark )
    attachLayout.translatesAutoresizingMaskIntoConstraints = false
    attachLayout.contentHorizontalAlignment = .left
    attachLayout.addTarget(self, action: #selector(PostersViewController.pickTheLayout(_:)), for: .touchUpInside)
   

    
    return attachLayout
  }()
  
 
 
  /*
  var canBePrintedIndicator: UILabel = {
    var canBePrintedIndicator = UILabel()
    canBePrintedIndicator.translatesAutoresizingMaskIntoConstraints = false
    canBePrintedIndicator.font = UIFont.systemFont(ofSize: 14)
    canBePrintedIndicator.text = "Подходит для печати на указаном размере"
    canBePrintedIndicator.numberOfLines = 2
    canBePrintedIndicator.textColor = UIColor(red: 0.54, green: 0.54, blue: 0.56, alpha: 1.0)
    canBePrintedIndicator.textAlignment = .center
    
    return canBePrintedIndicator
  }()
  
  let infoAboutLayout: UIButton = {
    let infoAboutLayout = UIButton()//(type: UIButtonType.infoDark )
    infoAboutLayout.translatesAutoresizingMaskIntoConstraints = false
    infoAboutLayout.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    infoAboutLayout.titleLabel?.textColor = AvalonPalette.avalonBlue
    infoAboutLayout.backgroundColor = UIColor.white
    
    return infoAboutLayout
  }()
  */
  
  let layout: UIImageView = {
    let layout = UIImageView()
    layout.translatesAutoresizingMaskIntoConstraints = false
   // layout.backgroundColor = UIColor.white
    layout.layer.borderColor = UIColor.darkGray.cgColor
    layout.layer.borderWidth = 1
    layout.layer.cornerRadius = 11
    layout.contentMode = .scaleAspectFill
    //layout.layer.backgroundColor = AvalonPalette.avalonViewControllersBackground.cgColor
 //   layout.clipsToBounds = true
    layout.layer.masksToBounds = true
   // layout.layoutIfNeeded()
    //layout.layer.isOpaque = true
    //layout.isOpaque = true
    
   // layout.backgroundColor = UIColor.black
   // layout.layer.backgroundColor = UIColor.white.cgColor
  

    return layout
  }()

  var startingFrame: CGRect?
  
  var blackBackgroundView: UIView?
  
  var startingImageView: UIImageView?
  
  var fullSizeOpeningImage = UIImage()

  
  var layoutWidthConstraint: NSLayoutConstraint?
  var layotHeightConstraint: NSLayoutConstraint?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
     layoutPicker.delegate = self
    
    attachLayout.setTitle(attachLayoutTitleBeforeTapping,for: .normal)
    
    let tapOnPreview = UITapGestureRecognizer(target: self, action: #selector(handleZoomTap))
    layout.addGestureRecognizer(tapOnPreview)
    
     backgroundColor = UIColor.white
      layoutTitle.backgroundColor = backgroundColor
      layoutDevelopmentTitle.backgroundColor = backgroundColor
   //   attachLayout.backgroundColor = backgroundColor
    
    
    addSubview(layoutTitle)
    layoutTitle.topAnchor.constraint(equalTo: topAnchor, constant: 26).isActive = true
    layoutTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    layoutTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    
    
    addSubview(layoutDevelopmentTitle)
    addSubview(layoutDevSwitch)
    layoutDevelopmentTitle.topAnchor.constraint(equalTo: layoutTitle.bottomAnchor, constant: 26).isActive = true
    layoutDevelopmentTitle.leadingAnchor.constraint(equalTo: layoutTitle.leadingAnchor).isActive = true
    layoutDevelopmentTitle.trailingAnchor.constraint(equalTo: layoutDevSwitch.leadingAnchor, constant: 0).isActive = true
    
    layoutDevSwitch.centerYAnchor.constraint(equalTo: layoutDevelopmentTitle.centerYAnchor).isActive = true
    layoutDevSwitch.trailingAnchor.constraint(equalTo: layoutTitle.trailingAnchor).isActive = true
    
    addSubview(layoutLinkField)
    layoutLinkField.topAnchor.constraint(equalTo: layoutDevelopmentTitle.bottomAnchor, constant: 26).isActive = true
    layoutLinkField.leadingAnchor.constraint(equalTo: layoutTitle.leadingAnchor).isActive = true
    layoutLinkField.trailingAnchor.constraint(equalTo: layoutTitle.trailingAnchor).isActive = true
    layoutLinkField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    
    addSubview(attachLayout)
    attachLayout.topAnchor.constraint(equalTo: layoutLinkField.bottomAnchor, constant: 26).isActive = true
    attachLayout.leadingAnchor.constraint(equalTo: layoutTitle.leadingAnchor).isActive = true
  //  attachLayout.trailingAnchor.constraint(equalTo: layoutTitle.trailingAnchor).isActive = true
    //  attachLayout.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    addSubview(layout)
    layout.topAnchor.constraint(equalTo: attachLayout.bottomAnchor, constant: 20).isActive = true
    layout.leadingAnchor.constraint(equalTo: layoutTitle.leadingAnchor).isActive = true
    
    
    layoutWidthConstraint = layout.widthAnchor.constraint(equalToConstant: 157)
    layotHeightConstraint = layout.heightAnchor.constraint(equalToConstant: 103)
      
    layoutWidthConstraint?.isActive = true
    layotHeightConstraint?.isActive = true
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    
  }
  
  
  func layoutLinkTextFielDidChange(_ sender: Any) {
    chooseAddToCartButtonState()
  }


  func layoutDevSwitchValueDidChange(_ sender: Any) {
    
    if layoutDevSwitch.isOn {
    
      layoutLinkField.isEnabled = false
      attachLayout.isEnabled = false
      layout.image = nil
      
    } else {
      
      layoutLinkField.isEnabled = true
      attachLayout.isEnabled = true
    }
    
      chooseAddToCartButtonState()
  }
  
  
  func managingStatesOfElements () {
    
    chooseAddToCartButtonState()
    
    if layout.image == nil {
      
      UIView.transition(with: self.attachLayout, duration: 0.3, options: .transitionCrossDissolve, animations: {
        self.attachLayout.setTitle(self.attachLayoutTitleBeforeTapping, for: .normal)
      }, completion: nil)
      
      layout.isUserInteractionEnabled = false
      layoutLinkField.isEnabled = true
      layoutDevSwitch.isEnabled = true
      
      self.layout.layer.borderColor = UIColor.black.cgColor// = 1
      
      self.layotHeightConstraint?.isActive = true
      
      self.layoutWidthConstraint?.isActive = true
      
      layoutBlockHeightAnchor?.constant = 400
      
      self.layoutIfNeeded()
    
    } else {
      
      layout.isUserInteractionEnabled = true
      layoutLinkField.isEnabled = false
      layoutDevSwitch.isOn = false
      layoutDevSwitch.isEnabled = false
      
      if Double(layout.image!.size.height) > Double(layout.image!.size.width) {
          layoutBlockHeightAnchor?.constant = 400 - 103 + layout.image!.size.height
       
      }
      
      if Double(layout.image!.size.height) == Double(layout.image!.size.width) {
        layoutBlockHeightAnchor?.constant = 400 - 103 + layout.image!.size.height
        
      }
     
 
      UIView.transition(with: self.attachLayout, duration: 0.3, options: .transitionCrossDissolve, animations: {
        self.attachLayout.setTitle(self.attachLayoutTitleAfterTapping, for: .normal)
      }, completion: nil)
      
    }
  }
}


extension LayoutSelectionView:  UIImagePickerControllerDelegate, UINavigationControllerDelegate { /* image picker */
  
  
 
  
//  func jpegImage(image: UIImage, maxSize: Int, minSize: Int, times: Int) -> Data? {
//    var maxQuality: CGFloat = 1.0
//    var minQuality: CGFloat = 0.0
//    var bestData: Data?
//    
//    for _ in 1...times {
//      
//      let thisQuality = (maxQuality + minQuality) / 2
//      
//      guard let data = UIImageJPEGRepresentation(image, thisQuality) else { return nil }
//      let thisSize = data.count
//      
//      if thisSize > maxSize {
//        
//        maxQuality = thisQuality
//        
//      } else {
//        
//        minQuality = thisQuality
//        
//        bestData = data
//        
//        if thisSize > minSize {
//          return bestData
//        }
//      }
//    }
//    
//    return bestData
//  }
//  
//  
//  
//  
  
  
//  typealias CompletionHandler = (_ success:Bool, _ image: UIImage) -> Void
//  
//  func reduceLargeImageSize(imageConvertedToData: NSData, maxSize: Int,completionHandler: CompletionHandler) {
//    var optimizedImage = UIImage()
//    var optimizedDataOfImage = NSData()
//    
//    
//    
//      optimizedImage = UIImage(data: imageConvertedToData as Data)!
//    
//    for i in (0...10).reversed() {
//      let quality = i/10
//      
//      optimizedDataOfImage = UIImageJPEGRepresentation(optimizedImage, CGFloat(quality))! as NSData
//      
//      print("\nReducing image size, current size: \(optimizedDataOfImage.length) bytes\n")
//      
//      if optimizedDataOfImage.length <= maxSize {
//        
//        print("\ngood optimized data swize", optimizedDataOfImage.length, "bytes\n finishing...")
//        
//        optimizedImage = UIImage(data: optimizedDataOfImage as Data)!
//        
//        let flag = true
//        print("completion handler thrown")
//        completionHandler(flag, optimizedImage)
//        
//        
//        break
//      }
//      
//    }
// 
//    
//   
//  }
  
  func compressImage (_ image: UIImage) -> UIImage {
    
    let actualHeight:CGFloat = image.size.height
    let actualWidth:CGFloat = image.size.width
    let imgRatio:CGFloat = actualWidth/actualHeight
    let maxWidth:CGFloat = 3500.0
    let resizedHeight:CGFloat = maxWidth/imgRatio
    let compressionQuality:CGFloat = 0.5
    
    let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in: rect)
    let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    let imageData:Data = UIImageJPEGRepresentation(img, compressionQuality)!
    UIGraphicsEndImageContext()
    
    return UIImage(data: imageData)!
    
    
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
  
    if chosenImage.size.width > 3500 && chosenImage.size.height > 3500 {
      
        self.fullSizeOpeningImage = self.compressImage(chosenImage)
        print(self.fullSizeOpeningImage.size.width, self.fullSizeOpeningImage.size.height)
      } else {
        self.fullSizeOpeningImage = chosenImage
      }
      
      
      self.layotHeightConstraint?.isActive = false
      
      self.layoutWidthConstraint?.isActive = false
      
      self.layout.image = imageWithImage(sourceImage: self.fullSizeOpeningImage, scaledToWidth: 157)// chosenImage
      
      self.layout.layer.borderColor = UIColor.clear.cgColor
      
      self.managingStatesOfElements()

      rootDismiss()
  }
  
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

    managingStatesOfElements()
    rootDismiss()
  }
  
}


