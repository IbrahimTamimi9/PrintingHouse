//
//  MainPageController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/1/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//


import UIKit
import JTMaterialTransition 


class bannersVC: UIViewController {
    
    
    @IBOutlet weak var AboutMaterialsButton: UIButton!
    @IBOutlet weak var leftImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var bannersAmountTextField: HoshiTextField!
    @IBOutlet weak var bannersMaterialTextField: UITextField!
    @IBOutlet weak var bannersWidthTextField: HoshiTextField!
    @IBOutlet weak var bannersHeightTextField: HoshiTextField!
    @IBOutlet weak var luversSetUpSwitch: UISwitch!
    @IBOutlet weak var pocketsSeamsSetUpSwitch: UISwitch!
    @IBOutlet weak var luversAmountOnOneProduct: UITextField!
    @IBOutlet weak var lengthPocketsSeams: UITextField!
    @IBOutlet weak var bannersPrice: UILabel!
    @IBOutlet weak var bannersNDSPrice: UILabel!
    @IBOutlet weak var bannersAddToCartButton: UIButton!
    
    var materialInfoTransition = JTMaterialTransition()
  
    var materialPicker = UIPickerView()
  
    var data = ["Выберите материал...", "Баннер ламинированный 280 г/м2", "Баннер литой 440 г/м2", "Баннер литой Backlit (просветный)", "Баннерная сетка Mesh"]
  
  let oversizeAlert = UIAlertController(title: "Превышен максимальный размер", message: "Максимальная ширина 3.00м", preferredStyle: UIAlertControllerStyle.actionSheet)
  
  
  let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
  
  let nameButt =  "В корзину"

  
  
