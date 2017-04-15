//
//  MainPageController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/1/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//


import UIKit
import JTMaterialTransition

 
class StickersVC: UIViewController {
    
    @IBOutlet weak var AboutMaterialsButton: UIButton!
    @IBOutlet weak var leftImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!

    @IBOutlet weak var betweenAmountAndMaterial: NSLayoutConstraint!
    @IBOutlet weak var betweenWidthAndMaterial: NSLayoutConstraint!
    @IBOutlet weak var betweenHeightAndMaterial: NSLayoutConstraint!
    @IBOutlet weak var betweenSizeAndPostPrint: NSLayoutConstraint!
    @IBOutlet weak var betweenPostPrintAndPrice: NSLayoutConstraint!
    
    @IBOutlet weak var stickersAmountTextField: HoshiTextField!
    @IBOutlet weak var stickersMaterialTextField: UITextField!
    @IBOutlet weak var stickersWidthTextField: HoshiTextField!
    @IBOutlet weak var stickersHeightTextField: HoshiTextField!
    @IBOutlet weak var stickersPostPrintTextField: UITextField!
    @IBOutlet weak var stickersPrice: UILabel!
    @IBOutlet weak var stickersNDSPrice: UILabel!
    @IBOutlet weak var stickersAddToCartButton: UIButton!
    
    var materialInfoTransition = JTMaterialTransition()
 
    var materialPicker = UIPickerView()
    
    var postPrintPicker = UIPickerView()
  
    let nameButt =  "В корзину"
  
    var selectedRow = Int()
  
    
    override func viewWillDisappear(_ animated: Bool) {
        leftImageViewConstraint.constant = 0
    }
  
  
    override func viewDidAppear(_ animated: Bool) {
        leftImageViewConstraint.constant = -25
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        fetchMaterialsAndPostprint(productType: "Stickers", onlyColdLamAllowed: true, onlyDefaultPrepressAllowed: false)
        managedObjextContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        applyMotionEffect(toView: backgroundImageView, magnitude: 25)
        
       
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
        stickersMaterialTextField.inputView = materialPicker
        stickersPostPrintTextField.inputView = postPrintPicker
        
        stickersMaterialTextField.text =  priceData.materialsDictionary[0].title//data[0]
        stickersPostPrintTextField.text = priceData.postPrintDictionary[0].title//postPrintData[0]
        
        stickersWidthTextField.delegate = self
        stickersHeightTextField.delegate = self
        stickersAmountTextField.delegate = self
        stickersMaterialTextField.delegate = self
        stickersPostPrintTextField.delegate = self
      
        setPickerTextFieldTint(sender: [stickersMaterialTextField, stickersPostPrintTextField])
        
        materialPicker.backgroundColor = UIColor.darkGray
        postPrintPicker.backgroundColor = UIColor.darkGray
        
          self.materialInfoTransition = JTMaterialTransition(animatedView: self.AboutMaterialsButton)

    }
    
    
    @IBAction func amountCursorPosChanged(_ sender: Any) {
        if ( stickersAmountTextField.text == nil) {
            currentPageData.amountIsEmpty = true
            updatePrices()
        } else {
            currentPageData.amountIsEmpty = false
            currentPageData.amount = stickersAmountTextField.text!
            
            updatePrices()
        }
        if stickersAddToCartButton.titleLabel?.text == nameButt {
            EnableButton()
        }

    }
    
    @IBAction func widthCursorPosChanged(_ sender: Any) {
        currentPageData.widthOrHeightIsEmpty = false
        currentPageData.width =  stickersWidthTextField.text!
      
        validateLayoutSize(row: selectedRow)

        updatePrices()
        if stickersAddToCartButton.titleLabel?.text == nameButt {
            EnableButton()
        }
        
    }
    @IBAction func heightCursorPosChanged(_ sender: Any) {
        currentPageData.widthOrHeightIsEmpty = false
        currentPageData.height = stickersHeightTextField.text!
      
        validateLayoutSize(row: selectedRow)

        updatePrices()
        if stickersAddToCartButton.titleLabel?.text == nameButt {
            EnableButton()
        }
        
    }
  
  
    @IBAction func AddToCart(_ sender: Any) {
        
        if stickersAddToCartButton.titleLabel?.text == nameButt {
            
            let destination = storyboard?.instantiateViewController(withIdentifier: "ShoppingCartVC") as! ShoppingCartVC
            let navigationController = UINavigationController(rootViewController: destination)
            
            
            
            navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            navigationController.isNavigationBarHidden = true
            self.present(navigationController, animated: true, completion: nil)
            
        } else {
            let newItem = AddedItems(context: managedObjextContext)
            
            newItem.list = ("Тираж: \(stickersAmountTextField.text!) шт.\nМатериал: \(stickersMaterialTextField.text!)\nРазмер: \(stickersWidthTextField.text!) .м. x \(stickersHeightTextField.text!) м.\nПостпечатные работы: \(stickersPostPrintTextField.text!)" )
            
            newItem.price = (stickersPrice.text!)
            newItem.ndsPrice = (stickersNDSPrice.text!)
            
            do {
                try managedObjextContext.save()
            }catch {
                print("Could not save data \(error.localizedDescription)")
            }
            
            updateBadgeValue()
            DisableButton()
            stickersAddToCartButton.frame.size.width = 75
            
        }
    }
    
  
    @IBAction func openInfoAboutMaterials(_ sender: Any) {
        resetTableView ()
      
        let controller = storyboard?.instantiateViewController(withIdentifier:"ExpandingMaterialViewController")
        controller?.modalPresentationStyle = .custom
        controller?.transitioningDelegate = self.materialInfoTransition
        self.present(controller!, animated: true, completion: nil)
        
        items = [ ("transparentOracalPicture", "Пленка самокл. прозрачная"), ("whiteStickerPicture", "Пленка самокл. белая"),("onewayvisionPicture", "One Way Vision")]
      gottenSignal.stickersSignal = true
    }
    

    
    //MARK: HELPER FUNCTIONS
    func DisableButton() {
          stickersAddToCartButton.setTitle("В корзину", for: .normal)
    }
    
