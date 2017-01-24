//
//  MainPageController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/1/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//


import UIKit
import JTMaterialTransition


class canvasVC: UIViewController {
    
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
    
    let standartSizeTextField = UITextField()
    
    let nameButt =  "В корзину"
    
    let oversizeAlert = UIAlertController(title: "Превышен максимальный размер", message: "Максимальная ширина 1.50м", preferredStyle: UIAlertControllerStyle.actionSheet)
    
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)

    
    var standartSizesdata = ["Выберите размер...","600х900мм","500х700мм","400х500мм","300х400мм","200х300мм"]
    
    var postPrintData = ["Без подрамника","С подрамником"]
    
    var standartSizesPicker = UIPickerView()
    
    var postPrintPicker = UIPickerView()
    
    var materialInfoTransition = JTMaterialTransition()
    


    override func viewWillDisappear(_ animated: Bool) {
        leftImageViewConstraint.constant = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        leftImageViewConstraint.constant = -25
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
         applyMotionEffect(toView: backgroundImageView, magnitude: 25)
         self.hideKeyboardWhenTappedAround()
        
        
         var standartSizeTextFieldYPos: CGFloat = 0.0
         var standartSizeTextFieldXPos: CGFloat = 0.0
         var standartSizeTextFieldWidth: CGFloat = 0.0
        // //MARK: iPhone 5/5c/5s/se
        if screenSize.height == 568 {
            topConstraint.constant = 30
            betweenAmountAndMaterial.constant = 50
            betweenWidthAndMaterial.constant = 20
            betweenHeightAndMaterial.constant = 20
            betweenSizeAndPostPrint.constant = 50
            betweenPostPrintAndPrice.constant = 40
            
             //temporary settings
            standartSizeTextFieldYPos = 212
            standartSizeTextFieldWidth = 269
            standartSizeTextFieldXPos = 25
        }
        if screenSize.height == 667 {
            
             //temporary settings
            standartSizeTextFieldYPos = 250
            standartSizeTextFieldWidth = 324
            standartSizeTextFieldXPos = 25
        }
        
        //MARK: iPhone 6+/7+
        if screenSize.height == 736 {
            topConstraint.constant = 40
            betweenAmountAndMaterial.constant = 70
            betweenWidthAndMaterial.constant = 40
            betweenHeightAndMaterial.constant = 40
            betweenSizeAndPostPrint.constant = 70
            betweenPostPrintAndPrice.constant = 60
            
            //temporary settings
            standartSizeTextFieldYPos = 260
            standartSizeTextFieldWidth = 355
            standartSizeTextFieldXPos = 29
            
        }
        //standart sizes textfield settings
        //temporary settings
        standartSizeTextField.frame =  CGRect(x: standartSizeTextFieldXPos, y: standartSizeTextFieldYPos , width: standartSizeTextFieldWidth, height: canvasMaterialTextField.frame.height)
        standartSizeTextField.borderStyle = UITextBorderStyle.roundedRect
        //standartSizeTextField.alpha = 0.7
        standartSizeTextField.isUserInteractionEnabled = false
        standartSizeTextField.alpha = 0
        standartSizeTextField.font = UIFont(name: "HelveticaNeue", size: 14)
        self.view.addSubview(standartSizeTextField)
        //======
        
        standartSizesPicker.delegate = self
        standartSizesPicker.dataSource = self
        postPrintPicker.delegate = self
        postPrintPicker.dataSource = self
        standartSizeTextField.inputView = standartSizesPicker
        canvasPostPrintTextField.inputView = postPrintPicker
        
        
        standartSizeTextField.text = standartSizesdata[0]
        canvasPostPrintTextField.text = postPrintData[0]
        
        oversizeAlert.addAction(okAction)
        
        setPickerTextFieldTint(sender: [standartSizeTextField, canvasPostPrintTextField])
        
        setTextFieldDelegates(sender: [canvasWidthTextField, canvasAmountTextField, canvasHeightTextField, canvasPostPrintTextField, canvasMaterialTextField, standartSizeTextField])
        
        standartSizesPicker.backgroundColor = UIColor.darkGray
        postPrintPicker.backgroundColor = UIColor.darkGray
        
        self.materialInfoTransition = JTMaterialTransition(animatedView: self.AboutMaterialsButton)


    }
    
    func setTextFieldDelegates(sender: [UITextField]) {
        for textfield in sender {
            textfield.delegate = self
        }
    }
    
    
    @IBAction func heightCursorPosChanged(_ sender: Any) {
        canvasBoolVariables.canvasWidhOrHeightDidNotInputed = false
        canvasBoolVariables.canvasHeightSet = canvasHeightTextField.text!
        errorsCheck()
        updatePrices()
        if canvasAddToCartButton.titleLabel?.text == nameButt {
             EnableButton()
        }

    }
    
    @IBAction func widthCursorPosChanged(_ sender: Any) {
        canvasBoolVariables.canvasWidhOrHeightDidNotInputed = false
        canvasBoolVariables.canvasWidthSet =  canvasWidthTextField.text!
         errorsCheck()
        updatePrices()
        if canvasAddToCartButton.titleLabel?.text == nameButt {
             EnableButton()
        }
    }
    
    @IBAction func amountCursorPosChanged(_ sender: Any) {
        if ( canvasAmountTextField.text == nil) {
            canvasBoolVariables.amountDidNotInputed = true
            updatePrices()
        } else {
            canvasBoolVariables.amountDidNotInputed = false
            canvasBoolVariables.amount = canvasAmountTextField.text!
            
            updatePrices()
        }
        if canvasAddToCartButton.titleLabel?.text == nameButt {
             EnableButton()
        }
    }
    

    @IBAction func AddToCart(_ sender: Any) {
        
        if canvasAddToCartButton.titleLabel?.text == nameButt {
            
            let destination = storyboard?.instantiateViewController(withIdentifier: "shoppingCartVC") as! shoppingCartVC
            let navigationController = UINavigationController(rootViewController: destination)
            navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            navigationController.isNavigationBarHidden = true
            self.present(navigationController, animated: true, completion: nil)
            
        } else {
            let newItem = AddedItems(context: managedObjextContext)
            
            
            if standartSizeTextField.isUserInteractionEnabled == true {
                 newItem.list = ("Тираж: \(canvasAmountTextField.text!) шт.\nМатериал: \(canvasMaterialTextField.text!)\nРазмер: \(standartSizeTextField.text!)\nПостпечатные работы: \(canvasPostPrintTextField.text!)" )
            } else {
                newItem.list = ("Тираж: \(canvasAmountTextField.text!) шт.\nМатериал: \(canvasMaterialTextField.text!)\nРазмер: \(canvasWidthTextField.text!) .м. x \(canvasHeightTextField.text!) м.\nПостпечатные работы: \(canvasPostPrintTextField.text!)" )
            }
            
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
        let controller = storyboard?.instantiateViewController(withIdentifier:"ExpandingMaterialViewController")
        controller?.modalPresentationStyle = .custom
        controller?.transitioningDelegate = self.materialInfoTransition
        self.present(controller!, animated: true, completion: nil)
        
        items = [("canvasPicture", "Холст художественный")]
    }
    

    func errorsCheck() {
        if (canvasBoolVariables.canvasWidthSet.convertToDemicalIfItIsNot > 1.501 &&
            canvasBoolVariables.canvasHeightSet.convertToDemicalIfItIsNot > 1.501) {
                
                self.present(oversizeAlert, animated: true, completion: nil)
                canvasWidthTextField.text = ""
                canvasBoolVariables.canvasWidthSet = canvasWidthTextField.text!
                updatePrices()
        }
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
        canvasComputings()
        canvasPrice.text = canvasBoolVariables.priceToLabel
        canvasNDSPrice.text = canvasBoolVariables.ndsPriceToLabel
        
        
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



extension canvasVC: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // returns the # of rows in each component..
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        standartSizesPicker.tag = 0
        postPrintPicker.tag = 1
        
        if pickerView.tag == 0 {
            return standartSizesdata.count
        } else if pickerView.tag == 1 {
            return postPrintData.count
        }
        return 1
    }
}