    override func viewWillDisappear(_ animated: Bool) {
        leftImageViewConstraint.constant = 0
    }
  
  
    override func viewDidAppear(_ animated: Bool) {
        leftImageViewConstraint.constant = -25
    }

  
    override func viewDidLoad() {
        super.viewDidLoad()
            managedObjextContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
            self.hideKeyboardWhenTappedAround()
        
            mainScrollView.delegate = self
        
            setTextFieldDelegates(sender: [bannersAmountTextField, bannersWidthTextField, bannersHeightTextField, bannersMaterialTextField, luversAmountOnOneProduct, lengthPocketsSeams])
        
            applyMotionEffect(toView: backgroundImageView, magnitude: 25)
            setPickerTextFieldTint(sender: [bannersMaterialTextField])
        
            self.materialInfoTransition = JTMaterialTransition(animatedView: self.AboutMaterialsButton)
      
            materialPicker.delegate = self
            materialPicker.dataSource = self
            bannersMaterialTextField.inputView = materialPicker
            bannersMaterialTextField.text = data[0]
      
            bannersMaterialTextField.delegate = self
            bannersWidthTextField.delegate = self
            bannersHeightTextField.delegate = self
            bannersAmountTextField.delegate = self
            luversAmountOnOneProduct.delegate = self
            lengthPocketsSeams.delegate = self
      
      oversizeAlert.addAction(okAction)
      
      setPickerTextFieldTint(sender: [bannersMaterialTextField])
      materialPicker.backgroundColor = UIColor.darkGray

      
   }
    
    
    func setTextFieldDelegates(sender: [UITextField]) {
        for textfield in sender {
            textfield.delegate = self
        }
    }

    
    @IBAction func AddToCart(_ sender: Any) {
      
      if bannersAddToCartButton.titleLabel?.text == nameButt {
        
        let destination = storyboard?.instantiateViewController(withIdentifier: "shoppingCartVC") as! shoppingCartVC
        let navigationController = UINavigationController(rootViewController: destination)
        
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navigationController.isNavigationBarHidden = true
        self.present(navigationController, animated: true, completion: nil)
        
      } else {
        
        var setupLuversCoreData = ""
      
        var setupPocketSeamsCoreData = ""
       
        
        if luversSetUpSwitch.isOn == true {
          setupLuversCoreData = "Количество люверсов в одном изделии (шт): \(luversAmountOnOneProduct.text!) "
          
        } else {
          
          setupLuversCoreData = "Установка люверсов: нет"
        
        }
        
        
        if pocketsSeamsSetUpSwitch.isOn == true {
              setupPocketSeamsCoreData = "Общая длинна кармана шва (м): \(lengthPocketsSeams.text!)"
        } else {
              setupPocketSeamsCoreData = "Проварка карманов швов: нет"
        }
        
        
        let newItem = AddedItems(context: managedObjextContext)
        
        newItem.list = ("Тираж: \(bannersAmountTextField.text!) шт.\nМатериал: \(bannersMaterialTextField.text!)\nРазмер: \(bannersWidthTextField.text!) .м. x \(bannersHeightTextField.text!) м.\n\(setupLuversCoreData) \n\(setupPocketSeamsCoreData)" )
        
        newItem.price = (bannersPrice.text!)
        newItem.ndsPrice = (bannersNDSPrice.text!)
        
        do {
          try managedObjextContext.save()
        }catch {
          print("Could not save data \(error.localizedDescription)")
        }
        
        updateBadgeValue()
        DisableButton()
        
      }
    }
  
  
    @IBAction func amountCursorPosChanged(_ sender: Any) {
      
      if ( bannersAmountTextField.text == nil) {
        bannersBoolVariables.amountDidNotInputed = true
        updatePrices()
      } else {
        bannersBoolVariables.amountDidNotInputed = false
        bannersBoolVariables.amount = bannersAmountTextField.text!
        
        updatePrices()
      }
      
      if bannersAddToCartButton.titleLabel?.text == nameButt {
        EnableButton()
      }

    }
  
  
    @IBAction func widthCursorPosChanged(_ sender: Any) {
      
      bannersBoolVariables.bannersWidhOrHeightDidNotInputed = false
      bannersBoolVariables.bannersWidthSet =  bannersWidthTextField.text!
      errorsCheck()
      updatePrices()
      if bannersAddToCartButton.titleLabel?.text == nameButt {
        EnableButton()
      }

    }
  
  
    @IBAction func heightCursorPosChanged(_ sender: Any) {
      
      bannersBoolVariables.bannersWidhOrHeightDidNotInputed = false
      bannersBoolVariables.bannersHeightSet = bannersHeightTextField.text!
      errorsCheck()
      updatePrices()
      if bannersAddToCartButton.titleLabel?.text == nameButt {
        EnableButton()
      }

    }

 
  
  
  @IBAction func luversAmountOnOneProductCursorPosChanged(_ sender: Any) {
    
     bannersBoolVariables.luversAmountOnOneproductSet = luversAmountOnOneProduct.text!
     updatePrices()
    
    if bannersAddToCartButton.titleLabel?.text == nameButt {
      EnableButton()
    }
  }
  
  
  @IBAction func lengthPocketsSeamsCursorPosChanged(_ sender: Any) {
    
     bannersBoolVariables.lengthPocketsSeams = lengthPocketsSeams.text!
     updatePrices()
    
    if bannersAddToCartButton.titleLabel?.text == nameButt {
      EnableButton()
    }
  }
  
  
  @IBAction func luversSetUpSwitchStateChanged(_ sender: Any) {
         updatePrices()
      if bannersAddToCartButton.titleLabel?.text == nameButt {
         EnableButton()
      }

      if luversSetUpSwitch.isOn == true {
        
        textfieldState(textField: luversAmountOnOneProduct, state: true)
        
        
      } else {
        
        textfieldState(textField: luversAmountOnOneProduct, state: false)
        
      }
      
    }
  
  
    @IBAction func pocketsSeamsSetUpSwitchStateChanged(_ sender: Any) {
         updatePrices()
      if bannersAddToCartButton.titleLabel?.text == nameButt {
         EnableButton()
      }

      if pocketsSeamsSetUpSwitch.isOn == true {
        
        textfieldState(textField: lengthPocketsSeams, state: true)
        
      } else {
        
        textfieldState(textField: lengthPocketsSeams, state: false)
        
      }
      
    }
  
    
    @IBAction func openInfoAboutMaterials(_ sender: Any) {
        resetTableView ()
      
        let controller = storyboard?.instantiateViewController(withIdentifier:"ExpandingMaterialViewController")
        controller?.modalPresentationStyle = .custom
        controller?.transitioningDelegate = self.materialInfoTransition
        self.present(controller!, animated: true, completion: nil)
        
      
        items = [("bannerLaminPicture", "Баннер ламинированный"), ("bannerLitoyPicture", "Баннер литой"), ("backlitPicture", "Backlit"), ("meshPicture", "Mesh")]
        gottenSignal.bannersSignal = true
    }
  
  
  func DisableButton() {
    bannersAddToCartButton.setTitle("В корзину", for: .normal)
  }
  
  
  func EnableButton() {
    bannersAddToCartButton.setTitle("Добавить в корзину", for: .normal )
    bannersAddToCartButton.isUserInteractionEnabled = true
    bannersAddToCartButton.setTitleColor(UIColor.white, for: UIControlState.normal)
  }
  
  
  func updatePrices() {
    bannersComputings()
    bannersPrice.text = bannersBoolVariables.priceToLabel
    bannersNDSPrice.text = bannersBoolVariables.ndsPriceToLabel
    
   
    if bannersPrice.text == "0" || ( luversSetUpSwitch.isOn == true && (luversAmountOnOneProduct.text == "" ) ||
      (pocketsSeamsSetUpSwitch.isOn == true && (lengthPocketsSeams.text == ""))) {
      
      UIView.animate(withDuration: 0.5, animations: {
        self.bannersAddToCartButton.alpha = 0.5 })
      bannersAddToCartButton.isEnabled  = false
    } else {
      bannersAddToCartButton.isEnabled = true
      UIView.animate(withDuration: 0.5, animations: {
        self.bannersAddToCartButton.alpha = 1.0 })
    }
    
  }
  
  
  func errorsCheck() {
    if  ( bannersMaterialTextField.text == data[0] ) {
      
    }  else if ( bannersBoolVariables.bannersWidthSet.convertToDemicalIfItIsNot > 3.001 &&
                 bannersBoolVariables.bannersHeightSet.convertToDemicalIfItIsNot > 3.001 ) {
      self.present(oversizeAlert, animated: true, completion: nil)
      bannersWidthTextField.text = ""
      bannersBoolVariables.bannersWidthSet = bannersWidthTextField.text!
      updatePrices()
      
    }
  }
  
  
  func textfieldState(textField: UITextField, state: Bool ) {
    
    if state == true {
      
      textField.isEnabled = true
      
      UIView.animate(withDuration: 0.3, animations: {
        textField.alpha = 0.7 })
      
      
      
    } else {
      
      textField.isEnabled = false
      textField.text = ""
      
      UIView.animate(withDuration: 0.3, animations: {
        textField.alpha = 0.5 })
      
    }
    
  }

}


