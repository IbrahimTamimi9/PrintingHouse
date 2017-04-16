//
//  MainPageController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/1/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//


import UIKit
import JTMaterialTransition

 
class CanvasVC: UIViewController {
    
    @IBOutlet weak var AboutMaterialsButton: UIButton!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var canvasAmountTextField: HoshiTextField!
    @IBOutlet weak var canvasMaterialTextField: UITextField!
    @IBOutlet weak var canvasWidthTextField: HoshiTextField!
    @IBOutlet weak var canvasHeightTextField: HoshiTextField!
    @IBOutlet weak var canvasPostPrintTextField: UITextField!
    @IBOutlet weak var canvasPrice: UILabel!
    @IBOutlet weak var canvasNDSPrice: UILabel!
    @IBOutlet weak var canvasAddToCartButton: UIButton!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var leftImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var betweenAmountAndMaterial: NSLayoutConstraint!
    @IBOutlet weak var betweenWidthAndMaterial: NSLayoutConstraint!
    @IBOutlet weak var betweenHeightAndMaterial: NSLayoutConstraint!
    @IBOutlet weak var betweenSizeAndPostPrint: NSLayoutConstraint!
    @IBOutlet weak var betweenPostPrintAndPrice: NSLayoutConstraint!
  
    let nameButt =  "В корзину"
    
    var materialPicker = UIPickerView()
    var postPrintPicker = UIPickerView()
    var selectedMaterialRow = Int()
    
    var materialInfoTransition = JTMaterialTransition()
  
  
    override func viewWillDisappear(_ animated: Bool) {
        leftImageViewConstraint.constant = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        leftImageViewConstraint.constant = -25
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        fetchMaterialsAndPostprint(productType: "Canvas", onlyColdLamAllowed: false, onlyDefaultPrepressAllowed: false)
      
        managedObjextContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
         applyMotionEffect(toView: backgroundImageView, magnitude: 25)
         self.hideKeyboardWhenTappedAround()
      
      
        // //MARK: iPhone 5/5c/5s/se
        if screenSize.height == 568 {
            topConstraint.constant = 30
            betweenAmountAndMaterial.constant = 50
            betweenWidthAndMaterial.constant = 20
            betweenHeightAndMaterial.constant = 20
            betweenSizeAndPostPrint.constant = 50
            betweenPostPrintAndPrice.constant = 40
        }
     
        
        //MARK: iPhone 6+/7+
        if screenSize.height == 736 {
            topConstraint.constant = 40
            betweenAmountAndMaterial.constant = 70
            betweenWidthAndMaterial.constant = 40
            betweenHeightAndMaterial.constant = 40
            betweenSizeAndPostPrint.constant = 70
            betweenPostPrintAndPrice.constant = 60
        }
      
        materialPicker.delegate = self
        materialPicker.dataSource = self
        postPrintPicker.delegate = self
        postPrintPicker.dataSource = self
      
        canvasMaterialTextField.inputView = materialPicker
        canvasPostPrintTextField.inputView = postPrintPicker
        canvasPostPrintTextField.text = priceData.postPrintDictionary[0].title
        canvasMaterialTextField.text = priceData.materialsDictionary[0].title
      
        setPickerTextFieldTint(sender: [canvasMaterialTextField, /*standartSizeTextField,*/ canvasPostPrintTextField])
        setTextFieldDelegates(sender: [canvasWidthTextField, canvasAmountTextField, canvasHeightTextField, canvasPostPrintTextField, canvasMaterialTextField])
      
        materialPicker.backgroundColor = UIColor.darkGray
        postPrintPicker.backgroundColor = UIColor.darkGray
        
        self.materialInfoTransition = JTMaterialTransition(animatedView: self.AboutMaterialsButton)
    }
  
  
    func setTextFieldDelegates(sender: [UITextField]) {
        for textfield in sender {
            textfield.delegate = self
        }
    }
  
  
  @IBAction func amountCursorPosChanged(_ sender: Any) {
    
    if ( canvasAmountTextField.text == nil) {
      currentPageData.amountIsEmpty = true
      updatePrices()
    } else {
      
      currentPageData.amountIsEmpty = false
      currentPageData.amount = canvasAmountTextField.text!
      updatePrices()
    }
    
    if canvasAddToCartButton.titleLabel?.text == nameButt {
      EnableButton()
    }
  }
  

     @IBAction func widthCursorPosChanged(_ sender: Any) {
      
      currentPageData.widthOrHeightIsEmpty = false
      currentPageData.width = canvasWidthTextField.text!
      validateLayoutSize(row: selectedMaterialRow)
      updatePrices()
      
      if canvasAddToCartButton.titleLabel?.text == nameButt {
        EnableButton()
      }
    }
  
  
    @IBAction func heightCursorPosChanged(_ sender: Any) {
      
      currentPageData.widthOrHeightIsEmpty = false
      currentPageData.height = canvasHeightTextField.text!
      validateLayoutSize(row: selectedMaterialRow)
      updatePrices()
      
      if canvasAddToCartButton.titleLabel?.text == nameButt {
        EnableButton()
      }
    }
  

