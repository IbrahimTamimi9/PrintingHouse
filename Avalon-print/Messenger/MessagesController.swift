//
//  MessagesController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 3/25/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import Firebase

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class MessagesController: UITableViewController {

    let cellId = "cellId"
  
    var timer: Timer?
  
    var messages = [Message]()
  
    var messagesDictionary = [String: Message]()
  
  
     override func viewDidLoad() {
        super.viewDidLoad()
      
        observeUserMessages()
      
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
      
        tableView.allowsMultipleSelectionDuringEditing = true
      
        navigationItem.title = "Сообщения"
      
        tableView.backgroundColor = UIColor.white
      
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new_message_icon"), style: .plain, target: self, action: #selector(handleNewMessage))
    }

  
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
  
  
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let message = self.messages[(indexPath as NSIndexPath).row]
        
        if let chatPartnerId = message.chatPartnerId() {
            Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue(completionBlock: { (error, ref) in
                
                if error != nil {
                    print("Failed to delete message:", error as Any)
                    return
                }
                
                self.messagesDictionary.removeValue(forKey: chatPartnerId)
                self.handleReloadTable()
              
            })
        }
    }
  
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
  
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
     
        let message = messages[indexPath.row]
            cell.message = message
   
        return cell
    }

  
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
  

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
      
    
        let ref = Database.database().reference().child("users").child(chatPartnerId)
      
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
          
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User()
            user.id = chatPartnerId
            user.setValuesForKeys(dictionary)
            self.showChatControllerForUser(user)
            
        }, withCancel: nil)
    }
  
    
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }

 
  
    func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
            chatLogController.user = user
            self.navigationController?.pushViewController(chatLogController, animated: true)
     
    }
}


extension MessagesController {  /* firebase */
  
  func observeUserMessages() {
    guard let uid = Auth.auth().currentUser?.uid else {
      return
    }
    
    let ref = Database.database().reference().child("user-messages").child(uid)
    
    ref.observe(.childAdded, with: { (snapshot) in
      
      let userId = snapshot.key
      
      Database.database().reference().child("user-messages").child(uid).child(userId).queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot) in
        
        print("new message")
        let messageId = snapshot.key
        
        self.fetchMessageWithMessageId(messageId)
        
      }, withCancel: nil)
      
    }, withCancel: nil)
    
    
    
    ref.observe(.childRemoved, with: { (snapshot) in
      print(snapshot.key)
      print(self.messagesDictionary)
      
      self.messagesDictionary.removeValue(forKey: snapshot.key)
     // self.attemptReloadOfTable()
      self.handleReloadTable()
      
    }, withCancel: nil)
  }
  
  
  func fetchMessageWithMessageId(_ messageId: String) {
    
    let messagesReference = Database.database().reference().child("messages").child(messageId)
    
    messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
      
      if let dictionary = snapshot.value as? [String: AnyObject] {
        
        let message = Message(dictionary: dictionary)
        
        if let chatPartnerId = message.chatPartnerId() {
          self.messagesDictionary[chatPartnerId] = message
        }
        
       // self.attemptReloadOfTable()
        self.handleReloadTable()
      }
      
    }, withCancel: nil)
  }
  
//  fileprivate func attemptReloadOfTable() {
//    self.timer?.invalidate()
//    
//    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
//  }
  
  
  func handleReloadTable() {
    messages = Array(self.messagesDictionary.values)
    
    messages.sort(by: { (message1, message2) -> Bool in
      
      return message1.timestamp?.int32Value > message2.timestamp?.int32Value
    })
    
    //this will crash because of background thread, so lets call this on dispatch_async main thread
    DispatchQueue.main.async(execute: {
      self.tableView.reloadData()
    })
  }
}
