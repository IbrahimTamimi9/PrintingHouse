//
//  UserCell.swift
//  Avalon-print
//
//  Created by Roman Mizin on 3/25/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//


import UIKit
import Firebase


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
          
            let ref = Database.database().reference().child("users").child(id)
          
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
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 32
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        //label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
  
  
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
     
        addSubview(profileImageView)
        addSubview(timeLabel)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 63).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 63).isActive = true
      
        timeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        timeLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 3).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 58).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
    }
  
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
  
    override func layoutSubviews() {
        super.layoutSubviews()
      
      let tlWidth = screenSize.width - profileImageView.frame.width - timeLabel.frame.width - 45
      let detailTLWidth = screenSize.width - profileImageView.frame.width - 40
      textLabel?.frame = CGRect(x: 90, y: textLabel!.frame.origin.y - 15, width: tlWidth , height: textLabel!.frame.height)
      textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
      detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
      detailTextLabel?.textColor = UIColor.lightGray
      detailTextLabel?.frame = CGRect(x: 90, y: textLabel!.frame.origin.y + 20, width: detailTLWidth, height: detailTextLabel!.frame.height)
  }
  
  

}