extension bannersVC: UIScrollViewDelegate {
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 || scrollView.contentOffset.x<0 {
            scrollView.contentOffset.x = 0
        }
    }
}


extension bannersVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1, animations: { textField.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) }, completion: { (finish: Bool) in UIView.animate(withDuration: 0.1, animations: { textField.transform = CGAffineTransform.identity }) })
    }
    
}


extension bannersVC: UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    materialPicker.tag = 0
   
    
    if pickerView.tag == 0 {
    EnableButton()
      
      if row == 0 { print("didnotChosen");
        bannersBoolVariables.materialDidnNotChosen = true
        bannersBoolVariables.laminatedBannerC = false
        bannersBoolVariables.castBannerC = false
        bannersBoolVariables.backlitC = false
        bannersBoolVariables.meshC = false
        bannersComputings()
        bannersPrice.text = bannersBoolVariables.priceToLabel
        bannersNDSPrice.text = bannersBoolVariables.ndsPriceToLabel
        updatePrices()
        
      }
      
      if row == 1 { print("laminated Banner");
        bannersBoolVariables.materialDidnNotChosen = false
        bannersBoolVariables.laminatedBannerC = true
        bannersBoolVariables.castBannerC = false
        bannersBoolVariables.backlitC = false
        bannersBoolVariables.meshC = false
        errorsCheck()
        bannersComputings()
        bannersPrice.text = bannersBoolVariables.priceToLabel
        bannersNDSPrice.text = bannersBoolVariables.ndsPriceToLabel
        updatePrices()
      }
      
      if row == 2 { print("cast Banner");
        bannersBoolVariables.materialDidnNotChosen = false
        bannersBoolVariables.laminatedBannerC = false
        bannersBoolVariables.castBannerC = true
        bannersBoolVariables.backlitC = false
        bannersBoolVariables.meshC = false
        errorsCheck()
        bannersComputings()
        bannersPrice.text = bannersBoolVariables.priceToLabel
        bannersNDSPrice.text = bannersBoolVariables.ndsPriceToLabel
        updatePrices()

      }
      
      if row == 3 { print("backlit");
        bannersBoolVariables.materialDidnNotChosen = false
        bannersBoolVariables.laminatedBannerC = false
        bannersBoolVariables.castBannerC = false
        bannersBoolVariables.backlitC = true
        bannersBoolVariables.meshC = false
        errorsCheck()
        bannersComputings()
        bannersPrice.text = bannersBoolVariables.priceToLabel
        bannersNDSPrice.text = bannersBoolVariables.ndsPriceToLabel
        updatePrices()

      }
      if row == 4 { print("mesh");
        bannersBoolVariables.materialDidnNotChosen = false
        bannersBoolVariables.laminatedBannerC = false
        bannersBoolVariables.castBannerC = false
        bannersBoolVariables.backlitC = false
        bannersBoolVariables.meshC = true
        errorsCheck()
        bannersComputings()
        bannersPrice.text = bannersBoolVariables.priceToLabel
        bannersNDSPrice.text = bannersBoolVariables.ndsPriceToLabel
        updatePrices()

      }
      
      updatePrices()
      return bannersMaterialTextField.text = data[row]      
      
    }
    
  }
  
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
   
  let pickerLabel = UILabel()
      pickerLabel.textColor = UIColor.white
      pickerLabel.text = data[row]
      pickerLabel.font = UIFont.systemFont(ofSize: 16)
      pickerLabel.textAlignment = NSTextAlignment.center
    
  return pickerLabel
  }
  
}


extension bannersVC: UIPickerViewDataSource {
  
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
 
  
  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    materialPicker.tag = 0
    
    if pickerView.tag == 0 {
      return data.count
    }
    
    return 1
  }

}
