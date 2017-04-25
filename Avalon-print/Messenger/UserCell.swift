//
//  UserCell.swift
//  gameofchats
//
//  Created by Brian Voong on 7/8/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase


  var onceOnly = false

class UserCell: UITableViewCell {
  
    var message: Message? {
        didSet {
            setupNameAndProfileImage()
            
            detailTextLabel?.text = message?.text
          
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                timeLabel.text = dateFormatter.string(from: timestampDate)
            }
        }
    }
    
    fileprivate func setupNameAndProfileImage() {
        
        if let id = message?.chatPartnerId() {
            let ref = FIRDatabase.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.textLabel?.text = dictionary["name"] as? String
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                }
                
                }, withCancel: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
      
        textLabel?.frame = CGRect(x: 82, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width * 2, height: textLabel!.frame.height)
        textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        detailTextLabel?.textColor = UIColor.lightGray
        detailTextLabel?.frame = CGRect(x: 82, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width * 2, height: detailTextLabel!.frame.height)
     
    }
  
  

    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 32
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
  
//  let newMessagesCounter: UILabel = {
//    let label = UILabel()
//    label.font = UIFont.systemFont(ofSize: 14)
//    label.textColor = UIColor.lightGray
//   // label.frame = CGRect(x: 160, y: 20, width: 20, height: 20)
//    label.text = "1"
//    label.translatesAutoresizingMaskIntoConstraints = false
//    
//    return label
//  }()

    let timeLabel: UILabel = {
        let label = UILabel()
//        label.text = "HH:MM:SS"
        label.font = UIFont (name: "HelveticaNeue-Light", size: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
       // addSubview(newMessagesCounter)
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 65).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        //need x,y,width,height anchors
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 35).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 28).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
      
//      newMessagesCounter.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 35).isActive = true
//      newMessagesCounter.topAnchor.constraint(equalTo: self.topAnchor, constant: 58).isActive = true
//      newMessagesCounter.widthAnchor.constraint(equalToConstant: 100).isActive = true
//      newMessagesCounter.heightAnchor.constraint(equalTo: (detailTextLabel?.heightAnchor)!).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
