//
//  InformationTableViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/24/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class InformationTableViewController: UITableViewController {
  
  let informationTitles = [NSLocalizedString("InformationTableViewController.cellTitle.paymentAndDelivery", comment: ""),  //"Оплата и доставка",
                           NSLocalizedString("InformationTableViewController.cellTitle.requirementsToLayouts", comment: ""),  //"Требования к макетам",
                           NSLocalizedString("InformationTableViewController.cellTitle.layoutDesignDevlopment", comment: ""),  //"Разработка макетов",
                           NSLocalizedString("InformationTableViewController.forAdvertisingAgencies", comment: "")]  //"РА и посредникам"]
  var titleToPass = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: CGRect.zero, style: .grouped)
      
        tableView.backgroundColor = UIColor.white
      
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return informationTitles.count
    }
  
  
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("HomeViewController.items.information", comment: "")
    }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 65
  }
  
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
    
        header.textLabel?.text = NSLocalizedString("HomeViewController.items.information", comment: "")
        header.textLabel?.font = UIFont.systemFont(ofSize: 34)
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.backgroundColor = tableView.backgroundColor
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default , reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
      cell.backgroundColor = self.view.backgroundColor
      
        cell.textLabel?.text = informationTitles[indexPath.row]
    
        return cell
    }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      titleToPass =  informationTitles[indexPath.row]
      let destination = DetailInformationViewController()
      destination.informationTitle = titleToPass
      navigationController?.pushViewController(destination, animated: true)
  }
    

}
