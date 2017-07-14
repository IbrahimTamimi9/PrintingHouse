//
//  HelpingFunctions.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 1/20/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var convertToDemicalIfItIsNot: Double {
        let converter = NumberFormatter()
        
        converter.decimalSeparator = ","
        if let result = converter.number(from: self) {
            return Double(result.floatValue)
            
        } else {
            
            converter.decimalSeparator = "."
            if let result = converter.number(from: self) {
                return Double(result.floatValue)
            }
        }
        return 0
    }
}

extension UIApplication {
  var statusBarView: UIView? {
    return value(forKey: "statusBar") as? UIView
  }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


 func rootPresent(viewController : UIViewController) {
  
  var rootViewController = UIApplication.shared.keyWindow?.rootViewController
  
  if let navigationController = rootViewController as? UINavigationController {
    rootViewController = navigationController.viewControllers.first
  }
  
  rootViewController?.present(viewController, animated: true, completion: nil)
}


 func rootDismiss() {
  
  var rootViewController = UIApplication.shared.keyWindow?.rootViewController

  if let navigationController = rootViewController as? UINavigationController {
    rootViewController = navigationController.viewControllers.first
  }
  
  rootViewController?.dismiss(animated:true, completion: nil)
 // rootViewController?.view.alpha = 0
}



func resetTableView () {
  gottenSignal.postersSignal = false
  gottenSignal.stickersSignal = false
  gottenSignal.canvasSignal = false
  gottenSignal.bannersSignal = false
}


func fillTableView (indexPath: IndexPath) {
  
  if gottenSignal.postersSignal == true {
    if  indexPath.row == 0 {
      dataArray = ["Плотность: 140гр/м2", "Покрытие: матовое","Максимальная ширина: 160см"]
      secondSection = ["Быстросохнущая микропористая постерная бумага с белой поверхностью, сатиновым покрытием для печати сольвентными и экосольвентными чернилами. Печатная поверхность может принять большое количество чернил, обеспечивая хорошее качество печати рекламных плакатов, чернила не растекаются. Рекомендуется для интерьерной и наружной рекламы. Бумагу можно защищать горячей ламинацией."]
    }
    if indexPath.row == 1 {
      dataArray =  ["Плотность: 140гр/м2","Покрытие: матовое","Максимальная ширина: 61см"]
      secondSection = ["Быстросохнущая микропористая постерная бумага с белой поверхностью, сатиновым покрытием для печати пигментными чернилами. Печатная поверхность может принять большое количество чернил, обеспечивая хорошее качество печати рекламных плакатов, чернила не растекаются. Рекомендуется для ТОЛЬКО для интерьерной рекламы. Бумагу можно защищать горячей ламинацией."]

    }
    if indexPath.row == 2 {
      dataArray =  ["Плотность: 200гр/м2","Покрытие: матовое/глянцевое","Максимальная ширина: 61см"]
       secondSection = ["Фотобумага с белой поверхностью, для печати пигментными чернилами. Печатная поверхность может принять большое количество чернил, обеспечивая хорошее качество печати рекламных плакатов и фотографий, чернила не растекаются. Рекомендуется для ТОЛЬКО для интерьерной рекламы или фото. Бумагу можно защищать горячей ламинацией."]
    }
  }
  
  if gottenSignal.stickersSignal == true {
    if  indexPath.row == 0 {
      dataArray = ["Плотность: 210гр/м2","Покрытие: матовое/глянцевое","Максимальная ширина: 160см"]
      
      secondSection = ["Мягкая полихлорвиниловая каландрированная пленка белого цвета (глянцевая и матовая). Предназначена для еко-сольвентной печати. Имеет улучшенное покрытие для печати, предотвращающее растекание чернил. Подложка из силиконизированной бумаги менее подвержена «короблению» при подогреве перед печатью в  еко-сольвентных машинах."]
     
    }
    if indexPath.row == 1 {
      dataArray = ["Плотность: 210гр/м2","Покрытие: матовое/глянцевое","Максимальная ширина: 160см"]
       secondSection = ["Мягкая полихлорвиниловая каландрированная прозрачная пленка (глянцевая и матовая). Предназначена для еко-сольвентной печати. Имеет улучшенное покрытие для печати, предотвращающее растекание чернил. Подложка из силиконизированной бумаги менее подвержена «короблению» при подогреве перед печатью в  еко-сольвентных машинах."]
    }
    if indexPath.row == 2 {
      dataArray = ["Плотность: -","Покрытие: глянцевое","Максимальная ширина: 151см"]
      secondSection = ["Перфорированная виниловая плёнка с высокой светопропускной способностью на самоклеящейся основе. За счет черной клеевой основы и мелких отверстий, создает эффект тюли и легкой тонировки. Изображение хорошо воспринимается с одной стороны, а с обратной - видна черная сетка с круглыми отверстиями. Позволяет наносить изображения на стекло, сохраняя при этом его первоначальное назначение."]
    }
  }
  
  if gottenSignal.canvasSignal == true {
    if  indexPath.row == 0 {
      dataArray = ["Плотность: 200гр/м2","Покрытие: матовое","Максимальная ширина: 150см"]
      secondSection = ["Плотный материал, имеющий тканевую основу с фактурной поверхностью и одностороннее тонкое полимерное покрытие. Большой вес исключает скручивание материала по краям. Холсты предназначены для использования внутри помещения. Применяется в дизайне интерьера (фотопортретов, художественной и дизайнерской графики, репродукций и копий картин)."]
    }
  }
  
  if gottenSignal.bannersSignal == true {
    if  indexPath.row == 0 {
      dataArray = ["Плотность: 280гр/м2","Покрытие: матовое","Максимальная ширина: 300см"]
       secondSection = ["Виниловое полотно, основанное на сетчатом полиэстере различной плотности. Данный тип материала позволяет создавать наружную рекламу разных форматов и типов, начиная от перетяжек и заканчивая баннерами на крышах."]
    }
    if indexPath.row == 1 {
      dataArray = ["Плотность: 440гр/м2","Покрытие: матовое","Максимальная ширина: 300см"]
       secondSection = ["Обладает высоким уровнем устойчивости к возгоранию, в силу наличия в ее составе особых химических соединений. Все изделия из литой баннерной ткани практически всегда служат в самых экстремальных условиях - порывы ветра, перепады температур... Литой виниловый баннер является одним из лучших решений для организации продолжительных рекламных акций."]
    }
    if indexPath.row == 2 {
      dataArray = ["Плотность: 510гр/м2","Покрытие: матовое полупрозрачное","Максимальная ширина: 300см"]
      
      secondSection = ["Светорассеивающая (транслюцентная) ПВХ-ткань с прозрачностью 25 - 37%. При правильном расположении источников света транслюцентный баннер обеспечивают равномерное светорассеивание и хорошую световую насыщенность. Backlit применяется для печати плакатов с последующим размещением их на объектах уличной рекламы с внутренней подсветкой - световых коробах и других конструкциях."]
    }
    if indexPath.row == 3 {
      dataArray = ["Плотность: -","Покрытие: матовое","Максимальная ширина: 300см"]
      secondSection = ["ПВХ-материал ячеистой структуры. Один из самых подходящих материалов для печати изображений очень больших размеров. В отличие от ткани, баннерная сетка имеет меньший вес и хорошо пропускает воздух. Это в значительной степени снижает ветровые нагрузки на поверхность. Баннерная сетка хорошо пропускает свет, что дает возможность применять ее на фасадах зданий имеющих окна."]
      
    
    }
  }
}
