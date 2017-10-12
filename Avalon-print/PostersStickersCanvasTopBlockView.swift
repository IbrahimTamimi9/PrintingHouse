//
//  PostersStickersCanvasTopBlockView.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/21/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit


var topBlockHeightAnchor: NSLayoutConstraint?

class PostersStickersCanvasTopBlockView: UIView {
  
  var materialPicker = UIPickerView()
  var postPrintPicker = UIPickerView()
  var selectedMaterialRow = Int()
  
  var title: UILabel = {
    var title = UILabel()
    title.translatesAutoresizingMaskIntoConstraints = false
    title.font =  UIFont.systemFont(ofSize: 34)
   
    return title
  }()
  
  let amountField: AvalonUITextField = {
    let amountField = AvalonUITextField()
    amountField.placeholder =  NSLocalizedString("PostersStickersCanvasTopBlockView.amountField.placeholder", comment: "")
    amountField.translatesAutoresizingMaskIntoConstraints = false
    amountField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    amountField.keyboardType = .numberPad
    amountField.isPasteEnabled = false
   
    return amountField
  }()
  
  let materialField: AvalonUITextField = {
     let materialField = AvalonUITextField()
     materialField.placeholder =  NSLocalizedString("PostersStickersCanvasTopBlockView.materialField.placeholder", comment: "")
     materialField.translatesAutoresizingMaskIntoConstraints = false
     materialField.clearButtonMode = .never
     materialField.isCutEnabled = false
     materialField.isPasteEnabled = false
     materialField.isDeleteEnabled = false
     materialField.autocorrectionType = .no
     materialField.tintColor = .clear
    
     return materialField
  }()
  
  let materialsInfo: UIButton = {
    let materialsInfo = UIButton(type: UIButtonType.infoDark )
     materialsInfo.translatesAutoresizingMaskIntoConstraints = false    
    
    return materialsInfo
  }()
  
  let widthField: AvalonUITextField = {
     let widthField = AvalonUITextField()
     widthField.placeholder = NSLocalizedString("PostersStickersCanvasTopBlockView.widthField.placeholder", comment: "")
     widthField.translatesAutoresizingMaskIntoConstraints = false
     widthField.textAlignment = .center
     widthField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
     widthField.keyboardType = .decimalPad
     widthField.isPasteEnabled = false
    
     return widthField
  }()

  let heightField: AvalonUITextField = {
     let heightField = AvalonUITextField()
     heightField.placeholder = NSLocalizedString("PostersStickersCanvasTopBlockView.heightField.placeholder", comment: "")
     heightField.translatesAutoresizingMaskIntoConstraints = false
     heightField.textAlignment = .center
     heightField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
     heightField.keyboardType = .decimalPad
     heightField.isPasteEnabled = false
    
     return heightField
  }()

  let postprintField: AvalonUITextField = {
     let postprintField = AvalonUITextField()
     postprintField.placeholder = NSLocalizedString("PostersStickersCanvasTopBlockView.postprintField.placeholder", comment: "")
     postprintField.translatesAutoresizingMaskIntoConstraints = false
     postprintField.clearButtonMode = .never
     postprintField.isCutEnabled = false
     postprintField.isPasteEnabled = false
     postprintField.isDeleteEnabled = false
     postprintField.autocorrectionType = .no
     postprintField.tintColor = .clear

     return postprintField
  }()
    
  
  let inset: CGFloat = 8
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor.white
    
    materialPicker.delegate = self
    materialPicker.dataSource = self
    postPrintPicker.delegate = self
    
    materialField.inputView = materialPicker
    postprintField.inputView = postPrintPicker
    materialField.placeholder = priceData.materialsDictionary[0].title
    postprintField.placeholder = priceData.postPrintDictionary[0].title
    
    materialPicker.backgroundColor =   UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
    postPrintPicker.backgroundColor =  UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
    
    title.backgroundColor = backgroundColor
 
    addSubview(title)
    title.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
    title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
   
