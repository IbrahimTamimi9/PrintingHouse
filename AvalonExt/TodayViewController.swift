//
//  TodayViewController.swift
//  AvalonExt
//
//  Created by Roman Mizin on 1/18/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import NotificationCenter

   var defaults = UserDefaults(suiteName: "group.mizin.Avalon-print")!
   var currentLoginState = String()

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var avalonTableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults.synchronize()
        avalonTableView.separatorStyle = .none
        avalonTableView.dataSource = self
        avalonTableView.delegate = self
        
        loadAsync()
     
    }
    
    func loadAsync () {
        
         if (defaults.object(forKey: "loggedIn") as? Bool) == true {
            currentLoginState = "Статус вашего заказа: Доставляется. \nВаш менеджер: Эвгений \nКонтактный номер вашего менеджера: 063-123-45-67"
            
         } else {
            currentLoginState = "Вход"
        }
    
        DispatchQueue.main.async {
            self.avalonTableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
         defaults.synchronize()
        
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
            cell.textLabel?.text = currentLoginState
       
      return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { //Avalon-printSecond
            
            if (defaults.object(forKey: "loggedIn") as? Bool) == true {
                
                let myAppUrl = NSURL(string: "Avalon-printSecond://UserProfile")!
                extensionContext?.open(myAppUrl as URL, completionHandler: { (success) in
                    if (!success) {
                        print("ass")
                    }
                })
                
                
            } else {
                let myAppUrl = NSURL(string: "Avalon-print://LoginViewController")!
                extensionContext?.open(myAppUrl as URL, completionHandler: { (success) in
                    if (!success) {
                        print("ass")
                    }
                })
            }
        }
    }
    
  
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        loadAsync()
        completionHandler(NCUpdateResult.newData)
    }
    
}
