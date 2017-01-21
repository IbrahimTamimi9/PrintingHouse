//
//  MainPageController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/1/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//


import UIKit

class bannersVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var leftImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    
    @IBOutlet weak var bannersAmountTextField: HoshiTextField!
    
    @IBOutlet weak var bannersMaterialTextField: UITextField!
    
    @IBOutlet weak var bannersWidthTextField: HoshiTextField!
    
    @IBOutlet weak var bannersHeightTextField: HoshiTextField!
    
    @IBOutlet weak var luversSetUpSwitch: UISwitch!
    @IBOutlet weak var pocketsSeamsSetUpSwitch: UISwitch!
    
    @IBOutlet weak var distanceBetweenLuvers: UITextField!
    @IBOutlet weak var luversAmountOnOneProduct: UITextField!
    
    @IBOutlet weak var lengthPocketsSeams: UITextField!
    
    
    @IBOutlet weak var bannersPrice: UILabel!
    @IBOutlet weak var bannersNDSPrice: UILabel!
    
    @IBOutlet weak var bannersAddToCartButton: UIButton!
    
    
    override func viewWillDisappear(_ animated: Bool) {
        leftImageViewConstraint.constant = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        leftImageViewConstraint.constant = -25
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        mainScrollView.delegate = self
        
        setTextFieldDelegates(sender: [bannersAmountTextField, bannersWidthTextField, bannersHeightTextField, bannersMaterialTextField, distanceBetweenLuvers, luversAmountOnOneProduct, lengthPocketsSeams])
        
         applyMotionEffect(toView: backgroundImageView, magnitude: 25)
         setPickerTextFieldTint(sender: [bannersMaterialTextField])
   }
    
    func setTextFieldDelegates(sender: [UITextField]) {
        for textfield in sender {
            textfield.delegate = self
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1, animations: { textField.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) }, completion: { (finish: Bool) in UIView.animate(withDuration: 0.1, animations: { textField.transform = CGAffineTransform.identity }) })
    }
    
    
    @IBAction func AddToCart(_ sender: Any) {
    }
    @IBAction func amountCursorPosChanged(_ sender: Any) {
    }
    
    @IBAction func widthCursorPosChanged(_ sender: Any) {
    }
    @IBAction func heightCursorPosChanged(_ sender: Any) {
    }
    
    @IBAction func luversSetUpSwitchStateChanged(_ sender: Any) {
    }
    @IBAction func pocketsSeamsSetUpSwitchStateChanged(_ sender: Any) {
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 || scrollView.contentOffset.x<0 {
            scrollView.contentOffset.x = 0
        }
    }
    
}
