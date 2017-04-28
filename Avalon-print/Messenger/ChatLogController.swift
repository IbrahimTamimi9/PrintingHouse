//
//  ChatLogController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 3/25/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation
import FirebaseStorage


extension Array where Element:Equatable {
  func removeDuplicates() -> [Element] {
    var result = [Element]()
    
    for value in self {
      if result.contains(value) == false {
        result.append(value)
      }
    }
    
    return result
  }
}


 private var sentMessageDataToId = ""
 private var snapStatus = ""

 private var messageStatus: UILabel = {
    let messageStatus = UILabel()
  
      messageStatus.frame = CGRect(x: 10, y: 10, width: 200, height: 20)
      messageStatus.text = "working on it"
      messageStatus.font = UIFont.systemFont(ofSize: 10)
      messageStatus.textColor = UIColor.darkGray
      //messageStatus.translatesAutoresizingMaskIntoConstraints = false
      //messageStatus.backgroundColor = UIColor.clear
      //messageStatus.textAlignment = .right
  
    return messageStatus
}()



class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  
    var user: User? {
        didSet {
            observeMessages()
            navigationItem.title = user?.name
        }
    }

    let cellId = "cellId"
    var messages = [Message]()
    var finishKey = [String]()
    var onlyForNewMessages = false
  
    var startKey: String? = nil
    var endKey: String? = nil
  
    var paginatioManager: PaginationManager!

    var sentMessageDataFromId = ""
  
  
  
  fileprivate func startCollectionViewAtBottom () {
    
    let collectionViewInsets: CGFloat = (collectionView?.contentInset.bottom)! + inputContainerView.inputTextView.frame.height + 1/*separatorLineView*/
    //self.collectionView?.layoutIfNeeded()
    let contentSize = self.collectionView?.collectionViewLayout.collectionViewContentSize
    if Double((contentSize?.height)!) > Double((self.collectionView?.bounds.size.height)!) {
      let targetContentOffset = CGPoint(x: 0.0, y: (contentSize?.height)! - (((self.collectionView?.bounds.size.height)! - collectionViewInsets)))
      self.collectionView?.contentOffset = targetContentOffset
    }
  }
  
  

  func observeMessages() {
 
    guard let uid = FIRAuth.auth()?.currentUser?.uid, let toId = user?.id else {
         return
    }
    
    let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid).child(toId)
   
    
    let numberOfMessagesForFirsLoad = 15
    var messageIdArray = [String]()
    
    
    userMessagesRef.queryLimited(toLast: UInt(numberOfMessagesForFirsLoad)).observe(.childAdded, with: { (snapshot) in
      print("CHILD ADDDDDDEDDD    ")
      
    if self.sentMessageDataFromId == uid {
      
      self.sentMessageDataFromId = ""
     
    } else {
      
      let messageId = snapshot.key
  
      messageIdArray.append(messageId)
      
      if self.firstLoadIdTaken == false {
        self.endKey = messageId
        self.firstLoadIdTaken = true
      }
      
      let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
      self.updateMessageStatus(messagesRef: messagesRef)
     
      
    
      
      messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
      self.updateMessageStatus(messagesRef: messagesRef)
        
        
        
        guard let dictionary = snapshot.value as? [String: AnyObject] else {
          return
        }

  
        self.messages.append(Message(dictionary: dictionary))
       
        if self.onlyForNewMessages == true {
          
          self.collectionView?.reloadData()
          
           let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
          
          if self.messages.count - 1 > 0 {
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true /*self.onlyForNewMessages*/)

          }
        }
        
        
        if (self.messages.count == messageIdArray.count) && (!self.onlyForNewMessages) {
          self.collectionView?.reloadData()
          self.startCollectionViewAtBottom()
        }

      })
      
    }//else
      
  })
    
 }
  
  
  
  var firstIdTaken = false
  var firstLoadIdTaken = false
  let autoSizingCollectionViewFlowLayout = AutoSizingCollectionViewFlowLayout()
  
  func loadPreviousMessages () {
    
    guard let uid = FIRAuth.auth()?.currentUser?.uid, let toId = user?.id else {
      return
    }
    
    var count = 15
    
    var userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid).child(toId)
       .queryOrderedByKey()
    
    if self.endKey != nil {
      userMessagesRef = userMessagesRef.queryEnding(atValue: self.endKey)
      count += 1
    }
  
    userMessagesRef.queryLimited(toLast: UInt(count)).observe(.childAdded, with: { (snapshot) in

      
      let messageId = snapshot.key
      
      if self.firstIdTaken == false {
         self.endKey = messageId
         self.firstIdTaken = true
      }
     
      let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
          messagesRef.observeSingleEvent( of: .value, with: { (snapshot) in
 
      guard let dictionary = snapshot.value as? [String: AnyObject] else {
          return
        }
        
     self.messages.append(Message(dictionary: dictionary))

            
            var res: [Message] = []
            self.messages.forEach { (p) -> () in
              if !res.contains (where: { $0.timestamp == p.timestamp }) {
                res.append(p)
                self.messages.removeAll()
                self.messages.append(contentsOf: res)
              }
            }
        
            
      self.messages.sort(by: { (message1, message2) -> Bool in
        
          return message2.timestamp as! Int > message1.timestamp as! Int
      })
            
            
            isInsertingCellsToTop = true
            contentSizeWhenInsertingToTop = self.collectionView?.contentSize
            self.collectionView?.reloadData()
         
      }, withCancel: nil)
   
    }, withCancel: nil)
    
  }
  
  
  var userIsTypingRef = FIRDatabase.database().reference().child("user-messages").child("typingIndicator").child((FIRAuth.auth()?.currentUser?.uid)!)
  private var localTyping = false
  var isTyping: Bool {
    get {
      return localTyping
    }
    
    set {
      var currentInterlocutorId = String()
      
      if newValue {
        currentInterlocutorId = (user?.id)!
      } else {
        currentInterlocutorId = ""
      }
      
      localTyping = newValue
      
      let typingData: NSDictionary = ["Is typing" : newValue,
                                      "Typing to" : currentInterlocutorId ]
      userIsTypingRef.setValue(typingData)
    }
  }
  
  
  
  private lazy var usersTypingQuery = FIRDatabaseQuery()
  
  func observeTyping() {
    
    let typingIndicatorRef = FIRDatabase.database().reference().child("user-messages").child("typingIndicator")
    
    userIsTypingRef = typingIndicatorRef.child((FIRAuth.auth()?.currentUser?.uid)!)
    userIsTypingRef.onDisconnectRemoveValue()
    
    usersTypingQuery.observe(.value) { (data: FIRDataSnapshot) in
      
      if data.childrenCount == 1 && self.isTyping  {
        return
      }
      
        
    let interlocutorRef = FIRDatabase.database().reference().child("user-messages").child("typingIndicator").child((self.user?.id!)!).child("Typing to")
        
        interlocutorRef.observe(.value, with: { (interlocutorId) in
          
        let currentInterlocutor = FIRAuth.auth()?.currentUser?.uid
          
            if let interlocutorIdValue = interlocutorId.value as? String {
              print("\n", interlocutorIdValue, "\n", currentInterlocutor! , "\n")
            
              if interlocutorIdValue == currentInterlocutor! {
                print("interlocutorIdValue == currentInterlocutor!")
                self.inputContainerView.istypingLabel.isHidden = false
              
              } else {
              
                print("interlocutorIdValue != currentInterlocutor!")
                self.inputContainerView.istypingLabel.isHidden = true
              }
            
            } else {
            
              print("interlocutorIdValue !!= currentInterlocutor!")
              self.inputContainerView.istypingLabel.isHidden = true
            }
        })
     }
  }
  
  
  
  fileprivate func updateMessageStatus(messagesRef: FIRDatabaseReference) {
    
    messagesRef.child("toId").observeSingleEvent(of: .value, with: { (snapshot) in
      
      
      if snapshot.value != nil {
        sentMessageDataToId = snapshot.value as! String
      }
      
      
      if (FIRAuth.auth()?.currentUser?.uid)! == sentMessageDataToId {
        
        if self.navigationController?.visibleViewController is ChatLogController {
          
          print("EQUALSSSSS!!!!!!!!!!")
          messagesRef.updateChildValues(["status" : "Прочитано"])
          
        } else {
          
          messagesRef.updateChildValues(["status" : "Доставлено"])
        }
        
      } else {
        
        sentMessageDataToId = ""
      }
      
    })
    
    
    messagesRef.observe(.childChanged, with: { (snapshot) in
      
      if FIRAuth.auth()?.currentUser?.uid != sentMessageDataToId {
        
        print("\n\n\n child CHANGED")
        print("\n\n\\n",snapshot.value!)
        
        if snapshot.value != nil {
          snapStatus = snapshot.value as! String
          
          DispatchQueue.main.async(execute: {
            messageStatus.text = snapStatus
          })
          
        }
      }
      
   })
 }
  
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
       
      
      //  self.view.addSubview(messageStatus)
       self.inputContainerView.istypingLabel.text = "\(String(describing: (user?.name)!)) печатает..."
      
        let currentInterlocutor = user?.id
        let newBackButton = UIBarButtonItem(image: UIImage(named: "ChevronLeft.png"), style: .plain, target: self, action: #selector(self.leftBarButtonAction(sender:)))
      
        usersTypingQuery = FIRDatabase.database().reference().child("user-messages").child("typingIndicator").child(currentInterlocutor!).queryOrderedByValue().queryEqual(toValue: true)
      
        collectionView?.isPrefetchingEnabled = true
        collectionView?.collectionViewLayout = AutoSizingCollectionViewFlowLayout()
      
        setupKeyboardObservers()
        setupCallBarButtonItem()
      
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
      
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.keyboardDismissMode = .interactive
      
      
        self.paginatioManager = PaginationManager(scrollView: collectionView, delegate: self)
        self.navigationItem.leftBarButtonItem = newBackButton
      
     
      
    }
  
 
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    

        observeTyping()
        onlyForNewMessages  = true
    }
  
  
  
    
    lazy var inputContainerView: ChatInputContainerView = {
        let chatInputContainerView = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        chatInputContainerView.chatLogController = self
      
        return chatInputContainerView
    }()
  
  
    func setupCallBarButtonItem () {
    
        let callBarButtonItem = UIBarButtonItem(image: UIImage(named: "call"), style: .plain, target: self, action: #selector(makeACall))
        self.navigationItem.rightBarButtonItem  = callBarButtonItem
    }
  
  
    func makeACall () {
    
        let number = user?.phoneNumber
        let phoneCallURL:URL = URL(string: "tel://\(number!)")!
        UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
    }
  
  
    func leftBarButtonAction(sender: UIBarButtonItem) {
      
        isTyping = false
        _ = navigationController?.popViewController(animated: true)
    }
  
 
    func handleUploadTap() {
      
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        
        present(imagePickerController, animated: true, completion: nil)
    }
  
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            //we selected a video
            handleVideoSelectedForUrl(videoUrl)
        } else {
            //we selected an image
            handleImageSelectedForInfo(info as [String : AnyObject])
        }
        
        dismiss(animated: true, completion: nil)
    }
  
  
    fileprivate func handleVideoSelectedForUrl(_ url: URL) {
        let filename = UUID().uuidString + ".mov"
        let uploadTask = FIRStorage.storage().reference().child("message_movies").child(filename).putFile(url, metadata: nil, completion: { (metadata, error) in
            
            if error != nil {
                print("Failed upload of video:", error as Any)
                return
            }
            
            if let videoUrl = metadata?.downloadURL()?.absoluteString {
                if let thumbnailImage = self.thumbnailImageForFileUrl(url) {
                    
                    self.uploadToFirebaseStorageUsingImage(thumbnailImage, completion: { (imageUrl) in
                        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": thumbnailImage.size.width as AnyObject, "imageHeight": thumbnailImage.size.height as AnyObject, "videoUrl": videoUrl as AnyObject]
                        self.sendMessageWithProperties(properties)
                        
                    })
                }
            }
        })
        
        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnitCount)
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            self.navigationItem.title = self.user?.name
        }
    }
  
  
    fileprivate func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
        
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
            
        } catch let err {
            print(err)
        }
        
        return nil
    }
  
  
    fileprivate func handleImageSelectedForInfo(_ info: [String: AnyObject]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(selectedImage, completion: { (imageUrl) in
                self.sendMessageWithImageUrl(imageUrl, image: selectedImage)
            })
        }
    }
  
  
    fileprivate func uploadToFirebaseStorageUsingImage(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
        let imageName = UUID().uuidString
        let ref = FIRStorage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image:", error as Any)
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    completion(imageUrl)
                }
                
            })
        }
    }
  
  
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
  
  
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
  
  
    override var canBecomeFirstResponder : Bool {
        return true
    }
  
  
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
  
  
    func handleKeyboardDidShow() {
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
  
  
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
  
 
    func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = ((notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
      
        containerViewBottomAnchor?.constant = -keyboardFrame!.height

        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
  
  
    func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = ((notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
      
        containerViewBottomAnchor?.constant = 0
    
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        }) 
    }
  
  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
  
  
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
      
        
        cell.chatLogController = self
      
        let message = messages[(indexPath as IndexPath).item]
      
        cell.message = message
      
        cell.textView.text = message.text
        
        setupCell(cell, message: message)
        
        if let text = message.text {
            //a text message
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text).width + 28
            cell.textView.isHidden = false
        } else if message.imageUrl != nil {
            //fall in here if its an image message
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        
           cell.playButton.isHidden = message.videoUrl == nil
      
        return cell
    }
  
  
    fileprivate func setupCell(_ cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
      
      
        if message.fromId == FIRAuth.auth()?.currentUser?.uid {
          
            //outgoing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
          
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            messageStatus.isHidden = false
          
        } else {
          
            //incoming gray
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = true
    
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            messageStatus.isHidden = true
        }
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingCacheWithUrlString(messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        
        } else {
            cell.messageImageView.isHidden = true
        }
    }
  
  
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
  
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        let message = messages[(indexPath as NSIndexPath).item]
        if let text = message.text {
            height = estimateFrameForText(text).height + 16
          
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            
            // h1 / w1 = h2 / w2
            // solve for h1
            // h1 = h2 / w2 * w1
            
            height = CGFloat(imageHeight / imageWidth * 200)
            
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
  
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)], context: nil)
    }
  
  
    var containerViewBottomAnchor: NSLayoutConstraint?
  
  
    func handleSend() {
      
      inputContainerView.sendButton.isEnabled = false
        let properties = ["text": inputContainerView.inputTextView.text!]
        sendMessageWithProperties(properties as [String : AnyObject])
      
      isTyping = false
      inputContainerView.placeholderLabel.isHidden = false
      
    }
  
  
    fileprivate func sendMessageWithImageUrl(_ imageUrl: String, image: UIImage) {
        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": image.size.width as AnyObject, "imageHeight": image.size.height as AnyObject]
        sendMessageWithProperties(properties)
    }
  
  
    fileprivate func sendMessageWithProperties(_ properties: [String: AnyObject]) {
      
        self.inputContainerView.inputTextView.text = nil
      
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let messageStatusForSending = "Отправлено"
      
    
        let toId = user!.id!
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp = NSNumber(value: Int(Date().timeIntervalSince1970))
      
        sentMessageDataFromId = fromId
      
        
        var values: [String: AnyObject] = ["toId": toId as AnyObject, "status": messageStatusForSending as AnyObject , "fromId": fromId as AnyObject, "timestamp": timestamp]
        
        //append properties dictionary onto values somehow??
        //key $0, value $1
        properties.forEach({values[$0] = $1})
      
        self.updateMessageStatus(messagesRef: childRef)
        self.messages.append(Message(dictionary: values ))
        self.collectionView?.reloadData()
      
       let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
       self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true /*self.onlyForNewMessages*/)
        
        childRef.updateChildValues(values) { (error, ref) in
          
            if error != nil {
                print(error as Any)
                return
            }
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId).child(toId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
           print("= == = === message sent")
          
           self.observeMessageStatus(messageId: messageId)
        }
    }
  
  
    func observeMessageStatus(messageId: String) {
        let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId).child("status")
    
        messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            print("\n\n",snapshot.value!, "\n\n")
    
            DispatchQueue.main.async(execute: {
              
              if snapshot.value != nil {
                messageStatus.text = (snapshot.value as! String)
              }
              
            })
        })
    }
  
  
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
  
  
    //my custom zooming logic
    func performZoomInForStartingImageView(_ startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                self.inputContainerView.alpha = 0
                
                // math?
                // h2 / w1 = h1 / w1
                // h2 = h1 / w1 * w1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                zoomingImageView.center = keyWindow.center
                
                }, completion: { (completed) in
//                    do nothing
            })
        }
    }
  
    
    func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            //need to animate back out to controller
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
                
                }, completion: { (completed) in
                    zoomOutImageView.removeFromSuperview()
                    self.startingImageView?.isHidden = false
              })
          }
      }
}


extension ChatLogController: PaginationManagerDelegate {
  
  public func paginationManagerDidStartLoading(_ controller: PaginationManager, onCompletion: @escaping () -> Void) {
    let delayTime = DispatchTime.now()// + Double(Int64(0.15 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
      
      self.firstIdTaken = false
      self.loadPreviousMessages()
      onCompletion()
    }
  }
  
  public func paginationManagerShouldStartLoading(_ controller: PaginationManager) -> Bool {
    return true
  }
}
