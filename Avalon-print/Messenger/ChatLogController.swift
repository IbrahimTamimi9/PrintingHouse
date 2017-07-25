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



extension Double {
  func getDateStringFromUTC() -> String {
    let date = Date(timeIntervalSince1970: self)
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US")
    dateFormatter.timeStyle = .short// .medium
    
    return dateFormatter.string(from: date)
  }
}

/*
extension Array {
  
  func filterDuplicates( includeElement: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
    var results = [Element]()
    
    forEach { (element) in
      let existingElements = results.filter {
        return includeElement(element, $0)
      }
      if existingElements.count == 0 {
        results.append(element)
      }
    }
    
    return results
  }
}*/

extension Array {
  
  func shift(withDistance distance: Int = 1) -> Array<Element> {
    let offsetIndex = distance >= 0 ?
      self.index(startIndex, offsetBy: distance, limitedBy: endIndex) :
      self.index(endIndex, offsetBy: distance, limitedBy: startIndex)
    
    guard let index = offsetIndex else { return self }
    return Array(self[index ..< endIndex] + self[startIndex ..< index])
  }
  
  mutating func shiftInPlace(withDistance distance: Int = 1) {
    self = shift(withDistance: distance)
  }
  
}

 let userMessagesFirebaseFolder = "userMessages"

 let typingIndicatorID = "typingIndicator"

 let typingIndicatorKeyID = "Is typing"

 private var sentMessageDataToId = ""

 private var snapStatus = ""

 private var messageStatus: UILabel = {
    let messageStatus = UILabel()
  
      messageStatus.frame = CGRect(x: 10, y: 10, width: 200, height: 20)
      messageStatus.text = "working on it"
      messageStatus.font = UIFont.systemFont(ofSize: 10)
      messageStatus.textColor = UIColor.darkGray
  
    return messageStatus
}()