    addSubview(amountField)
    amountField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 26).isActive = true
    amountField.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
    amountField.trailingAnchor.constraint(equalTo: title.trailingAnchor).isActive = true
    amountField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    addSubview(materialField)
    materialField.topAnchor.constraint(equalTo: amountField.bottomAnchor, constant: 26).isActive = true
    materialField.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
    materialField.trailingAnchor.constraint(equalTo: title.trailingAnchor).isActive = true
    materialField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    addSubview(materialsInfo)
    materialsInfo.centerYAnchor.constraint(equalTo: materialField.centerYAnchor).isActive = true
    materialsInfo.trailingAnchor.constraint(equalTo: materialField.trailingAnchor).isActive = true
    materialsInfo.widthAnchor.constraint(equalToConstant: 50).isActive = true
    materialsInfo.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    addSubview(widthField)
    widthField.topAnchor.constraint(equalTo: materialField.bottomAnchor, constant: 26).isActive = true
    widthField.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
    widthField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    widthField.trailingAnchor.constraint(equalTo: materialField.centerXAnchor, constant: -15).isActive = true
    
    addSubview(heightField)
    heightField.trailingAnchor.constraint(equalTo: title.trailingAnchor).isActive = true
    heightField.centerYAnchor.constraint(equalTo: widthField.centerYAnchor).isActive = true
    heightField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    heightField.leadingAnchor.constraint(equalTo: materialField.centerXAnchor, constant: 15).isActive = true
    
    addSubview(postprintField)
    postprintField.topAnchor.constraint(equalTo: widthField.bottomAnchor, constant: 26).isActive = true
    postprintField.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
    postprintField.trailingAnchor.constraint(equalTo: title.trailingAnchor).isActive = true
    postprintField.heightAnchor.constraint(equalToConstant: 50).isActive = true
  }
  
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    
  }
  

  @objc func textFieldDidChange(textField: AvalonUITextField) {
    
      currentPageData.amount = amountField.text!
      currentPageData.width = widthField.text!
      currentPageData.height = heightField.text!
    
  if textField == widthField || textField == heightField {
     validateLayoutSize(row: selectedMaterialRow)}
    
     calculatePriceOfSelectedProduct()
  }
  

  func validateLayoutSize(row: Int) {
    selectedMaterialRow = row
    
    if currentPageData.width.convertToDemicalIfItIsNot > priceData.materialsDictionary[row].maxMaterialWidth &&
      currentPageData.height.convertToDemicalIfItIsNot > priceData.materialsDictionary[row].maxMaterialWidth {
      
      
      let oversizeAlertTitle = NSLocalizedString("PostersStickersCanvasTopBlockView.oversizeAlertTitle", comment: "")
      let oversizeAlertMessage = NSLocalizedString("PostersStickersCanvasTopBlockView.oversizeAlertMessage", comment: "")
      let oversizeAlert = UIAlertController(title: oversizeAlertTitle,
                                            message: "\(oversizeAlertMessage) \(priceData.materialsDictionary[row].maxMaterialWidth)m",
                                            preferredStyle: UIAlertControllerStyle.actionSheet)
      let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
      
      oversizeAlert.addAction(okAction)
      
      rootPresent(viewController: oversizeAlert)
      
      widthField.text = ""
      currentPageData.width = widthField.text!
    }
  }
  
}


extension PostersStickersCanvasTopBlockView: UIPickerViewDataSource {
  
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  
  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    materialPicker.tag = 0
    postPrintPicker.tag = 1
    
    if pickerView.tag == 0 {
      return priceData.materialsDictionary.count
      
      
    } else if pickerView.tag == 1 {
      return  priceData.postPrintDictionary.count
    }
    return 1
  }
}


extension PostersStickersCanvasTopBlockView: UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    
    materialPicker.tag = 0
    postPrintPicker.tag = 1
    
    if pickerView.tag == 0 {
      
      let pickerLabel = UILabel()
      pickerLabel.textColor = UIColor.black
      pickerLabel.text = priceData.materialsDictionary[row].title
      pickerLabel.font = UIFont.systemFont(ofSize: 17)
      pickerLabel.textAlignment = NSTextAlignment.center
      return pickerLabel
    } else {
      let pickerLabel = UILabel()
      pickerLabel.textColor = UIColor.black
      pickerLabel.text = priceData.postPrintDictionary[row].title
      pickerLabel.font = UIFont.systemFont(ofSize: 17)
      pickerLabel.textAlignment = NSTextAlignment.center
      return pickerLabel
    }
  }
  
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    materialPicker.tag = 0
    postPrintPicker.tag = 1
 
    
    if pickerView.tag == 0 /* Materials */ {
      
      validateLayoutSize(row: row)
      
      priceData.materialPrice = priceData.materialsDictionary[row].matPrice
      priceData.printPrice = priceData.materialsDictionary[row].printPrice
      
      calculatePriceOfSelectedProduct()
      
      return materialField.text = priceData.materialsDictionary[row].title
      
    } else if pickerView.tag == 1 /* Postprint */ {
      
      priceData.postPrintMaterialPrice = priceData.postPrintDictionary[row].materialCost
      priceData.postPrintWorkPrice = priceData.postPrintDictionary[row].costOfWork
      
      if title.text == canvasTitle {
      switch row {
      case 0 :
        currentPageData.withUnderframe = false
      case 1 :
        currentPageData.withUnderframe = true
      default: break
        
        }
      }
    
      calculatePriceOfSelectedProduct()
      
      return postprintField.text = priceData.postPrintDictionary[row].title
    }
  }
}

