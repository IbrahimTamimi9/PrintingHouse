//
//  ContactsTableViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/23/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
  
  var hidingNavigationBarManager: HidingNavigationBarManager?

  let headerText = NSLocalizedString("ContactsTableViewController.headerText", comment: "")//"Режим работы: 10.00 - 18.00 по будним\n\nСайт: avalon-print.com\n\nE-mail: print@avalon-print.com"
  
//  let officeNumberLocalizableType = NSLocalizedString("ContactsTableViewController.officeNumbers.officeNumberLocalizable", comment: "")
//  let mtsNumberLocalizableType = NSLocalizedString("ContactsTableViewController.officeNumbers.mtsNumberLocalizable", comment: "")
//  let lifecellNumberLocalizableType = NSLocalizedString("ContactsTableViewController.officeNumbers.lifecellNumberLocalizable", comment: "")
//  
//  let managerEvgeniyLocalizableName =  NSLocalizedString("ContactsTableViewController.mobileNumbers.managerEvgeniyLocalizable", comment: "")
//  let managerYriyNumberLocalizableName =  NSLocalizedString("ContactsTableViewController.mobileNumbers.managerYriyNumberLocalizable", comment: "")
//  let managerAlexeyNumberLocalizableName =  NSLocalizedString("ContactsTableViewController.mobileNumbers.managerAlexeyNumberLocalizable", comment: "")
  
  let officeNumbers = [NSLocalizedString("ContactsTableViewController.officeNumbers.officeNumberLocalizable", comment: ""),
                       NSLocalizedString("ContactsTableViewController.officeNumbers.mtsNumberLocalizable", comment: ""),
                       NSLocalizedString("ContactsTableViewController.officeNumbers.lifecellNumberLocalizable", comment: "")]
  
  
//  let officeNumbers = ["Офис (044) 503-06-60",
//                       "МТС (050) 814-83-33",
//                       "Lifecell (093) 000-18-64"]
  
  let mobileNumbers = [NSLocalizedString("ContactsTableViewController.mobileNumbers.managerEvgeniyLocalizable", comment: ""),
                       NSLocalizedString("ContactsTableViewController.mobileNumbers.managerYriyNumberLocalizable", comment: ""),
                       NSLocalizedString("ContactsTableViewController.mobileNumbers.managerAlexeyNumberLocalizable", comment: "")]
  
//  let mobileNumbers = ["Евгений: (067) 214-34-04",
//                       "Юрий: (067) 327-94-92",
//                       "Алексей: (067) 441-16-44"]
// 
  
  @objc func showMapDidTap() {
    let destination = MapViewController()
    navigationController?.pushViewController(destination, animated: true)
  }
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      tableView = UITableView(frame: CGRect.zero, style: .grouped)
      
      tableView.backgroundColor = UIColor.white
    
      tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: "Cell")
      
      tableView.separatorStyle = .none
      
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("ContactsTableViewController.navigationItem.rightBarButtonItem.title", comment: ""), style: .plain, target: self, action: #selector(showMapDidTap))
      
      navigationItem.rightBarButtonItem?.tintColor = AvalonPalette.avalonBlue
      
       hidingNavigationBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    hidingNavigationBarManager?.viewWillAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    hidingNavigationBarManager?.viewWillDisappear(animated)
  }

  

    override func numberOfSections(in tableView: UITableView) -> Int {
    
        return 3
    }

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      if section == 0 {
        
        return 1
      }
      
      if section == 1 {
        
        return officeNumbers.count
      }
      
      return mobileNumbers.count
    }

  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    if section == 0 {
      
      return NSLocalizedString("HomeViewController.items.contacts", comment: "")
      
    } else if section == 1 {
      
      return NSLocalizedString("ContactsTableViewController.titleForHeaderInSection.one", comment: "")//"Офисные телефоны"
      
    } else if section == 2 {
      
      return NSLocalizedString("ContactsTableViewController.titleForHeaderInSection.two", comment: "")//"Телефоны менеджеров"
    }
    
    return ""
  }
  
  
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    
    let header = view as! UITableViewHeaderFooterView
    
    if section == 0 {
      
      header.textLabel?.text = NSLocalizedString("HomeViewController.items.contacts", comment: "")
      header.textLabel?.font = UIFont.systemFont(ofSize: 34)
      header.textLabel?.textColor = UIColor.black
      
    } else if section == 1 {
      
      header.textLabel?.text = NSLocalizedString("ContactsTableViewController.titleForHeaderInSection.one", comment: "")//"Офисные телефоны"
      header.textLabel?.font = UIFont.systemFont(ofSize: 20)
      header.textLabel?.textColor = UIColor.black
      
    } else if section == 2 {
      
      header.textLabel?.text = NSLocalizedString("ContactsTableViewController.titleForHeaderInSection.two", comment: "")//"Телефоны менеджеров"
      header.textLabel?.font = UIFont.systemFont(ofSize: 20)
      header.textLabel?.textColor = UIColor.black
    }
  }
  
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if indexPath.section == 0 {
      
      return 170
    }
    
    return 55
  }
  
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    if section == 1 {
      return 40
    }
    return 20
  }
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 65
    }
    return 20
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContactsTableViewCell
      
      if indexPath.section == 0 {
        
        cell.contentTextView.text = headerText

      }
      
      if indexPath.section == 1 {
        cell.contentTextView.text = officeNumbers[indexPath.row]
        
      }
      
      if indexPath.section == 2{
        cell.contentTextView.text = mobileNumbers[indexPath.row]
      }

        return cell
    }
}