class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  
    var user: User? {
        didSet {
          loadMessages()
          setNavifationTitle(username: user?.name)
        }
    }
  
    let photoMessageCellID = "photoMessageCellID"
  
    let textMessageCellID = "textMessageCellID"
  
    let typingIndicatorID = "typingIndicatorID"
  
    var messages = [Message]()
  
    var sections = ["Messages"]
  
    var finishKey = [String]()
  
    var newMessage = false
  
    var startKey: String? = nil
  
    var endKey: String? = nil
  
    var messageIdArray = [String]()
  
    let messagesToLoad = 50
  

  func startCollectionViewAtBottom () {
    
    let collectionViewInsets: CGFloat = (collectionView!.contentInset.bottom + collectionView!.contentInset.top)// + inputContainerView.inputTextView.frame.height
    
    let contentSize = self.collectionView?.collectionViewLayout.collectionViewContentSize
    if Double(contentSize!.height) > Double(self.collectionView!.bounds.size.height) {
      let targetContentOffset = CGPoint(x: 0.0, y: contentSize!.height - (self.collectionView!.bounds.size.height - collectionViewInsets))
      self.collectionView?.contentOffset = targetContentOffset
    }
  }
  

  var messagesIds = [String]()
  var appendingMessages = [Message]()
  
  var newOutboxMessage = false
  var newInboxMessage = false
  
  typealias CompletionHandler = (_ success: Bool) -> Void
  
  func loadMessages() {
    
    guard let uid = Auth.auth().currentUser?.uid,let toId = user?.id else {
      return
    }
    
    let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId).child(userMessagesFirebaseFolder)
    userMessagesRef.queryLimited(toLast: UInt(messagesToLoad)).observe( .childAdded, with: { (snapshot) in
    self.messagesIds.append(snapshot.key)
     
       let messagesRef = Database.database().reference().child("messages").child(snapshot.key)
       messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
          
        guard let dictionary = snapshot.value as? [String: AnyObject] else {
        print("returning")
            return
        }
        
          switch true {
                
            case self.newOutboxMessage:
              self.newOutboxMessage = false
            
              break
                
            case self.newInboxMessage:
      
              self.collectionView?.performBatchUpdates({ 
                
                 self.messages.append(Message(dictionary: dictionary))
                 let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                 self.collectionView?.insertItems(at: [indexPath])
                
              }, completion: { (true) in
                self.updateMessageStatus(messagesRef: messagesRef)
                let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                
                if self.messages.count - 1 > 0 && self.isScrollViewAtTheBottom {
                  self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }

              })
              
              break
                
            default:
             
              self.appendingMessages.append(Message(dictionary: dictionary))
              
              if self.appendingMessages.count == self.messagesIds.count {

                self.messages = self.appendingMessages
              
                self.messages.sort(by: { (message1, message2) -> Bool in
                  
                  return message1.timestamp!.int32Value < message2.timestamp!.int32Value
                })
                
                  self.collectionView?.reloadData()
                  self.startCollectionViewAtBottom()
                  self.newInboxMessage = true
              
                  DispatchQueue.global(qos: .background).async {
                    self.observeTypingIndicator()
                    self.updateMessageStatus(messagesRef: messagesRef)
                    self.observeMessageStatus(messageId: snapshot.key)
                  }
                
               break
              }
          }
    
        }, withCancel: { (error) in
              print("error loading message")
        })
      
    }, withCancel: { (error) in
          print("error loading message iDS")
    })
 }
  
  
  var queryStartingID = String()
  var queryEndingID = String()
  
  func loadPreviousMessages() {
    
    let numberOfMessagesToLoad = messages.count + messagesToLoad
    let nextMessageIndex = messages.count + 1
    
    guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else {
      return
    }
    
    let startingIDRef = Database.database().reference().child("user-messages").child(uid).child(toId).child(userMessagesFirebaseFolder).queryLimited(toLast: UInt(numberOfMessagesToLoad))
    startingIDRef.observeSingleEvent(of: .childAdded, with: { (snapshot) in
   
      if snapshot.exists() {
          self.queryStartingID = snapshot.key
        print(self.queryStartingID)
      }
      
        let endingIDRef = Database.database().reference().child("user-messages").child(uid).child(toId).child(userMessagesFirebaseFolder).queryLimited(toLast: UInt(nextMessageIndex))
        endingIDRef.observeSingleEvent(of: .childAdded, with: { (snapshot) in
        self.queryEndingID = snapshot.key
          print(self.queryEndingID)
      
          if self.queryStartingID == self.queryEndingID {
            self.refreshControl.endRefreshing()
            print("ALL messages downloaded")
            return
          }
            let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId).child(userMessagesFirebaseFolder).queryOrderedByKey()
            userMessagesRef.queryStarting(atValue: self.queryStartingID).queryEnding(atValue: self.queryEndingID).observe(.childAdded, with: { (snapshot) in
              self.messagesIds.append(snapshot.key)
  
                let messagesRef = Database.database().reference().child("messages").child(snapshot.key)
                messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
          
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                  return
                }
                  
                self.messages.append(Message(dictionary: dictionary))
                  
                    if self.messages.count == self.messagesIds.count {
    
                      var arrayWithShiftedMessages = self.messages
                      
                      let shiftingIndex = self.messagesToLoad - (numberOfMessagesToLoad - self.messagesIds.count )
                      print(-shiftingIndex, "shifting index")
                      
                      arrayWithShiftedMessages.shiftInPlace(withDistance: -shiftingIndex)
            
                      self.messages = arrayWithShiftedMessages
                      
                      contentSizeWhenInsertingToTop = self.collectionView?.contentSize
                      isInsertingCellsToTop = true
                      self.refreshControl.endRefreshing()
                      DispatchQueue.main.async {
                         self.collectionView?.reloadData()
                      }
                     
                    } // if self.messages.count == numberOfMessagesToLoad
              
                 }, withCancel: { (error) in
              
                      print("error loading messages (Message)")
              
                 }) // messagesRef
              
            }) { (error) in
          
                    print("error loading user-messages (ID's)")
    
            } // error
          
          }) // endingIDRef
    })  // startingIDRef
 }
  

  private var localTyping = false
  
  var isTyping: Bool {
    get {
      return localTyping
    }
    
    set {
      localTyping = newValue
      
      let typingData: NSDictionary = [typingIndicatorKeyID : newValue]
      
      sendTypingStatus(data: typingData)
    }
  }
  
  
  func sendTypingStatus(data: NSDictionary) {
    
    guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else {
      return
    }

    let userIsTypingRef = Database.database().reference().child("user-messages").child(uid).child(toId).child(typingIndicatorID)
    userIsTypingRef.setValue(data)
  }
  
  
  func observeTypingIndicator () {
    
    guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else {
      return
    }
    
    let typingIndicatorRef = Database.database().reference().child("user-messages").child(uid).child(toId).child(typingIndicatorID)
    typingIndicatorRef.onDisconnectRemoveValue()
    
    let userTypingToRef = Database.database().reference().child("user-messages").child(toId).child(uid).child(typingIndicatorID).child(typingIndicatorKeyID)
    userTypingToRef.onDisconnectRemoveValue()
    userTypingToRef.observe( .value, with: { (isTyping) in
   
      if let isUserTypingToYou = isTyping.value! as? Bool {
        
        if isUserTypingToYou {
          self.handleTypingIndicatorAppearance(isEnabled: true)
          
        } else {
             self.handleTypingIndicatorAppearance(isEnabled: false)
        }
      } else { /* if typing indicator not exist */
           self.handleTypingIndicatorAppearance(isEnabled: false)
      }
    })
  }
  
  
  fileprivate func handleTypingIndicatorAppearance(isEnabled: Bool) {
    
    let sectionsIndexSet: IndexSet = [1]
    
    if isEnabled {
      self.collectionView?.performBatchUpdates({
        self.sections = ["Messages", "TypingIndicator"]
        self.collectionView?.insertSections(sectionsIndexSet)
      }, completion: { (true) in
      
        let indexPath = IndexPath(row: 0, section: 1)
        
        let isIndexPathValid = self.indexPathIsValid(indexPath: indexPath as NSIndexPath)
        
        if isIndexPathValid && self.isScrollViewAtTheBottom {
            self.collectionView?.scrollToItem(at: indexPath , at: .bottom, animated: true)
        } else {
          return
        }
      })
      
    } else {
      
      self.collectionView?.performBatchUpdates({ 
        self.sections = ["Messages"]
        if self.collectionView!.numberOfSections > 1 {
           self.collectionView?.deleteSections(sectionsIndexSet)
        }
        
       
      }, completion: nil)
    }
  }
  
  
  func indexPathIsValid(indexPath: NSIndexPath) -> Bool {
    if indexPath.section >= self.numberOfSections(in: collectionView!) {
      return false
    }
    if indexPath.row >= collectionView!.numberOfItems(inSection: indexPath.section) {
      return false
    }
    return true
  }
  

  fileprivate func updateMessageStatus(messagesRef: DatabaseReference) {
    
    messagesRef.child("toId").observeSingleEvent(of: .value, with: { (snapshot) in
      
      if snapshot.value != nil {
        sentMessageDataToId = snapshot.value as! String
      }
      
      
      if (Auth.auth().currentUser?.uid)! == sentMessageDataToId {
        
        if self.navigationController?.visibleViewController is ChatLogController {
          
          print("Read")
          messagesRef.updateChildValues(["status" : "Прочитано"])
          
        } else {
          print("Delivered")
          messagesRef.updateChildValues(["status" : "Доставлено"])
        }
        
      } else {
        sentMessageDataToId = ""
      }
      
    })
    
    
    messagesRef.observe(.childChanged, with: { (snapshot) in
      
      if Auth.auth().currentUser?.uid != sentMessageDataToId {
        
        print("\n\n\n child CHANGED")
        print("\n\n\\n",snapshot.value!)
        
        if snapshot.value != nil {
          snapStatus = snapshot.value as! String
            messageStatus.text = snapStatus
        }
      }
      
   })
 }
  
  
  func observeMessageStatus(messageId: String) {
    let messagesRef = Database.database().reference().child("messages").child(messageId).child("status")
    
    messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
      print("\n\n",snapshot.value!, "\n\n")
      
      if snapshot.value != nil {
        messageStatus.text = (snapshot.value as! String)
      }
    })
  }
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupCollectionView()
      
        setupCallBarButtonItem()
      
        setupKeyboardObservers()
    }
  
  
  fileprivate func setupCollectionView () {
    
    let autoSizingCollectionViewFlowLayout = AutoSizingCollectionViewFlowLayout()
    collectionView?.collectionViewLayout = autoSizingCollectionViewFlowLayout
    autoSizingCollectionViewFlowLayout.minimumLineSpacing = 5
    
    collectionView?.keyboardDismissMode = .interactive
    collectionView?.backgroundColor = UIColor.white
    collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
    collectionView?.alwaysBounceVertical = true
    
    collectionView?.addSubview(refreshControl)
    
    collectionView?.register(TextMessageCell.self, forCellWithReuseIdentifier: textMessageCellID)
    collectionView?.register(PhotoMessageCell.self, forCellWithReuseIdentifier: photoMessageCellID)
    collectionView?.register(TypingIndicatorCell.self, forCellWithReuseIdentifier: typingIndicatorID)
  }
  
  
  fileprivate func setNavifationTitle (username: String?) {
    let titleLabel = UILabel(frame: CGRect(x:0, y:0, width: 200, height: 40))
    titleLabel.text = username
    titleLabel.textColor = UIColor.black
    titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    titleLabel.backgroundColor = UIColor.clear
    titleLabel.adjustsFontSizeToFitWidth = true
    titleLabel.textAlignment = .center
    self.navigationItem.titleView = titleLabel
  }

  
  lazy var inputContainerView: ChatInputContainerView = {
    var chatInputContainerView = ChatInputContainerView(frame: CGRect.zero)
    
    let height = chatInputContainerView.inputTextView.frame.height
    chatInputContainerView = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
    chatInputContainerView.chatLogController = self
    
    return chatInputContainerView
  }()
  
    var canRefresh = true

  
  fileprivate var isScrollViewAtTheBottom = true
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
      if collectionView!.contentOffset.y >= (collectionView!.contentSize.height - collectionView!.frame.size.height) {
        isScrollViewAtTheBottom = true
      } else {
        isScrollViewAtTheBottom = false
      }
        if scrollView.contentOffset.y < 0 { //change 100 to whatever you want
          
          if collectionView!.contentSize.height < UIScreen.main.bounds.height - 50 {
            canRefresh = false
            refreshControl.endRefreshing()
          }
          
          if canRefresh && !refreshControl.isRefreshing {
            
            canRefresh = false
            
            refreshControl.beginRefreshing()
            
            performRefresh()
          }
          
        } else if scrollView.contentOffset.y >= 0 {
          canRefresh = true
        }
    }
 
  
    let refreshControl: UIRefreshControl = {
      let refreshControl = UIRefreshControl()
      refreshControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
      //refreshControl.attributedTitle = NSAttributedString(string: "Загрузка", attributes: nil)
      refreshControl.addTarget(self, action: #selector(performRefresh), for: .valueChanged)
      
      return refreshControl
    
    }()
  
  
    func performRefresh () {
      loadPreviousMessages()
    }

  
    func setupCallBarButtonItem () {
    
        let callBarButtonItem = UIBarButtonItem(image: UIImage(named: "call"), style: .plain, target: self, action: #selector(makeACall))
        self.navigationItem.rightBarButtonItem  = callBarButtonItem
    }
  
  
    func makeACall () {
    
        let number = user?.phoneNumber
        let phoneCallURL:URL = URL(string: "tel://\(number!)")!
        UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
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
        let uploadTask = Storage.storage().reference().child("message_movies").child(filename).putFile(from: url, metadata: nil, completion: { (metadata, error) in
            
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
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
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
    isTyping = false
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
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return sections.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if section == 0 {
       return messages.count
    } else {
      return 1
    }
    
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.section == 0 {
       return selectCell(for: indexPath)!
    } else {
      return showTypingIndicator(indexPath: indexPath)!
    }
   
  }
  
  
 fileprivate func showTypingIndicator(indexPath: IndexPath) -> UICollectionViewCell? {
     let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: typingIndicatorID, for: indexPath) as! TypingIndicatorCell
    return cell
  }
  
  
  fileprivate func selectCell(for indexPath: IndexPath) -> UICollectionViewCell? {
    
     let message = messages[indexPath.item]
    
      if let messageText = message.text { /* If current message is a text message */
        
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: textMessageCellID, for: indexPath) as! TextMessageCell
        
          cell.textView.text = messageText
        
  
          if message.fromId == Auth.auth().currentUser?.uid { /* Outgoing message with blue bubble */
            
            cell.bubbleView.image = BaseMessageCell.blueBubbleImage
            
            cell.textView.textColor = UIColor.white
            
            cell.textView.textContainerInset.left = 7
            
            cell.bubbleView.frame = CGRect(x: view.frame.width - estimateFrameForText(messageText).width - 35,
                                           y: 0,
                                           width: estimateFrameForText(messageText).width + 30,
                                           height: cell.frame.size.height).integral
            
            
            cell.textView.frame.size = CGSize(width: cell.bubbleView.frame.width,
                                              height: cell.bubbleView.frame.height)
            
          } else { /* Incoming message with grey bubble */
            
            cell.bubbleView.image = BaseMessageCell.grayBubbleImage
            
            cell.textView.textColor = UIColor.darkText
            
            cell.textView.textContainerInset.left = 12
            
            cell.bubbleView.frame = CGRect(x: 10,
                                           y: 0,
                                           width: estimateFrameForText(messageText).width + 30,
                                           height: cell.frame.size.height).integral
            
             cell.textView.frame.size = CGSize(width: cell.bubbleView.frame.width,
                                               height: cell.bubbleView.frame.height)
          }
        
        return cell
        
      } else if message.imageUrl != nil { /* If current message is a photo/video message */
        
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: photoMessageCellID, for: indexPath) as! PhotoMessageCell
        
          cell.chatLogController = self
          cell.message = message
    
          if message.fromId == Auth.auth().currentUser?.uid { /* Outgoing message with blue bubble */

            cell.bubbleView.frame = CGRect(x: view.frame.width - 210, y: 0, width: 200, height: cell.frame.size.height).integral
            
          } else { /* Incoming message with grey bubble */
            
             cell.bubbleView.frame = CGRect(x: 10, y: 0, width: 200, height: cell.frame.size.height).integral
          }

          DispatchQueue.global(qos: .default).async(execute: {() -> Void in
          if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingCacheWithUrlString(messageImageUrl)
          }
        })
        
        cell.playButton.isHidden = message.videoUrl == nil
        
       
        return cell
      } else {
        return nil
    }
    
  }
  
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      collectionView?.collectionViewLayout.invalidateLayout()
    }
  
  
    fileprivate var cellHeight: CGFloat = 80
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
      if indexPath.section == 0 {
        let message = messages[(indexPath as NSIndexPath).item]
        
        
        if let text = message.text {
          
          cellHeight = estimateFrameForText(text).height + 20
          
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
          
          cellHeight = CGFloat(imageHeight / imageWidth * 200)
        }
        
        return CGSize(width: screenSize.width, height: cellHeight)

        
      } else {
         return CGSize(width: screenSize.width, height: 40)
      }
    }
  
    
    func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
    }
  
  
    var containerViewBottomAnchor: NSLayoutConstraint?
  
    func handleSend() {
      
      inputContainerView.sendButton.isEnabled = false
        let properties = ["text": inputContainerView.inputTextView.text!]
        sendMessageWithProperties(properties as [String : AnyObject])
      
      isTyping = false
      inputContainerView.placeholderLabel.isHidden = false
      inputContainerView.invalidateIntrinsicContentSize()
    }
  
  
    fileprivate func sendMessageWithImageUrl(_ imageUrl: String, image: UIImage) {
        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": image.size.width as AnyObject, "imageHeight": image.size.height as AnyObject]
        sendMessageWithProperties(properties)
    }
  
  
  fileprivate func reloadCollectionViewAfterSending(values: [String: AnyObject]) {
    
    
    self.collectionView?.performBatchUpdates({ 
      self.messages.append(Message(dictionary: values ))
      let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
      self.collectionView?.insertItems(at: [indexPath])
    }, completion: { (true) in
      let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
      self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
    })
  }
  
  
  fileprivate func sendMessageWithProperties(_ properties: [String: AnyObject]) {
    
    self.inputContainerView.inputTextView.text = nil
    
    let ref = Database.database().reference().child("messages")
    
    let childRef = ref.childByAutoId()
    
    let defaultMessageStatus = "Отправлено"
    
    let toId = user!.id!
    
    let fromId = Auth.auth().currentUser!.uid
    
    let timestamp = NSNumber(value: Int(Date().timeIntervalSince1970))
    

    var values: [String: AnyObject] = ["toId": toId as AnyObject, "status": defaultMessageStatus as AnyObject , "fromId": fromId as AnyObject, "timestamp": timestamp]
    
    properties.forEach({values[$0] = $1})
    
    self.reloadCollectionViewAfterSending(values: values)
    
    childRef.updateChildValues(values) { (error, ref) in
      
      if error != nil {
        print(error as Any)
        // here need to notify user that message has not been sent
        return
      }
      
      let messageId = childRef.key
    
      self.observeMessageStatus(messageId: messageId)
      
      let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId).child(userMessagesFirebaseFolder)
      
      self.newOutboxMessage = true
      
      userMessagesRef.updateChildValues([messageId: 1])
      
      let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId).child(userMessagesFirebaseFolder)
      
      recipientUserMessagesRef.updateChildValues([messageId: 1])
    }
  }
  
  
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
  

    func performZoomInForStartingImageView(_ startingImageView: UIImageView) {
        print("tapped")
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image  = startingImageView.image
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
                  // do nothing
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
