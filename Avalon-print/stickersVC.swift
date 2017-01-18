//
//  MainPageController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/1/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//


import UIKit
import avalonExtBridge

class stickersVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
    @IBOutlet weak var stickersAddToCartButton: ButtonMockup!
    
    var data = ["Выберите материал...","Пленка самокл. белая глянец/мат","Пленка самокл. прозрачная глянец/мат","Перфорированая пленка One Way Vision"]
    var postPrintData = ["Без постпечати","Холодная ламинация глянец/мат"]
    
    var materialPicker = UIPickerView()
    var postPrintPicker = UIPickerView()
    
    
    let oversizeAlert = UIAlertController(title: "Превышен максимальный размер", message: "Максимальная ширина 1.59м", preferredStyle: UIAlertControllerStyle.actionSheet)
    
    let oversizeAlertSmall = UIAlertController(title: "Превышен максимальный размер", message: "Максимальная ширина 1.51м", preferredStyle: UIAlertControllerStyle.actionSheet)
    
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)

    let nameButt =  "В корзину"
    
    @IBAction func AddToCart(_ sender: Any) {
        
        if stickersAddToCartButton.titleLabel?.text == nameButt {

            let destination = storyboard?.instantiateViewController(withIdentifier: "bucket") as! bucket
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
    
    override func viewWillDisappear(_ animated: Bool) {
        leftImageViewConstraint.constant = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        leftImageViewConstraint.constant = -25
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        stickersMaterialTextField.text = data[0]
        stickersPostPrintTextField.text = postPrintData[0]
        
        oversizeAlert.addAction(okAction)
        oversizeAlertSmall.addAction(okAction)
    }
    
    
    @IBAction func amountCursorPosChanged(_ sender: Any) {
        if ( stickersAmountTextField.text == nil) {
            stickersBoolVariables.amountDidNotInputed = true
            updatePrices()
        } else {
            stickersBoolVariables.amountDidNotInputed = false
            stickersBoolVariables.amount = stickersAmountTextField.text!
            
            updatePrices()
        }
        if stickersAddToCartButton.titleLabel?.text == nameButt {
            EnableButton()
        }

    }
    
    @IBAction func widthCursorPosChanged(_ sender: Any) {
        stickersBoolVariables.stickersWidhOrHeightDidNotInputed = false
        stickersBoolVariables.stickersWidthSet =  stickersWidthTextField.text!
        errorsCheck()
        updatePrices()
        if stickersAddToCartButton.titleLabel?.text == nameButt {
            EnableButton()
        }
        
    }
    @IBAction func heightCursorPosChanged(_ sender: Any) {
        stickersBoolVariables.stickersWidhOrHeightDidNotInputed = false
        
        stickersBoolVariables.stickersHeightSet = stickersHeightTextField.text!
        errorsCheck()
        updatePrices()
        if stickersAddToCartButton.titleLabel?.text == nameButt {
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
                stickersBoolVariables.materialDidnNotChosen = true
                stickersBoolVariables.whiteStickerC = false
                stickersBoolVariables.transparentStickerC = false
                stickersBoolVariables.oneWayVisionC = false
                
                stickersComputings()
                stickersPrice.text = stickersBoolVariables.priceToLabel
                stickersNDSPrice.text = stickersBoolVariables.ndsPriceToLabel
                updatePrices()
                
            }
            
            if row == 1 { print("white stickers");
                stickersBoolVariables.materialDidnNotChosen = false
                stickersBoolVariables.whiteStickerC = true
                stickersBoolVariables.transparentStickerC = false
                stickersBoolVariables.oneWayVisionC = false
                //  errorsCheck()
                stickersComputings()
                stickersPrice.text = stickersBoolVariables.priceToLabel
                stickersNDSPrice.text = stickersBoolVariables.ndsPriceToLabel
            }
            
            if row == 2 { print("transparent stickers");
                stickersBoolVariables.materialDidnNotChosen = false
                stickersBoolVariables.whiteStickerC = false
                stickersBoolVariables.transparentStickerC = true
                stickersBoolVariables.oneWayVisionC = false
                //errorsCheck()
                stickersComputings()
                stickersPrice.text = stickersBoolVariables.priceToLabel
                stickersNDSPrice.text = stickersBoolVariables.ndsPriceToLabel}
            
            if row == 3 { print("one way vision");
                stickersBoolVariables.materialDidnNotChosen = false
                stickersBoolVariables.whiteStickerC = false
                stickersBoolVariables.transparentStickerC = false
                stickersBoolVariables.oneWayVisionC = true
                // errorsCheck()
                stickersComputings()
                stickersPrice.text = stickersBoolVariables.priceToLabel
                stickersNDSPrice.text = stickersBoolVariables.ndsPriceToLabel}
            
            updatePrices()
            return stickersMaterialTextField.text = data[row]
            
            
        } else if pickerView.tag == 1 {
             EnableButton()
            
            
            if row == 0 { print("without post print");
                stickersBoolVariables.withoutPostPrint = true
                stickersBoolVariables.coldLaminationC = false
                
                stickersComputings()
                stickersPrice.text = stickersBoolVariables.priceToLabel
                stickersNDSPrice.text = stickersBoolVariables.ndsPriceToLabel}
            
            if row == 1 { print("cold lamination");
                stickersBoolVariables.withoutPostPrint = false
                stickersBoolVariables.coldLaminationC = true
                
                stickersComputings()
                stickersPrice.text = stickersBoolVariables.priceToLabel
                stickersNDSPrice.text = stickersBoolVariables.ndsPriceToLabel}
            
            updatePrices()
            return stickersPostPrintTextField.text = postPrintData[row]
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
          stickersAddToCartButton.setTitle("В корзину", for: .normal)
    }
    
    func EnableButton() {
        stickersAddToCartButton.setTitle("Добавить в корзину", for: .normal )
        stickersAddToCartButton.isUserInteractionEnabled = true
        stickersAddToCartButton.setTitleColor(UIColor.white, for: UIControlState.normal)
    }
    
    func closeKeyboard() {
        self.view.endEditing(true)
        errorsCheck()  
    }
    
    func errorsCheck() {
        if  ( stickersMaterialTextField.text == data[0] ) {
            
        } else if (stickersMaterialTextField.text == data[3] && stickersBoolVariables.stickersWidthSet.doubleValue > 1.51 && stickersBoolVariables.stickersHeightSet.doubleValue > 1.51) {
            
            self.present(oversizeAlertSmall, animated: true, completion: nil)
            stickersWidthTextField.text = ""
            stickersBoolVariables.stickersWidthSet = stickersWidthTextField.text!
            updatePrices()
            
            
        } else if ( (stickersMaterialTextField.text == data[1] || stickersMaterialTextField.text == data[2]) && stickersBoolVariables.stickersWidthSet.doubleValue > 1.59 && stickersBoolVariables.stickersHeightSet.doubleValue > 1.59 ) {
            self.present(oversizeAlert, animated: true, completion: nil)
            stickersWidthTextField.text = ""
            stickersBoolVariables.stickersWidthSet = stickersWidthTextField.text!
            updatePrices()
            
        }
    }
    
    
    //MARK: Touch Events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closeKeyboard()
    }
    
    //MARK: DEPENDS ON SIZE AMOUNT AND WHICH ELEMENTS WERE SELECTED, PRICES UPDATE
    func updatePrices() {
        stickersComputings()
        stickersPrice.text = stickersBoolVariables.priceToLabel
        stickersNDSPrice.text = stickersBoolVariables.ndsPriceToLabel
        
        
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
