//
//  informationDetail.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/2/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//

import UIKit
 
class InformationDetail: UIViewController {
    
    @IBOutlet weak var textViewForLoadingContent: UITextView!
    var passedValue:String! //name of cell
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = passedValue
        navigationItem.backBarButtonItem?.title = ""
        
        
        if passedValue == "Оплата и доставка" {
            
            textViewForLoadingContent.text = " Мы принимаем все формы оплаты -\n- наличными(выписывается квитанция),\n- на карту Приватбанка,\n- на расчетный счет ФОП (без НДС, ФОП на\n 2-й группе налогооблажения, работает только с другими ФОП)\n- по безналу с НДС.\n\nДля новых заказчиков обязательна предоплата!\n\nВнимание! Мы не делаем единичные распечатки и ксерокопии.\nСумма минимального заказа 100 грн.\nТираж можно получить либо у нас в офисе, либо осуществляется доставка по Киеву курьером (стоимость 40 грн) или курьерской доставкой, такси оплачивает получатель).\nДоставку лучше всего оговорить при размещении заказа, чтобы курьер успел заранее спланировать поездку к Вам.\n\nДля заказчиков из других городов осуществляется доставка до выбранного Вами перевозчика -\nНовая почта, Интайм, Деливери и т.д.\nПри этом оплачивается доставка по Киеву.\n"
        }
        
        
        if passedValue == "Требования к макетам" {
            textViewForLoadingContent.text = " Растровые макеты: .tif, 300 dpi до формата А3, 200 dpi до формата А1, 150 dpi до формата А0, 120 dpi для больших форматов, 50 dpi для форматов более 2х2 метра, CMYK, 8 бит, слои склеены. \n\nВекторные макеты: .cdr, .eps, .ai. Все шрифты переведены в кривые, эффекты и прозрачности отрастрированы, CMYK. Картинки вставлены, а не залинкованы. \n\nВнимание! Не используйте Overprint для белых и светлых объектов! При отсутствии такого объекта на отпечатанной продукции или изменении его цвета типография ответственности не несет!\nПредпочтение отдается макетам в формате .pdf. \nПри создании .pdf следует использовать Press Qualitу и отключить управление цветом.\nДля цифровой и офсетной печати обязательна вычистка (вылет фона под обрез) 2 мм по периметру изображения. \n\nПри изготовления клише для тиснения макеты принимаются ТОЛЬКО в векторных форматах.\n\nДля высечки/плоттерной порезки макет должен содержать два слоя: слой с изображением для печати с вычисткой 2 мм и слой с ВЕКТОРЫМ контуром высечки. Также проверьте свой макет в контурном режиме, как макет выглядит в контурах так он и будет вырезан. \n\nВнимание! Не стоит при создании макета ориентироваться на цветопередачу своего монитора. Чтобы в этом убедиться, достаточно открыть один и тот же макет на двух разных мониторах, и увидеть два разных оттенка. Если для Вас принципиален цвет отпечатанной продукции, оптимально приехать к нам в офис и вывести цветопробу. Если у Вас есть брендбук и/или руководство по фирменному стилю, используйте оттуда описание цвета по CMYK, или воспользуйтесь каталогами цветов Pantone (используйте описание цветов по CMYK а не номер цвета Pantone). \n\nВсе наши печатные машины проходят регулярную калибровку, и мы достаточно точно попадаем в цвет. Претензии 'у меня на экране салатовенький, а у вас на печати бирюзовенький' не принимаются. Какой цвет Вы поставили в файле, такой мы и напечатаем. Если не уверены в результате - сделайте перед печатью тиража цветопробу, или доверьте разработку макета нашим дизайнерам."
        }
        
        
        if passedValue == "Разработка макетов" {
            textViewForLoadingContent.text = " В отличии от многих типографий, привлекающих для работы над макетами фрилансеров, мы считаем что дизайнер должен физически присутствовать на производстве, знать плюсы и минусы различных технологий печати, иметь возможность контролировать процесс печати и вмешаться в него при необходимости. Три наших штатных дизайнера с удовольствием помогут воплотить на бумаге практически любые Ваши идеи!\n\nОриентировочная стоимость дизайна:\n\nВизитная карточка - от 50 грн/сторона\n\nБланк, конверт -  от 100 грн.\n\nЕврофлаер - от 100 грн/сторона\n\nБуклет, каталог -  от 100 грн за страницу\n\nПлакат - от 300 грн.\n\nСложные работы, работа в присутствии заказчика - 150 грн/час"
        }
        
        if passedValue == "РА и посредникам" {
            navigationItem.title = "РА и посредникам"
            textViewForLoadingContent.text = " Для рекламных агентств мы предоставляем индивидуальные договорные цены. \n\nОбращайтесь в офис к менеджерам для налаживания сотрудничества. С нами работают десятки РА г. Киева и других городов Украины.\n\nБудем рады плодотворной совместной работе."
        }
    }//func view will appear

   // }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
    