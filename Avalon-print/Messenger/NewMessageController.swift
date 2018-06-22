//
//  NewMessageController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 3/25/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseAuth

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    
    var users = [User]()

  
    override func viewDidLoad() {
        super.viewDidLoad()
    
      navigationController?.navigationBar.barStyle = UIBarStyle.default
      navigationController?.navigationBar.isTranslucent = false
      navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain , target: self, action: #selector(handleCancel))
        
      tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
      fetchUser()
    }
  

      func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
          
          if let dictionary = snapshot.value as? [String: AnyObject] {
            let user = User(dictionary: dictionary)
            user.id = snapshot.key
            
            if user.type != "user" {
              self.users.append(user)
            }
          
            DispatchQueue.main.async(execute: {
              self.tableView.reloadData()
            })
          }
          
        }, withCancel: nil)
      }
  
  
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
  
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
  
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
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