    @IBAction func AddToCart(_ sender: Any) {
        
        if canvasAddToCartButton.titleLabel?.text == nameButt {
            
            let destination = storyboard?.instantiateViewController(withIdentifier: "ShoppingCartVC") as! ShoppingCartVC
            let navigationController = UINavigationController(rootViewController: destination)
            navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            navigationController.isNavigationBarHidden = true
            self.present(navigationController, animated: true, completion: nil)
            
        } else {
            let newItem = AddedItems(context: managedObjextContext)
            
                newItem.list = ("Тираж: \(canvasAmountTextField.text!) шт.\nМатериал: \(canvasMaterialTextField.text!)\nРазмер: \(canvasWidthTextField.text!) .м. x \(canvasHeightTextField.text!) м.\nПостпечатные работы: \(canvasPostPrintTextField.text!)" )
          
            newItem.price = (canvasPrice.text!)
            newItem.ndsPrice = (canvasNDSPrice.text!)
            
            do {
                try managedObjextContext.save()
            }catch {
                print("Could not save data \(error.localizedDescription)")
            }
            
            updateBadgeValue()
            DisableButton()
            canvasAddToCartButton.frame.size.width = 75
        }
    }
    
 
    @IBAction func openInfoAboutMaterials(_ sender: Any) {
        resetTableView ()
      
        let controller = storyboard?.instantiateViewController(withIdentifier:"ExpandingMaterialViewController")
        controller?.modalPresentationStyle = .custom
        controller?.transitioningDelegate = self.materialInfoTransition
        self.present(controller!, animated: true, completion: nil)
        
        items = [("canvasPicture", "Холст художественный")]
      gottenSignal.canvasSignal = true
    }
    

    func DisableButton() {
        canvasAddToCartButton.setTitle("В корзину", for: .normal)
    }
    
    
    func EnableButton() {
        canvasAddToCartButton.setTitle("Добавить в корзину", for: .normal )
        canvasAddToCartButton.isUserInteractionEnabled = true
        canvasAddToCartButton.setTitleColor(UIColor.white, for: UIControlState.normal)
    }

    
    func updatePrices() {
        calculatePriceOfSelectedProduct()
        canvasPrice.text = currentPageData.price
        canvasNDSPrice.text = currentPageData.ndsPrice
        animateAddToCartButton()
    }

  
  func animateAddToCartButton() {
    
    if canvasPrice.text == "0" {
      
      UIView.animate(withDuration: 0.5, animations: {
        self.canvasAddToCartButton.alpha = 0.5 })
      canvasAddToCartButton.isEnabled  = false
      
    } else {
      
      canvasAddToCartButton.isEnabled = true
      UIView.animate(withDuration: 0.5, animations: {
        self.canvasAddToCartButton.alpha = 1.0 })
    }
  }
}


extension CanvasVC: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    UIView.animate(withDuration: 0.1, animations: { textField.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) }, completion: { (finish: Bool) in UIView.animate(withDuration: 0.1, animations: { textField.transform = CGAffineTransform.identity }) })
  }
}


extension CanvasVC: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // returns the # of rows in each component..
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        materialPicker.tag = 0
        postPrintPicker.tag = 1

      if pickerView.tag == 0 {
        
        return priceData.materialsDictionary.count
      }
      
      if pickerView.tag == 1 {
      
        return priceData.postPrintDictionary.count
      }
  
        return 1
    }
}


extension CanvasVC: UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    
    materialPicker.tag = 0
  //postPrintPicker.tag = 1

    if pickerView.tag == 0 {
      
      let pickerLabel = UILabel()
      pickerLabel.textColor = UIColor.white
      pickerLabel.text = priceData.materialsDictionary[row].title
      pickerLabel.font = UIFont.systemFont(ofSize: 17)
      pickerLabel.textAlignment = NSTextAlignment.center
      
      return pickerLabel
      
    } else {
      
      let pickerLabel = UILabel()
      pickerLabel.textColor = UIColor.white
      pickerLabel.text = priceData.postPrintDictionary[row].title
      pickerLabel.font = UIFont.systemFont(ofSize: 17)
      pickerLabel.textAlignment = NSTextAlignment.center
      
      return pickerLabel
      
    }
  }
  
  
  func validateLayoutSize(row: Int) {
    selectedMaterialRow = row
    
    if currentPageData.width.convertToDemicalIfItIsNot > priceData.materialsDictionary[row].maxMaterialWidth &&
      currentPageData.height.convertToDemicalIfItIsNot > priceData.materialsDictionary[row].maxMaterialWidth {
      
      let oversizeAlert = UIAlertController(title: "Превышен максимальный размер", message: "Максимальная ширина \(priceData.materialsDictionary[row].maxMaterialWidth)м", preferredStyle: UIAlertControllerStyle.actionSheet)
      
      let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
      
      oversizeAlert.addAction(okAction)
      
      self.present(oversizeAlert, animated: true, completion: nil)
      canvasWidthTextField.text = ""
      currentPageData.width = canvasWidthTextField.text!
      
      currentPageData.price = "0"
      currentPageData.ndsPrice = "0"
      
    }
  }
  
  
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        materialPicker.tag = 0
        postPrintPicker.tag = 1
      
      if pickerView.tag == 0 {
        
         validateLayoutSize(row: row)
         EnableButton()
         priceData.materialPrice = priceData.materialsDictionary[row].matPrice
         priceData.printPrice = priceData.materialsDictionary[row].printPrice
         updatePrices()
        
        return canvasMaterialTextField.text = priceData.materialsDictionary[row].title
      }
      
      if pickerView.tag == 1 { /*postprint(underframe selection)*/
        
          EnableButton()
          priceData.postPrintMaterialPrice = priceData.postPrintDictionary[row].materialCost
          priceData.postPrintWorkPrice = priceData.postPrintDictionary[row].costOfWork
            
          switch row {
            case 0 :
              currentPageData.withUnderframe = false
            case 1 :
              currentPageData.withUnderframe = true
            default: break
              
          }
      
          updatePrices()
        
          return canvasPostPrintTextField.text =  priceData.postPrintDictionary[row].title
  
        }
    }
}