    func EnableButton() {
        stickersAddToCartButton.setTitle("Добавить в корзину", for: .normal )
        stickersAddToCartButton.isUserInteractionEnabled = true
        stickersAddToCartButton.setTitleColor(UIColor.white, for: UIControlState.normal)
    }
    
    func closeKeyboard() {
        self.view.endEditing(true)
    }
  
    
    //MARK: Touch Events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closeKeyboard()
    }
    
    //MARK: DEPENDS ON SIZE AMOUNT AND WHICH ELEMENTS WERE SELECTED, PRICES UPDATE
    func updatePrices() {
       
        calculatePriceOfSelectedProduct()
        stickersPrice.text = currentPageData.price
        stickersNDSPrice.text = currentPageData.ndsPrice
        animateAddToCartButton()
      
    }
  
  
  func animateAddToCartButton () {
    
    if stickersPrice.text == "0" {
      
      UIView.animate(withDuration: 0.5, animations: {
        self.stickersAddToCartButton.alpha = 0.5 })
      stickersAddToCartButton.isEnabled  = false
      
    } else {
      
      stickersAddToCartButton.isEnabled = true
      UIView.animate(withDuration: 0.5, animations: {
        self.stickersAddToCartButton.alpha = 1.0 })
    }
  }
  
}


extension StickersVC: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
  
    // returns the # of rows in each component..
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        materialPicker.tag = 0
        postPrintPicker.tag = 1
        
        if pickerView.tag == 0 {
            return priceData.materialsDictionary.count
        } else if pickerView.tag == 1 {
            return priceData.postPrintDictionary.count
        }
        return 1
    }
}


extension StickersVC: UIPickerViewDelegate {
  
  
    func validateLayoutSize(row: Int) {
      selectedRow = row
  
      if currentPageData.width.convertToDemicalIfItIsNot > priceData.materialsDictionary[row].maxMaterialWidth &&
        currentPageData.height.convertToDemicalIfItIsNot > priceData.materialsDictionary[row].maxMaterialWidth {
  
        let oversizeAlert = UIAlertController(title: "Превышен максимальный размер", message: "Максимальная ширина \(priceData.materialsDictionary[row].maxMaterialWidth)м",
          preferredStyle: UIAlertControllerStyle.actionSheet)
  
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
  
        oversizeAlert.addAction(okAction)
  
  
        self.present(oversizeAlert, animated: true, completion: nil)
        stickersWidthTextField.text = ""
        currentPageData.width = stickersWidthTextField.text!
  
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
      return stickersMaterialTextField.text = priceData.materialsDictionary[row].title//data[row]
            
            
        } else if pickerView.tag == 1 {
          
          EnableButton()
          
          priceData.postPrintMaterialPrice = priceData.postPrintDictionary[row].materialCost
          priceData.postPrintWorkPrice = priceData.postPrintDictionary[row].costOfWork

          
             updatePrices()
      return stickersPostPrintTextField.text = priceData.postPrintDictionary[row].title//postPrintData[row]
    }
  }
    
  
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
         materialPicker.tag = 0
         postPrintPicker.tag = 1
        
        if pickerView.tag == 0 {
            let pickerLabel = UILabel()
            pickerLabel.textColor = UIColor.white
            pickerLabel.text = priceData.materialsDictionary[row].title//data[row]
            pickerLabel.font = UIFont.systemFont(ofSize: 16)
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
        } else {
            let pickerLabel = UILabel()
            pickerLabel.textColor = UIColor.white
            pickerLabel.text = priceData.postPrintDictionary[row].title // postPrintData[row]
            pickerLabel.font = UIFont.systemFont(ofSize: 16)
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
        }
    }
}


extension StickersVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1, animations: { textField.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) }, completion: { (finish: Bool) in UIView.animate(withDuration: 0.1, animations: { textField.transform = CGAffineTransform.identity }) })
    }
}
