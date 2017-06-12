//
//  NewMessageController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 3/25/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    
    var users = [User]()

  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      navigationController?.navigationBar.tintColor = UIColor.white
      navigationController?.navigationBar.barStyle = UIBarStyle.black
      navigationController?.navigationBar.isTranslucent = false
      //tableView.separatorInset = .init(top: 0, left: 35, bottom: 0, right: 0)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain , target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
  
  
    func fetchUser() {
      
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = snapshot.key
                
                //if you use this setter, your app will crash if your class properties don't exactly match up with the firebase dictionary keys
                user.setValuesForKeys(dictionary)
              
              if user.type != "user" {
                self.users.append(user)
              }
              
                //this will crash because of background thread, so lets use dispatch_async to fix
                DispatchQueue.main.async(execute: { 
                    self.tableView.reloadData()
                })
                
//                user.name = dictionary["name"]
            }
            
            }, withCancel: nil)
    }
  
  
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
  
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
  
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        cell.disclosureIndicator.isHidden = true
        
        if let profileImageUrl = user.profileImageUrl {            
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        return cell
    }
  
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
  
  
    var messagesController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { 
            print("Dismiss completed")
            let user = self.users[(indexPath as NSIndexPath).row]
            self.messagesController?.showChatControllerForUser(user)
        }
    }
}