//
//  BannersPostprintView.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/23/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

var postprintBlockHeightAnchor: NSLayoutConstraint?

class BannersPostprintView: UIView {
  
  var luversTitle: UILabel = {
    var luversTitle = UILabel()
    luversTitle.translatesAutoresizingMaskIntoConstraints = false
    luversTitle.font =  UIFont.systemFont(ofSize: 17)
    luversTitle.text = NSLocalizedString("BannersPostprintView.luversTitle.text", comment: "")
    //"Установка люверсов"
    
    return luversTitle
  }()


  let luversSwitch: UISwitch = {
    let luversSwitch = UISwitch()
    luversSwitch.translatesAutoresizingMaskIntoConstraints = false
    luversSwitch.addTarget(self, action: #selector(luversSwitchValueDidChange), for: .valueChanged)
  
    return luversSwitch
  }()
  
  let luversAmountField: AvalonUITextField = {
    let luversAmountField = AvalonUITextField()
    luversAmountField.placeholder = NSLocalizedString("BannersPostprintView.luversAmountField.placeholder", comment: "")
      //"Кол-во люверсов в одном изделии"
    luversAmountField.translatesAutoresizingMaskIntoConstraints = false
    luversAmountField.addTarget(self, action: #selector(textFielDidChange(_:)), for: .editingChanged)
    luversAmountField.isEnabled = false
    luversAmountField.keyboardType = .numberPad
    
    
    return luversAmountField
  }()
  
  
  var pocketsTitle: UILabel = {
    var pocketsTitle = UILabel()
    pocketsTitle.translatesAutoresizingMaskIntoConstraints = false
    pocketsTitle.font =  UIFont.systemFont(ofSize: 17)
    pocketsTitle.text = NSLocalizedString("BannersPostprintView.pocketsTitle.text", comment: "")
    //"Проварка карманов, швов"
    
    return pocketsTitle
  }()

  
  let pocketsSwitch: UISwitch = {
    let pocketsSwitch = UISwitch()
    pocketsSwitch.translatesAutoresizingMaskIntoConstraints = false
    pocketsSwitch.addTarget(self, action: #selector(pocketsSwitchValueDidChange), for: .valueChanged)
    
    
    
    return pocketsSwitch
  }()
  
  let pocketsLengthField: AvalonUITextField = {
    let pocketsLengthField = AvalonUITextField()
    pocketsLengthField.placeholder = NSLocalizedString("BannersPostprintView.pocketsLengthField.placeholder", comment: "")
    //"Общая длинна кармана, шва (м) "
    pocketsLengthField.translatesAutoresizingMaskIntoConstraints = false
    pocketsLengthField.addTarget(self, action: #selector(textFielDidChange(_:)), for: .editingChanged)
    pocketsLengthField.isEnabled = false
    pocketsLengthField.keyboardType = .decimalPad
    
    
    return pocketsLengthField
  }()
  
  
  @objc func textFielDidChange(_ sender: Any) {
    
    currentPageData.luversAmount = luversAmountField.text!
    currentPageData.pocketsLength = pocketsLengthField.text!
    calculatePriceOfSelectedProduct()
  }
  
  
  @objc func luversSwitchValueDidChange() {
    
    if luversSwitch.isOn {
      luversAmountField.isEnabled = true
    } else {
      luversAmountField.isEnabled = false
      textFielDidChange((Any).self)
    }
  }
  
  
  @objc func pocketsSwitchValueDidChange() {
      
      if pocketsSwitch.isOn {
        pocketsLengthField.isEnabled = true
      } else {
        pocketsLengthField.isEnabled = false
        textFielDidChange((Any).self)
      }
  }
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor.white
    pocketsTitle.backgroundColor = backgroundColor
    luversTitle.backgroundColor = backgroundColor
    
    addSubview(luversTitle)
    addSubview(luversSwitch)
    luversTitle.topAnchor.constraint(equalTo: topAnchor, constant: 26).isActive = true
    luversTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    luversTitle.trailingAnchor.constraint(equalTo: luversSwitch.leadingAnchor, constant: 0).isActive = true
    
    luversSwitch.centerYAnchor.constraint(equalTo: luversTitle.centerYAnchor).isActive = true
    luversSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    
    addSubview(luversAmountField)
    luversAmountField.topAnchor.constraint(equalTo: luversTitle.bottomAnchor, constant: 26).isActive = true
    luversAmountField.leadingAnchor.constraint(equalTo: luversTitle.leadingAnchor).isActive = true
    luversAmountField.trailingAnchor.constraint(equalTo: luversSwitch.trailingAnchor).isActive = true
    luversAmountField.heightAnchor.constraint(equalToConstant: 50).isActive = true

    addSubview(pocketsTitle)
    addSubview(pocketsSwitch)
    pocketsTitle.topAnchor.constraint(equalTo: luversAmountField.bottomAnchor, constant: 26).isActive = true
    pocketsTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    pocketsTitle.trailingAnchor.constraint(equalTo: pocketsSwitch.leadingAnchor, constant: 0).isActive = true
    
    pocketsSwitch.centerYAnchor.constraint(equalTo: pocketsTitle.centerYAnchor).isActive = true
    pocketsSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    
    addSubview(pocketsLengthField)
    pocketsLengthField.topAnchor.constraint(equalTo: pocketsTitle.bottomAnchor, constant: 26).isActive = true
    pocketsLengthField.leadingAnchor.constraint(equalTo: pocketsTitle.leadingAnchor).isActive = true
    pocketsLengthField.trailingAnchor.constraint(equalTo: pocketsSwitch.trailingAnchor).isActive = true
    pocketsLengthField.heightAnchor.constraint(equalToConstant: 50).isActive = true
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    
  }


}
