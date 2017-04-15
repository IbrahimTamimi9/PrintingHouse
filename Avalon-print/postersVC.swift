//
//  postersMaterialPage.swift
//  CustomSlideMenu
//
//  Created by Roman Mizin on 12/3/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.


import UIKit
import Firebase
import JTMaterialTransition
import FirebaseDatabase

 class PostersVC: UIViewController {
 
    @IBOutlet weak var AboutMaterialsButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var leftImageViewConstraint: NSLayoutConstraint!
    //CONSTRAINTS
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var betweenAmountAndMaterial: NSLayoutConstraint!
    @IBOutlet weak var betweenWidthAndMaterial: NSLayoutConstraint!
    @IBOutlet weak var betweenHeightAndMaterial: NSLayoutConstraint!
    @IBOutlet weak var betweenSizeAndPostPrint: NSLayoutConstraint!
    @IBOutlet weak var betweenPostPrintAndPrice: NSLayoutConstraint!
    
    @IBOutlet weak var postersAmountTextField: HoshiTextField!
    @IBOutlet weak var postersMaterialTextField: UITextField!
    @IBOutlet weak var postersWidthTextField: UITextField!
    @IBOutlet weak var postersHeightTextField: UITextField!
    @IBOutlet weak var postersPostPrintTextField: UITextField!
    @IBOutlet weak var postersPrice: UILabel!
    @IBOutlet weak var postersNDSPrice: UILabel!
    @IBOutlet weak var postersAddToCartButton: UIButton!
    
    @IBOutlet weak var ndsGrnLabel: UILabel!
    @IBOutlet weak var grnLabel: UILabel!
    @IBOutlet weak var ndsPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var xLetter: UILabel!
    let nameButt = "В корзину"
    
    var materialInfoTransition = JTMaterialTransition()
  
    var materialPicker = UIPickerView()
    var postPrintPicker = UIPickerView()
    var selectedMaterialRow = Int()

    
    override func viewWillDisappear(_ animated: Bool) {
        leftImageViewConstraint.constant = 0
    }
  
  
    override func viewDidAppear(_ animated: Bool) {
         leftImageViewConstraint.constant = -25
    }
  
 
    override  func viewDidLoad() {
        super.viewDidLoad()
      
            fetchMaterialsAndPostprint(productType: "Posters", onlyColdLamAllowed: false, onlyDefaultPrepressAllowed: true)
  
            managedObjextContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
            applyMotionEffect(toView: backgroundImageView, magnitude: 25)
            self.hideKeyboardWhenTappedAround()
            self.materialInfoTransition = JTMaterialTransition(animatedView: self.AboutMaterialsButton)
        
        
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
        
        postersMaterialTextField.delegate = self
        postersPostPrintTextField.delegate = self
        postersAmountTextField.delegate = self
        postersWidthTextField.delegate = self
        postersHeightTextField.delegate = self
        
        postersMaterialTextField.inputView = materialPicker
        postersPostPrintTextField.inputView = postPrintPicker
        
        postersMaterialTextField.text = priceData.materialsDictionary[0].title
        postersPostPrintTextField.text = priceData.postPrintDictionary[0].title

        setPickerTextFieldTint(sender: [postersMaterialTextField, postersPostPrintTextField])
        
        materialPicker.backgroundColor = UIColor.darkGray
        postPrintPicker.backgroundColor = UIColor.darkGray
      
    }
   
  
    @IBAction func amountCursorPosChanged(_ sender: Any) {
        if ( postersAmountTextField.text == nil) {
            currentPageData.amountIsEmpty = true
            updatePrices()
        } else {
            currentPageData.amountIsEmpty = false
            currentPageData.amount = postersAmountTextField.text!
           
            updatePrices()
        }
        
        if postersAddToCartButton.titleLabel?.text == nameButt {
            EnableButton()
        }
    }
  
  
    @IBAction func widthCursorPosChanged(_ sender: Any) {
        currentPageData.widthOrHeightIsEmpty = false
        currentPageData.width =  postersWidthTextField.text!
      
        validateLayoutSize(row: selectedMaterialRow)
      
        updatePrices()
      
        if postersAddToCartButton.titleLabel?.text == nameButt {
            EnableButton()
        }
    }
  
    
    @IBAction func heightCursorPosChanged(_ sender: Any) {
        currentPageData.widthOrHeightIsEmpty = false
        currentPageData.height = postersHeightTextField.text!
      
        validateLayoutSize(row: selectedMaterialRow)
      
        updatePrices()
      
        if postersAddToCartButton.titleLabel?.text == nameButt {
            EnableButton()
        }
    }
  
    
    @IBAction func AddToCart(_ sender: Any) {
        
        if postersAddToCartButton.titleLabel?.text == nameButt {
            
            let destination = storyboard?.instantiateViewController(withIdentifier: "ShoppingCartVC") as! ShoppingCartVC
            let navigationController = UINavigationController(rootViewController: destination)
            
            navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            navigationController.isNavigationBarHidden = true
            
            self.present(navigationController, animated: true, completion: nil)
            
        } else {
            
            let newItem = AddedItems(context: managedObjextContext)
            
            newItem.list = ("Тираж: \(postersAmountTextField.text!) шт.\nМатериал: \(postersMaterialTextField.text!)\nРазмер: \(postersWidthTextField.text!) .м. x \(postersHeightTextField.text!) м.\nПостпечатные работы: \(postersPostPrintTextField.text!)" )
            
            newItem.price = (postersPrice.text!)
            newItem.ndsPrice = (postersNDSPrice.text!)
            
            do {
                try managedObjextContext.save()
            }catch {
                print("Could not save data \(error.localizedDescription)")
            }
            
            updateBadgeValue()
            DisableButton()
            postersAddToCartButton.frame.size.width = 75
        }
    }
  
    
    @IBAction func openInfoAboutMaterials(_ sender: Any) {
        resetTableView()
      
        let controller = storyboard?.instantiateViewController(withIdentifier:"ExpandingMaterialViewController")
        controller?.modalPresentationStyle = .custom
        controller?.transitioningDelegate = self.materialInfoTransition
        self.present(controller!, animated: true, completion: nil)
        
        items = [("citylightPicture", "CityLight"),("lomondPicture", "Lomond"),("photoPPictue", "Photo Paper 200g")]
        gottenSignal.postersSignal = true
    }

    
    //MARK: HELPER FUNCTIONS
    func DisableButton() {
            postersAddToCartButton.setTitle("В корзину", for: .normal)
    }
  
  
   func EnableButton() {
    postersAddToCartButton.setTitle("Добавить в корзину", for: .normal )
    postersAddToCartButton.isUserInteractionEnabled = true
    postersAddToCartButton.setTitleColor(UIColor.white, for: UIControlState.normal)
  }
  
  
    //MARK: DEPENDS ON SIZE AMOUNT AND WHICH ELEMENTS WERE SELECTED, PRICES UPDATE
    func updatePrices() {
     
        calculatePriceOfSelectedProduct()
        postersPrice.text = currentPageData.price
        postersNDSPrice.text = currentPageData.ndsPrice
        animateAddToCartButton()
      
    }
  
    func animateAddToCartButton() {
    
      if postersPrice.text == "0" {
      
        UIView.animate(withDuration: 0.5, animations: {
          self.postersAddToCartButton.alpha = 0.5 })
          postersAddToCartButton.isEnabled  = false
      
      } else {
      
        UIView.animate(withDuration: 0.5, animations: {
          self.postersAddToCartButton.alpha = 1.0 })
          postersAddToCartButton.isEnabled = true
    }
    
  }
}


