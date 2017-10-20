//
//  DetailInformationViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/24/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class DetailInformationViewController: UIViewController {

  let textView = UITextView()
  
  var informationTitle = String()
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      view.backgroundColor = UIColor.white
      
      navigationItem.title = ""
      
      view.addSubview(textView)
      
      setTextToTextView()
      
      textViewInit()
    }
  

  fileprivate func textViewInit () {

    textView.isEditable = false
    textView.isSelectable = false
    //textView.backgroundColor = self.view.backgroundColor
    textView.alwaysBounceVertical = true
    textView.isUserInteractionEnabled = true
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.topAnchor.constraint(equalTo: view.topAnchor, constant: -15).isActive = true
    textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    textView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    
    
  }
  
  
    fileprivate func setTextToTextView () {
      
      let titleAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 34) ]
      let bodyAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17) ]
      let bodyAttributesBold = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17) ]
      
      let title = NSMutableAttributedString(string: informationTitle, attributes: titleAttributes)
      let combination = NSMutableAttributedString()
      combination.append(title)
      
      if informationTitle == NSLocalizedString("InformationTableViewController.cellTitle.paymentAndDelivery", comment: "") {
        
      let bodyText1 = " \n\nМы принимаем все формы оплаты -\n- наличными(выписывается квитанция),\n- на карту Приватбанка,\n- на расчетный счет ФОП (без НДС, ФОП на\n 2-й группе налогооблажения, работает только с другими ФОП)\n- по безналу с НДС.\n\n  Для новых заказчиков обязательна предоплата!"
        
      let bodyText2 = "\n\nВнимание!\n"
        
      let bodyText3 = " Мы не делаем единичные распечатки и ксерокопии. "
        
      let bodyText4 = "Сумма минимального заказа 100 грн.\n\n"
        
      let bodyText5 = " Тираж можно получить либо у нас в офисе, либо осуществляется доставка по Киеву курьером (стоимость 40 грн) или курьерской доставкой, такси оплачивает получатель).\n\n  Доставку лучше всего оговорить при размещении заказа, чтобы курьер успел заранее спланировать поездку к Вам.\n\n  Для заказчиков из других городов осуществляется доставка до выбранного Вами перевозчика -\nНовая почта, Интайм, Деливери и т.д.\nПри этом оплачивается доставка по Киеву."
        
        let body1 = NSMutableAttributedString(string: bodyText1, attributes: bodyAttributes)
        let body2 = NSMutableAttributedString(string: bodyText2, attributes: bodyAttributesBold)
        let body3 = NSMutableAttributedString(string: bodyText3, attributes: bodyAttributes)
        let body4 = NSMutableAttributedString(string: bodyText4, attributes: bodyAttributesBold)
        let body5 = NSMutableAttributedString(string: bodyText5, attributes: bodyAttributes)
    
        combination.append(body1)
        combination.append(body2)
        combination.append(body3)
        combination.append(body4)
        combination.append(body5)
        
        textView.attributedText = combination
      }
      
      
      if informationTitle == NSLocalizedString("InformationTableViewController.cellTitle.requirementsToLayouts", comment: "") {
      
        
        let bodyText1 = "\n\n Растровые макеты: .tif, 300 dpi до формата А3, 200 dpi до формата А1, 150 dpi до формата А0, 120 dpi для больших форматов, 50 dpi для форматов более 2х2 метра, CMYK, 8 бит, слои склеены. \n\nВекторные макеты: .cdr, .eps, .ai. Все шрифты переведены в кривые, эффекты и прозрачности отрастрированы, CMYK. Картинки вставлены, а не залинкованы."

        
         let bodyText2 = "\n\nВнимание!"
        
         let bodyText3 = " Не используйте Overprint для белых и светлых объектов! При отсутствии такого объекта на отпечатанной продукции или изменении его цвета типография ответственности не несет!\nПредпочтение отдается макетам в формате .pdf. \nПри создании .pdf следует использовать Press Qualitу и отключить управление цветом.\nДля цифровой и офсетной печати обязательна вычистка (вылет фона под обрез) 2 мм по периметру изображения. \n\n"
        let image1 = UIImage(cgImage: UIImage(named: "vychistka")!.cgImage!, scale: 1.1, orientation: .up)
        
        let bodyText4 = "\n\nПри изготовления клише для тиснения макеты принимаются ТОЛЬКО в векторных форматах.\n\nДля высечки/плоттерной порезки макет должен содержать два слоя: слой с изображением для печати с вычисткой 2 мм и слой с ВЕКТОРЫМ контуром высечки. Также проверьте свой макет в контурном режиме, как макет выглядит в контурах так он и будет вырезан.\n\nДля персонализации/нумерации данные принимаются в форматах .xls  или .ods, каждое окно персонализации в отдельной колонке, в требуемом падеже, без лишних пробелов и переносов. При персонализации в несколько окон все данные относящиеся к одному изделию должны быть в одной строке но в своих колонках, как на рисунке ниже:\n"
        let image2 = UIImage(named: "exel")
        
         let bodyText5 = "\n\n  Не стоит при создании макета ориентироваться на цветопередачу своего монитора. Чтобы в этом убедиться, достаточно открыть один и тот же макет на двух разных мониторах, и увидеть два разных оттенка. Если для Вас принципиален цвет отпечатанной продукции, оптимально приехать к нам в офис и вывести цветопробу. Если у Вас есть брендбук и/или руководство по фирменному стилю, используйте оттуда описание цвета по CMYK, или воспользуйтесь каталогами цветов Pantone (используйте описание цветов по CMYK а не номер цвета Pantone). \n\nВсе наши печатные машины проходят регулярную калибровку, и мы достаточно точно попадаем в цвет. Претензии 'у меня на экране салатовенький, а у вас на печати бирюзовенький' не принимаются. Какой цвет Вы поставили в файле, такой мы и напечатаем. Если не уверены в результате - сделайте перед печатью тиража цветопробу, или доверьте разработку макета нашим дизайнерам."
        
        
        let attachment1 = NSTextAttachment()
        let attachment2 = NSTextAttachment()
        
        attachment1.image = image1
        attachment2.image = image2
        
        let attString1 = NSAttributedString(attachment: attachment1)
        let attString2 = NSAttributedString(attachment: attachment2)
        
        let body1 = NSMutableAttributedString(string: bodyText1, attributes: bodyAttributes)
        let body2 = NSMutableAttributedString(string: bodyText2, attributes: bodyAttributesBold)
        let body3 = NSMutableAttributedString(string: bodyText3, attributes: bodyAttributes)
        let body4 = NSMutableAttributedString(string: bodyText4, attributes: bodyAttributes)
        let body5 = NSMutableAttributedString(string: bodyText5, attributes: bodyAttributes)
        
        combination.append(body1)
        combination.append(body2)
        combination.append(body3)
        combination.append(attString1)
        combination.append(body4)
        combination.append(attString2)
        combination.append(body2)
        combination.append(body5)

        textView.attributedText = combination
      }
      
      
      if informationTitle == NSLocalizedString("InformationTableViewController.cellTitle.layoutDesignDevlopment", comment: "") {
       textView.attributedText = combination
        
        let bodyText1 = "\n\n В отличии от многих типографий, привлекающих для работы над макетами фрилансеров, мы считаем что дизайнер должен физически присутствовать на производстве, знать плюсы и минусы различных технологий печати, иметь возможность контролировать процесс печати и вмешаться в него при необходимости. Три наших штатных дизайнера с удовольствием помогут воплотить на бумаге практически любые Ваши идеи!\n\nОриентировочная стоимость дизайна:\n\nВизитная карточка - от 50 грн/сторона\n\nБланк, конверт -  от 100 грн.\n\nЕврофлаер - от 100 грн/сторона\n\nБуклет, каталог -  от 100 грн за страницу\n\nПлакат - от 300 грн.\n\nСложные работы, работа в присутствии заказчика - 150 грн/час"
        
        let body1 = NSMutableAttributedString(string: bodyText1, attributes: bodyAttributes)
        combination.append(body1)
        textView.attributedText = combination
      }
      
      
      if informationTitle == NSLocalizedString("InformationTableViewController.forAdvertisingAgencies", comment: "") {
        
        let bodyText1 = "\n\n Для рекламных агентств мы предоставляем индивидуальные договорные цены. \n\n  Обращайтесь в офис к менеджерам для налаживания сотрудничества. С нами работают десятки РА г. Киева и других городов Украины.\n\n Будем рады плодотворной совместной работе."
        
        let body1 = NSMutableAttributedString(string: bodyText1, attributes: bodyAttributes)
        combination.append(body1)
        textView.attributedText = combination
      }
   }
}
