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
        imageView.layer.cornerRadius = 27
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "UserpicIcon")
    
        return imageView
    }()
  
  let newMessageIndicator: UIImageView = {
    let newMessageIndicator = UIImageView()
    newMessageIndicator.translatesAutoresizingMaskIntoConstraints = false
    newMessageIndicator.layer.masksToBounds = true
    newMessageIndicator.contentMode = .scaleAspectFill
    newMessageIndicator.isHidden = true
    newMessageIndicator.image = UIImage(named: "Oval")
    
    return newMessageIndicator
  }()
  
    let timeLabel: UILabel = {
        let label = UILabel()
        //label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.lightGray

        return label
    }()
  
  
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
     
        addSubview(profileImageView)
        addSubview(newMessageIndicator)
        addSubview(timeLabel)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 26).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 54).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 54).isActive = true
      
        newMessageIndicator.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 7).isActive = true
        newMessageIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        newMessageIndicator.widthAnchor.constraint(equalToConstant: 12).isActive = true
        newMessageIndicator.heightAnchor.constraint(equalToConstant: 12).isActive = true
    }
  
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
  
    override func layoutSubviews() {
        super.layoutSubviews()
      
      let tlWidth = screenSize.width - profileImageView.frame.width - timeLabel.frame.width - 45
      let detailTLWidth = screenSize.width - profileImageView.frame.width - 50
      
      textLabel?.frame = CGRect(x: 92, y: 12, width: tlWidth , height: textLabel!.frame.height)
      
      detailTextLabel?.frame = CGRect(x: 92, y: 35, width: detailTLWidth, height: detailTextLabel!.frame.height)
      
      timeLabel.frame = CGRect(x: frame.width - 70, y: 12, width: 70 , height: textLabel!.frame.height)
      
      textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
      detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
      detailTextLabel?.textColor = UIColor.lightGray
      detailTextLabel?.numberOfLines = 2
  }
}
