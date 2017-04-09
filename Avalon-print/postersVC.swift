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

 class postersVC: UIViewController {

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
  
    let oversizeAlert = UIAlertController(title: "Превышен максимальный размер", message: "Максимальная ширина 1.59м", preferredStyle: UIAlertControllerStyle.actionSheet)
    
    let oversizeAlertSmall = UIAlertController(title: "Превышен максимальный размер", message: "Максимальная ширина 0.6м", preferredStyle: UIAlertControllerStyle.actionSheet)
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
    
    
    override func viewWillDisappear(_ animated: Bool) {
        leftImageViewConstraint.constant = 0
    }
   
    override func viewDidAppear(_ animated: Bool) {
         leftImageViewConstraint.constant = -25
    }
  
 
    override  func viewDidLoad() {
        super.viewDidLoad()
      
        fetchMaterialsAndPostprint(productType: "Posters", postprintTypes: "")
  
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
        
        postersMaterialTextField.text = materialsDictionary[0].title
        postersPostPrintTextField.text = postPrintDictionary[0].title
    
        oversizeAlert.addAction(okAction)
        oversizeAlertSmall.addAction(okAction)

        setPickerTextFieldTint(sender: [postersMaterialTextField, postersPostPrintTextField])
        
        materialPicker.backgroundColor = UIColor.darkGray
        postPrintPicker.backgroundColor = UIColor.darkGray
      
    }
   
    

    @IBAction func amountCursorPosChanged(_ sender: Any) {
        if ( postersAmountTextField.text == nil) {
            postersBoolVariables.amountDidNotInputed = true
            updatePrices()
        } else {
            postersBoolVariables.amountDidNotInputed = false
            postersBoolVariables.amount = postersAmountTextField.text!
           
            updatePrices()
        }
        
        if postersAddToCartButton.titleLabel?.text == nameButt {
            EnableButton()
        }
        
    }
  
    @IBAction func widthCursorPosChanged(_ sender: Any) {
        postersBoolVariables.postersWidhOrHeightDidNotInputed = false
        postersBoolVariables.postersWidthSet =  postersWidthTextField.text!
              errorsCheck()
              updatePrices()
        if postersAddToCartButton.titleLabel?.text == nameButt {
            EnableButton()
        }
    
    }
    
    @IBAction func heightCursorPosChanged(_ sender: Any) {
        postersBoolVariables.postersWidhOrHeightDidNotInputed = false
     
        postersBoolVariables.postersHeightSet = postersHeightTextField.text!
        errorsCheck()
        updatePrices()
        if postersAddToCartButton.titleLabel?.text == nameButt {
            EnableButton()
        }
       
    }
    
    @IBAction func AddToCart(_ sender: Any) {
        
        if postersAddToCartButton.titleLabel?.text == nameButt {
            
            let destination = storyboard?.instantiateViewController(withIdentifier: "shoppingCartVC") as! shoppingCartVC
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
        resetTableView ()
      
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
  
  
    func errorsCheck() {
//        if  ( postersMaterialTextField.text == data[0] ) {
//            
//        } else if (postersMaterialTextField.text == data[1] && postersBoolVariables.postersWidthSet.convertToDemicalIfItIsNot > 1.591 && postersBoolVariables.postersHeightSet.convertToDemicalIfItIsNot > 1.591) {
//            
//            self.present(oversizeAlert, animated: true, completion: nil)
//            postersWidthTextField.text = ""
//            postersBoolVariables.postersWidthSet = postersWidthTextField.text!
//            updatePrices()
//            
//            
//        } else if ( (postersMaterialTextField.text == data[2] || postersMaterialTextField.text == data[3]) && postersBoolVariables.postersWidthSet.convertToDemicalIfItIsNot > 0.61 && postersBoolVariables.postersHeightSet.convertToDemicalIfItIsNot > 0.61 ) {
//            self.present(oversizeAlertSmall, animated: true, completion: nil)
//            postersWidthTextField.text = ""
//            postersBoolVariables.postersWidthSet = postersWidthTextField.text!
//            updatePrices()
//
//        }
    }
    
    //MARK: DEPENDS ON SIZE AMOUNT AND WHICH ELEMENTS WERE SELECTED, PRICES UPDATE
    func updatePrices() {
        computings()
        postersPrice.text = postersBoolVariables.priceToLabel
        postersNDSPrice.text = postersBoolVariables.ndsPriceToLabel
        
        if postersPrice.text == "0" {
            
            UIView.animate(withDuration: 0.5, animations: {
                self.postersAddToCartButton.alpha = 0.5 })

            postersAddToCartButton.isEnabled  = false

        } else {
             postersAddToCartButton.isEnabled = true
            
            UIView.animate(withDuration: 0.5, animations: {
                self.postersAddToCartButton.alpha = 1.0 })

        }
    }
}


extension postersVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1, animations: { textField.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) }, completion: { (finish: Bool) in UIView.animate(withDuration: 0.1, animations: { textField.transform = CGAffineTransform.identity }) })
    }
    
}


extension postersVC: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        materialPicker.tag = 0
        postPrintPicker.tag = 1
        
        if pickerView.tag == 0 {
            return materialsDictionary.count
          
          
        } else if pickerView.tag == 1 {
            return  postPrintDictionary.count
        }
        return 1
    }
    
}


extension postersVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        materialPicker.tag = 0
        postPrintPicker.tag = 1
        
        if pickerView.tag == 0 {
          
            let pickerLabel = UILabel()
            pickerLabel.textColor = UIColor.white
            pickerLabel.text = materialsDictionary[row].title
            pickerLabel.font = UIFont.systemFont(ofSize: 17)
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
        } else {
            let pickerLabel = UILabel()
            pickerLabel.textColor = UIColor.white
            pickerLabel.text = postPrintDictionary[row].title
            pickerLabel.font = UIFont.systemFont(ofSize: 17)
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
        }
    }
    
  
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         materialPicker.tag = 0
         postPrintPicker.tag = 1

        
        if pickerView.tag == 0 {
          
            EnableButton()
          
            priceData.materialPrice = materialsDictionary[row].matPrice
            priceData.printPrice = materialsDictionary[row].printPrice
          
               updatePrices()
        return postersMaterialTextField.text = materialsDictionary[row].title
            
            
        } else if pickerView.tag == 1 {
          
          EnableButton()
  
          priceData.postPrintMaterialPrice = postPrintDictionary[row].materialCost
          priceData.postPrintWorkPrice = postPrintDictionary[row].costOfWork
          
               updatePrices()
        return postersPostPrintTextField.text =  postPrintDictionary[row].title
          
        }
    }
}
