//
//  postersMaterialPage.swift
//  CustomSlideMenu
//
//  Created by Roman Mizin on 12/3/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.



import UIKit


class postersVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
     
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var leftImageViewConstraint: NSLayoutConstraint!
    //CONSTRAINTS
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var betweenAmountAndMaterial: NSLayoutConstraint!
    @IBOutlet weak var betweenWidthAndMaterial: NSLayoutConstraint!
    @IBOutlet weak var betweenHeightAndMaterial: NSLayoutConstraint!
    @IBOutlet weak var betweenSizeAndPostPrint: NSLayoutConstraint!
    @IBOutlet weak var betweenPostPrintAndPrice: NSLayoutConstraint!
    
    
    @IBOutlet var postersAmountTextField: HoshiTextField!
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
    let nameButt =  "В корзину"
    
    let aqua =  UIColor.init(red: 0.0/255.0, green: 140.0/255.0, blue: 255.0/255.0, alpha: 0.75)
    let snowColor =  UIColor(red: 255.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0/0.5)
    
   
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

    
    
    var data = ["Выберите материал...","CityLight Premium 140g/m2","Lomond Photo Paper 140g/m2","Фотобумага глянец/мат 200g/m2"]
    var postPrintData = ["Без постпечати","Припрес глянец 1+0","Припрес мат 1+0","Припрес глянец 1+1", "Припрес мат 1+1"]
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
        
        postersMaterialTextField.delegate = self
        postersPostPrintTextField.delegate = self
        postersAmountTextField.delegate = self
        postersWidthTextField.delegate = self
        postersHeightTextField.delegate = self
        
        postersMaterialTextField.inputView = materialPicker
        postersPostPrintTextField.inputView = postPrintPicker
        
        postersMaterialTextField.text = data[0]
        postersPostPrintTextField.text = postPrintData[0]
    
        oversizeAlert.addAction(okAction)
        oversizeAlertSmall.addAction(okAction)

        setPickerTextFieldTint(sender: [postersMaterialTextField, postersPostPrintTextField])
    }
    
   
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1, animations: { textField.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) }, completion: { (finish: Bool) in UIView.animate(withDuration: 0.1, animations: { textField.transform = CGAffineTransform.identity }) })
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
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // returns the # of rows in each component..
   
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        materialPicker.tag = 0
        postPrintPicker.tag = 1
        
        if pickerView.tag == 0 {
             return data.count
        } else if pickerView.tag == 1 {
            return postPrintData.count
        }
        return 1
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        materialPicker.tag = 0
        postPrintPicker.tag = 1
        
      
        
        if pickerView.tag == 0 {
            EnableButton()
            
            
            
            if row == 0 { print("didnotChosen");
                postersBoolVariables.materialDidnNotChosen = true
                postersBoolVariables.cityC = false
                postersBoolVariables.lomondC = false
                postersBoolVariables.photoC = false
              //  postersAddToCartButton.isEnabled = false
 
                computings()
                postersPrice.text = postersBoolVariables.priceToLabel
                postersNDSPrice.text = postersBoolVariables.ndsPriceToLabel
                updatePrices()
               


                
            }
            
            if row == 1 { print("city");  postersBoolVariables.materialDidnNotChosen = false
                                          postersBoolVariables.cityC = true
                                          postersBoolVariables.lomondC = false
                                          postersBoolVariables.photoC = false
                                        //  errorsCheck()
                                          computings()
                postersPrice.text = postersBoolVariables.priceToLabel
                postersNDSPrice.text = postersBoolVariables.ndsPriceToLabel
                
            
            }
            
            if row == 2 { print("lomond"); postersBoolVariables.materialDidnNotChosen = false
                                           postersBoolVariables.cityC = false
                                           postersBoolVariables.lomondC = true
                                           postersBoolVariables.photoC = false
                                           //errorsCheck()
                                           computings()
                postersPrice.text = postersBoolVariables.priceToLabel
                postersNDSPrice.text = postersBoolVariables.ndsPriceToLabel}
            
            if row == 3 { print("photo"); postersBoolVariables.materialDidnNotChosen = false
                                          postersBoolVariables.cityC = false
                                          postersBoolVariables.lomondC = false
                                          postersBoolVariables.photoC = true
                                           // errorsCheck()
                                            computings()
                postersPrice.text = postersBoolVariables.priceToLabel
                postersNDSPrice.text = postersBoolVariables.ndsPriceToLabel}
            
          updatePrices()
        return postersMaterialTextField.text = data[row]
    
            
        } else if pickerView.tag == 1 {
            EnableButton()
            
            
            if row == 0 { print("without post print");
                postersBoolVariables.withoutPostPrint = true
                postersBoolVariables.gloss1_0C = false
                postersBoolVariables.matt1_0C = false
                postersBoolVariables.gloss1_1C = false
                postersBoolVariables.matt1_1C = false
            computings()
                postersPrice.text = postersBoolVariables.priceToLabel
                postersNDSPrice.text = postersBoolVariables.ndsPriceToLabel}
            
            if row == 1 { print("gloss1_0");
                postersBoolVariables.withoutPostPrint = false
                postersBoolVariables.gloss1_0C = true
                postersBoolVariables.matt1_0C = false
                postersBoolVariables.gloss1_1C = false
                postersBoolVariables.matt1_1C = false
                computings()
                postersPrice.text = postersBoolVariables.priceToLabel
                postersNDSPrice.text = postersBoolVariables.ndsPriceToLabel}
            
            if row == 2 { print("mat1_0");
                postersBoolVariables.withoutPostPrint = false
                postersBoolVariables.gloss1_0C = false
                postersBoolVariables.matt1_0C = true
                postersBoolVariables.gloss1_1C = false
                postersBoolVariables.matt1_1C = false
                computings()
                postersPrice.text = postersBoolVariables.priceToLabel
                postersNDSPrice.text = postersBoolVariables.ndsPriceToLabel}
            
            if row == 3 { print("gloss1_1");
                postersBoolVariables.withoutPostPrint = false
                postersBoolVariables.gloss1_0C = false
                postersBoolVariables.matt1_0C = false
                postersBoolVariables.gloss1_1C = true
                postersBoolVariables.matt1_1C = false
                computings()
                postersPrice.text = postersBoolVariables.priceToLabel
                postersNDSPrice.text = postersBoolVariables.ndsPriceToLabel}
            
            if row == 4 { print("mat1_1");
                postersBoolVariables.withoutPostPrint = false
                postersBoolVariables.gloss1_0C = false
                postersBoolVariables.matt1_0C = false
                postersBoolVariables.gloss1_1C = false
                postersBoolVariables.matt1_1C = true
                computings()
                postersPrice.text = postersBoolVariables.priceToLabel
                postersNDSPrice.text = postersBoolVariables.ndsPriceToLabel}



            
            updatePrices()
           return postersPostPrintTextField.text = postPrintData[row]
        }
       
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        materialPicker.tag = 0
        postPrintPicker.tag = 1
        
    
        
        
        if pickerView.tag == 0 {
           return data[row]
            
        } else if pickerView.tag == 1 {
            return postPrintData[row]
        }
        
      return ""
    }
    
    
    
    //MARK: HELPER FUNCTIONS
    func DisableButton() {
            postersAddToCartButton.setTitle("В корзину", for: .normal)
           }
    
   func EnableButton() {
    postersAddToCartButton.setTitle("Добавить в корзину", for: .normal )
    postersAddToCartButton.isUserInteractionEnabled = true
    postersAddToCartButton.backgroundColor = aqua
    postersAddToCartButton.setTitleColor(UIColor.white, for: UIControlState.normal)
    }
    
    func errorsCheck() {
        if  ( postersMaterialTextField.text == data[0] ) {
            
        } else if (postersMaterialTextField.text == data[1] && postersBoolVariables.postersWidthSet.doubleValue > 1.59 && postersBoolVariables.postersHeightSet.doubleValue > 1.59) {
            
            self.present(oversizeAlert, animated: true, completion: nil)
            postersWidthTextField.text = ""
            postersBoolVariables.postersWidthSet = postersWidthTextField.text!
            updatePrices()
            
            
        } else if ( (postersMaterialTextField.text == data[2] || postersMaterialTextField.text == data[3]) && postersBoolVariables.postersWidthSet.doubleValue > 0.6 && postersBoolVariables.postersHeightSet.doubleValue > 0.6 ) {
            self.present(oversizeAlertSmall, animated: true, completion: nil)
            postersWidthTextField.text = ""
            postersBoolVariables.postersWidthSet = postersWidthTextField.text!
            updatePrices()

        }
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
