//
//  ExpandingMaterialTableViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 1/21/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

 var dataArray = ["Название: Material", "Плотность: 140","Покрытие меловка","макс ширина 1000"]

 var secondSection = ["Быстросохнущая микропористая постерная бумага с белой поверхностью, сатиновым покрытием для печати сольвентными и экосольвентными чернилами. Печатная поверхность может принять большое количество чернил, обеспечивая хорошее качество печати рекламных плакатов, чернила не растекаются. Рекомендуется для интерьерной и наружной рекламы. Бумагу можно защищать как горячей, так и холодной ламинацией."]

class ExpandingMaterialTableViewController: UITableViewController {
  
    fileprivate var scrollOffsetY: CGFloat = 0

  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.title = items[currentSelectedMaterialInfoCell].title
      
      tableView.backgroundColor = UIColor.white
      view.backgroundColor = UIColor.white
      extendedLayoutIncludesOpaqueBars = true
 
      tableView.separatorStyle = .none
      
      let leftButton = UIBarButtonItem(image: UIImage(named: "ChevronLeft"), style: .plain, target: self, action: #selector(back(sender:)))
    
      navigationItem.leftBarButtonItem = leftButton
    }
  
  
  @objc func back(sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 { return ""}
    if section == 1 {
      return NSLocalizedString("ExpandingMaterialTableViewController.titleForHeaderInSection.one", comment: "")//"Характеристики"
    } else {
    return NSLocalizedString("ExpandingMaterialTableViewController.titleForHeaderInSection.two", comment: "") //"Описание"
    }
  }
  
  
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    
    if section != 0 {
      let header = view as! UITableViewHeaderFooterView
      header.textLabel?.font = UIFont.systemFont(ofSize: 20)
      header.textLabel?.textColor = UIColor.black
    }
  }
  
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    if section == 0 {
      let header = UIView()
      let headerImage = UIImage(named: items[currentSelectedMaterialInfoCell].imageName)
      let headerImageView = UIImageView(image: headerImage)
      headerImageView.contentMode = .scaleAspectFill
      header.addSubview(headerImageView)
      headerImageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 300)
      
      return header
    }

    return nil
  }
  
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 300
    }
    
      return 60
  }
  
 
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if section == 1 {
      return dataArray.count
    }
    
    if section == 2 {
      return secondSection.count
    }
    
      return 0
  }
  
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 1 { return 44 }
    
    if indexPath.section == 2 { return 180 }
      return 0
    }
  
 
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let identifier = "cell"
    
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell(style: .default, reuseIdentifier: identifier)
    
     cell.textLabel?.numberOfLines = 0
     cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
    
    if indexPath.section == 1 {
       cell.textLabel?.text = dataArray[indexPath.row]
    }
    
    if indexPath.section == 2 {
      
      cell.textLabel?.text = secondSection[indexPath.row]
    }
    
    return cell
  }
  
  
     override func scrollViewDidScroll(_ scrollView: UIScrollView) {
            scrollOffsetY = scrollView.contentOffset.y
        }
    
}
    
    
 