extension PostersVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1, animations: { textField.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) }, completion: { (finish: Bool) in UIView.animate(withDuration: 0.1, animations: { textField.transform = CGAffineTransform.identity }) })
    }
    
}


extension PostersVC: UIPickerViewDataSource {
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


extension PostersVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        materialPicker.tag = 0
        postPrintPicker.tag = 1
        
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
      postersWidthTextField.text = ""
      currentPageData.width = postersWidthTextField.text!
      
      currentPageData.price = "0"
      currentPageData.ndsPrice = "0"

    }
  }
  
  
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         materialPicker.tag = 0
         postPrintPicker.tag = 1

        
        if pickerView.tag == 0 /* Materials */ {
          
            validateLayoutSize(row: row)
          
            EnableButton()
          
            priceData.materialPrice = priceData.materialsDictionary[row].matPrice
            priceData.printPrice = priceData.materialsDictionary[row].printPrice
          
            updatePrices()
          
        return postersMaterialTextField.text = priceData.materialsDictionary[row].title
            
            
        } else if pickerView.tag == 1 /* Postprint */ {
          
          EnableButton()
  
          priceData.postPrintMaterialPrice = priceData.postPrintDictionary[row].materialCost
          priceData.postPrintWorkPrice = priceData.postPrintDictionary[row].costOfWork
          
               updatePrices()
        return postersPostPrintTextField.text =  priceData.postPrintDictionary[row].title
          
        }
    }
}
