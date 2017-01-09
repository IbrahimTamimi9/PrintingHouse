//
//  postersMaterialPage.swift
//  CustomSlideMenu
//
//  Created by Roman Mizin on 12/3/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.



import UIKit
import CoreData


class postersVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    
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
    
    let nameButt =  "В корзину"
    let materialGreen =  UIColor.init(red: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255.0, alpha: 1.0)
   
    @IBAction func AddToCart(_ sender: Any) {
        
        
      
        
        if postersAddToCartButton.titleLabel?.text == nameButt {
             // dismiss(animated: true, completion: nil)
            

            let destination = storyboard?.instantiateViewController(withIdentifier: "bucket") as! bucket
            let navigationController = UINavigationController(rootViewController: destination)
            
            
           
            navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            navigationController.isNavigationBarHidden = true
            self.present(navigationController, animated: true, completion: nil)
            
            
        } else {
        
        list.append("Тираж: \(postersAmountTextField.text!) шт.\nМатериал: \(postersMaterialTextField.text!)\nРазмер: \(postersWidthTextField.text!) .м. x \(postersHeightTextField.text!) м.\nПостпечатные работы: \(postersPostPrintTextField.text!)" )
        price.append(postersPrice.text!)
        ndsPrice.append(postersNDSPrice.text!)
        DisableButton()
        rightBarButton?.badgeValue = "\(price.count)"
       
        postersAddToCartButton.frame.size.width = 75
            
            bucketDefaults.removeObject(forKey: "ListStringArray")
            bucketDefaults.removeObject(forKey: "PriceStringArray")
            bucketDefaults.removeObject(forKey: "NdsPriceStringArray")
            bucketDefaults.synchronize()
            
            bucketDefaults.set(list, forKey: "ListStringArray")
            bucketDefaults.set(price, forKey: "PriceStringArray")
            bucketDefaults.set(ndsPrice, forKey: "NdsPriceStringArray")
        }
    }
    
    

    
    var data = ["Выберите материал...","CityLight Premium 140g/m2","Lomond Photo Paper 140g/m2","Фотобумага глянец/мат 200g/m2"]
    var postPrintData = ["Без постпечати","Припрес глянец 1+0","Припрес мат 1+0","Припрес глянец 1+1", "Припрес мат 1+1"]
    var materialPicker = UIPickerView()
    var postPrintPicker = UIPickerView()
    
    let oversizeAlert = UIAlertController(title: "Превышен максимальный размер", message: "Максимальная ширина 1.59м", preferredStyle: UIAlertControllerStyle.actionSheet)
    
    let oversizeAlertSmall = UIAlertController(title: "Превышен максимальный размер", message: "Максимальная ширина 0.6м", preferredStyle: UIAlertControllerStyle.actionSheet)
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
    
    
    

    
    override  func viewDidLoad() {
        super.viewDidLoad()
      
        
        
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
        postersMaterialTextField.inputView = materialPicker
        postersPostPrintTextField.inputView = postPrintPicker
       
        postersMaterialTextField.text = data[0]
        postersPostPrintTextField.text = postPrintData[0]
        
       // postersAmountTextField.len
        
    
        oversizeAlert.addAction(okAction)
        oversizeAlertSmall.addAction(okAction)
        
        postersAddToCartButton.isUserInteractionEnabled  = false
        postersAddToCartButton.backgroundColor = UIColor.darkGray
        postersAddToCartButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        
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
               // postersAddToCartButton.isUserInteractionEnabled  = false
       // postersAddToCartButton.backgroundColor = UIColor.darkGray
      //  postersAddToCartButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        //postersAddToCartButton.titleLabel!.text = "567"
        postersAddToCartButton.setTitle("В корзину", for: .normal)
       
           }
    
   func EnableButton() {
    //postersAddToCartButton.titleLabel?.text = "Добавить в корзину"
     postersAddToCartButton.setTitle("Добавить в корзину", for: .normal )
    
    postersAddToCartButton.isUserInteractionEnabled = true
    postersAddToCartButton.backgroundColor = materialGreen
    postersAddToCartButton.setTitleColor(UIColor.white, for: UIControlState.normal)
    
    
    
    }
    
    func closeKeyboard() {
        self.view.endEditing(true)
          errorsCheck()
        
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
    
    
    //MARK: Touch Events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        closeKeyboard()
        

    }
    
    //MARK: DEPENDS ON SIZE AMOUNT AND WHICH ELEMENTS WERE SELECTED, PRICES UPDATE
    func updatePrices() {
        computings()
        postersPrice.text = postersBoolVariables.priceToLabel
        postersNDSPrice.text = postersBoolVariables.ndsPriceToLabel
        
        if postersPrice.text == "0" {
            postersAddToCartButton.isUserInteractionEnabled  = false
            postersAddToCartButton.backgroundColor = UIColor.darkGray
            postersAddToCartButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)

        } else {
             postersAddToCartButton.isUserInteractionEnabled = true
             postersAddToCartButton.backgroundColor = materialGreen
             postersAddToCartButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        }
        
    }
    
}
