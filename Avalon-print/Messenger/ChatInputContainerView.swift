//
//  ChatInputContainerView.swift
//  gameofchats
//
//  Created by Brian Voong on 8/10/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit



class ChatInputContainerView: UIView, UITextViewDelegate {
    
    weak var chatLogController: ChatLogController? {
        didSet {
            sendButton.addTarget(chatLogController, action: #selector(ChatLogController.handleSend), for: .touchUpInside)
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: chatLogController, action: #selector(ChatLogController.handleUploadTap)))
        }
    }
  
  
  func textViewDidChange(_ textView: UITextView) {
      placeholderLabel.isHidden = !textView.text.isEmpty
   self.updateConstraints()
      if textView.text == nil || textView.text == "" {
        sendButton.isEnabled = false
      } else {
        sendButton.isEnabled = true
      }
        chatLogController?.isTyping = textView.text != ""
    
    if textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
       sendButton.isEnabled = false
    }

  }
  

  
  let istypingLabel: UILabel = {
    let istypingLabel = UILabel()
     istypingLabel.isHidden = true
    istypingLabel.text = ""
    istypingLabel.translatesAutoresizingMaskIntoConstraints = false
    istypingLabel.font = UIFont.systemFont(ofSize: 11)
    istypingLabel.textColor = UIColor.gray
    
    return istypingLabel
  }()
  

 
    lazy var inputTextView: UITextView = {
        let textView = UITextView()
      
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.sizeToFit()
    
      textView.isScrollEnabled = false
      textView.layer.borderColor = UIColor.lightGray.cgColor
      textView.layer.borderWidth = 0.3
      textView.layer.cornerRadius = 16
      textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 30)
    return textView
    }()
  
  
  let placeholderLabel: UILabel = {
  
    let placeholderLabel = UILabel()
    placeholderLabel.text = "Сообщение"

    placeholderLabel.sizeToFit()
    placeholderLabel.textColor = UIColor.lightGray
   
    
    return placeholderLabel
  }()
  
    
    let uploadImageView: UIImageView = {
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "upload_image_icon")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        return uploadImageView
    }()
    
    let sendButton = UIButton(type: .system)
  
 
  

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        backgroundColor = .white

        
        addSubview(uploadImageView)
        //x,y,w,h
        uploadImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
      
        sendButton.setImage(UIImage(named: "send"), for: UIControlState())
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.isEnabled = false
       // sendButton.tintColor = UIColor(red:0.00, green:0.53, blue:0.80, alpha:1.0)
      
      
      addSubview(inputTextView)
      //x,y,w,h
      inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
      inputTextView.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
      inputTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
      
      inputTextView.addSubview(placeholderLabel)
      placeholderLabel.font = UIFont.systemFont(ofSize: (inputTextView.font?.pointSize)!)
      placeholderLabel.frame.origin = CGPoint(x: 12, y: (inputTextView.font?.pointSize)! / 2)
      placeholderLabel.isHidden = !inputTextView.text.isEmpty
      
      inputTextView.addSubview(sendButton)
      //x,y,w,h
      sendButton.rightAnchor.constraint(equalTo: rightAnchor, constant: 7).isActive = true
      sendButton.topAnchor.constraint(equalTo: topAnchor, constant: 1).isActive = true
      sendButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
      sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
      
      
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorLineView)
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        //separatorLineView.bottomAnchor.constraint(equalTo: inputTextView.topAnchor, constant: -5).isActive = true
        separatorLineView.topAnchor.constraint(lessThanOrEqualTo: topAnchor).isActive  = true
        separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 0).isActive = true
     
      
      addSubview(istypingLabel)
      self.istypingLabel.bottomAnchor.constraint(equalTo: separatorLineView.topAnchor, constant: -2).isActive = true
      self.istypingLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
      self.istypingLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
      self.istypingLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

  
}

extension ChatInputContainerView: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    chatLogController?.handleSend()
    return true
  }
  
}

extension UIColor {
  
  convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
    self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
  }
}