extension canvasVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        standartSizesPicker.tag = 0
        postPrintPicker.tag = 1
        
        if pickerView.tag == 0 {
            EnableButton()
            
            if row == 0 { print("didnotChosen");
                canvasBoolVariables.standartSizeDidnNotChosen = true
                canvasBoolVariables.sixH_x_NineH_C = false
                canvasBoolVariables.fiveH_x_sevenH_C = false
                canvasBoolVariables.fourH_x_fiveH_C = false
                canvasBoolVariables.threeH_x_fourH_C = false
                canvasBoolVariables.twoH_x_threeH_C = false
                canvasComputings()
                canvasPrice.text = canvasBoolVariables.priceToLabel
                canvasNDSPrice.text = canvasBoolVariables.ndsPriceToLabel
                updatePrices()
            }
            
            if row == 1 { print("600x900");
                canvasBoolVariables.standartSizeDidnNotChosen = false
                canvasBoolVariables.sixH_x_NineH_C = true
                canvasBoolVariables.fiveH_x_sevenH_C = false
                canvasBoolVariables.fourH_x_fiveH_C = false
                canvasBoolVariables.threeH_x_fourH_C = false
                canvasBoolVariables.twoH_x_threeH_C = false
                canvasComputings()
                canvasPrice.text = canvasBoolVariables.priceToLabel
                canvasNDSPrice.text = canvasBoolVariables.ndsPriceToLabel
            }
            
            if row == 2 { print("500x700");
                canvasBoolVariables.standartSizeDidnNotChosen = false
                canvasBoolVariables.sixH_x_NineH_C = false
                canvasBoolVariables.fiveH_x_sevenH_C = true
                canvasBoolVariables.fourH_x_fiveH_C = false
                canvasBoolVariables.threeH_x_fourH_C = false
                canvasBoolVariables.twoH_x_threeH_C = false
                canvasComputings()
                canvasPrice.text = canvasBoolVariables.priceToLabel
                canvasNDSPrice.text = canvasBoolVariables.ndsPriceToLabel
            }
            
            if row == 3 { print("400x500");
                canvasBoolVariables.standartSizeDidnNotChosen = false
                canvasBoolVariables.sixH_x_NineH_C = false
                canvasBoolVariables.fiveH_x_sevenH_C = false
                canvasBoolVariables.fourH_x_fiveH_C = true
                canvasBoolVariables.threeH_x_fourH_C = false
                canvasBoolVariables.twoH_x_threeH_C = false
                canvasComputings()
                canvasPrice.text = canvasBoolVariables.priceToLabel
                canvasNDSPrice.text = canvasBoolVariables.ndsPriceToLabel
            }
            
            if row == 4 { print("300x400");
                canvasBoolVariables.standartSizeDidnNotChosen = false
                canvasBoolVariables.sixH_x_NineH_C = false
                canvasBoolVariables.fiveH_x_sevenH_C = false
                canvasBoolVariables.fourH_x_fiveH_C = false
                canvasBoolVariables.threeH_x_fourH_C = true
                canvasBoolVariables.twoH_x_threeH_C = false
                canvasComputings()
                canvasPrice.text = canvasBoolVariables.priceToLabel
                canvasNDSPrice.text = canvasBoolVariables.ndsPriceToLabel
            }
            
            if row == 5 { print("200x300");
                canvasBoolVariables.standartSizeDidnNotChosen = false
                canvasBoolVariables.sixH_x_NineH_C = false
                canvasBoolVariables.fiveH_x_sevenH_C = false
                canvasBoolVariables.fourH_x_fiveH_C = false
                canvasBoolVariables.threeH_x_fourH_C = false
                canvasBoolVariables.twoH_x_threeH_C = true
                canvasComputings()
                canvasPrice.text = canvasBoolVariables.priceToLabel
                canvasNDSPrice.text = canvasBoolVariables.ndsPriceToLabel
            }
            
            
            updatePrices()
            return standartSizeTextField.text = standartSizesdata[row]
            
            
        } else if pickerView.tag == 1 {
            EnableButton()
            
            
            if row == 0 { print("without underframe");
                UIView.animate(withDuration: 0.2, animations: {
                    self.standartSizeTextField.alpha = 0
                    self.canvasWidthTextField.alpha = 1
                    self.canvasHeightTextField.alpha = 1
                    self.xLabel.alpha = 1
                    self.standartSizeTextField.isUserInteractionEnabled = false
                    self.canvasWidthTextField.isUserInteractionEnabled = true
                    self.canvasHeightTextField.isUserInteractionEnabled = true
                })
                canvasBoolVariables.withoutUnderframe = true
                canvasBoolVariables.withUnderframe = false
                canvasComputings()
                
                canvasPrice.text = canvasBoolVariables.priceToLabel
                canvasNDSPrice.text = canvasBoolVariables.ndsPriceToLabel
            }
            
            if row == 1 { print("with underframe");
                UIView.animate(withDuration: 0.2, animations: {
                    self.standartSizeTextField.alpha = 0.7
                    self.canvasWidthTextField.alpha = 0
                    self.canvasHeightTextField.alpha = 0
                    self.xLabel.alpha = 0
                    self.standartSizeTextField.isUserInteractionEnabled = true
                    self.canvasWidthTextField.isUserInteractionEnabled = false
                    self.canvasHeightTextField.isUserInteractionEnabled = false
                })
                
                canvasBoolVariables.withoutUnderframe = false
                canvasBoolVariables.withUnderframe = true
                canvasComputings()
                
                canvasPrice.text = canvasBoolVariables.priceToLabel
                canvasNDSPrice.text = canvasBoolVariables.ndsPriceToLabel
            }
            
            updatePrices()
            return canvasPostPrintTextField.text = postPrintData[row]
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        standartSizesPicker.tag = 0
        postPrintPicker.tag = 1
        
        if pickerView.tag == 0 {
            let pickerLabel = UILabel()
            pickerLabel.textColor = UIColor.white
            pickerLabel.text = standartSizesdata[row]
            pickerLabel.font = UIFont.systemFont(ofSize: 17)
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
        } else {
            let pickerLabel = UILabel()
            pickerLabel.textColor = UIColor.white
            pickerLabel.text = postPrintData[row]
            pickerLabel.font = UIFont.systemFont(ofSize: 17)
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
        }
        
    }
    
}


extension canvasVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1, animations: { textField.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) }, completion: { (finish: Bool) in UIView.animate(withDuration: 0.1, animations: { textField.transform = CGAffineTransform.identity }) })
    }
}




