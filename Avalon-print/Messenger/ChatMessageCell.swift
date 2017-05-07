//
//  ChatMessageCell.swift
//  Avalon-print
//
//  Created by Roman Mizin on 3/25/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//


import UIKit
import AVFoundation

class ChatMessageCell: UICollectionViewCell {
    
    var message: Message?
    
    var chatLogController: ChatLogController?
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "play")
        button.tintColor = UIColor.white
        button.setImage(image, for: UIControlState())
        
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        
        return button
    }()
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    func handlePlay() {
        if let videoUrlString = message?.videoUrl, let url = URL(string: videoUrlString) {
            player = AVPlayer(url: url)
            
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubbleView.bounds
            bubbleView.layer.addSublayer(playerLayer!)
            
            player?.play()
            activityIndicatorView.startAnimating()
            playButton.isHidden = true
            
            print("Attempting to play video......???")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        tv.isEditable = false
        tv.isScrollEnabled = false
      
        return tv
    }()
  
  let timeLabel: UILabel = {
    
    let timeLabel = UILabel()
    timeLabel.text = "2:08 PM"
    timeLabel.textColor = UIColor.gray
     timeLabel.translatesAutoresizingMaskIntoConstraints = false
     timeLabel.font = UIFont.systemFont(ofSize: 10)
    return timeLabel
  }()
  
  let statusTextView: UILabel = {
    let statusTextView = UILabel()
    statusTextView.text = "nillll"
    statusTextView.font = UIFont.systemFont(ofSize: 9)
    statusTextView.translatesAutoresizingMaskIntoConstraints = false
    statusTextView.backgroundColor = UIColor.clear
    statusTextView.textColor = UIColor.darkGray
   // statusTextView.isEditable = false
    statusTextView.textAlignment = .right
    return statusTextView
  }()

  
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
  
  
//  let statusImageView: UIImageView = {
//    let imageView = UIImageView()
//    imageView.translatesAutoresizingMaskIntoConstraints = false
//    //imageView.layer.cornerRadius = 16
//    imageView.backgroundColor = UIColor.clear
//    imageView.layer.masksToBounds = true
//    imageView.contentMode = .scaleAspectFit
//    return imageView
//  }()
  
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        
        return imageView
    }()
    
    func handleZoomTap(_ tapGesture: UITapGestureRecognizer) {
        if message?.videoUrl != nil {
            return
        }
        
        if let imageView = tapGesture.view as? UIImageView {
            //PRO Tip: don't perform a lot of custom logic inside of a view class
            self.chatLogController?.performZoomInForStartingImageView(imageView)
        }
    }
  
  
  var originalCenter = CGPoint()
  var isSwipeSuccessful = false
  
  
  func checkIfSwiped(recongizer: UIPanGestureRecognizer) {
    let translation = recongizer.translation(in: self)
    let centerCell = self.originalCenter
    
    if center.x <=  centerCell.x && center.x >= screenSize.width/3.35 {
       center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
    }
   
  
  }
  
  func moveViewBackIntoPlace(originalFrame: CGRect) {
    UIView.animate(withDuration: 0.3, animations: {self.frame = originalFrame})
  }
  
  override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
      let translation = panGestureRecognizer.translation(in: superview!)
      if fabs(translation.x) > fabs(translation.y) {
        return true
      }
    }
    return false
  }
  
  func handlePan(recognizer: UIPanGestureRecognizer) {
    if recognizer.state == .began {
      originalCenter = center
    }
    
    if recognizer.state == .changed {
      checkIfSwiped(recongizer: recognizer)
    }
    
    if recognizer.state == .ended {
      let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                 width: bounds.size.width, height: bounds.size.height)
        moveViewBackIntoPlace(originalFrame: originalFrame)
    }
  }
  
  
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    var timelabelLeftAnchor: NSLayoutConstraint?
  
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
            recognizer.delegate = self as? UIGestureRecognizerDelegate
            recognizer.cancelsTouchesInView = true
            recognizer.requiresExclusiveTouchType = false
      
        self.addGestureRecognizer(recognizer)

      
        addSubview(bubbleView)
        addSubview(textView)
        //addSubview(statusTextView)
       // addSubview(profileImageView)
        addSubview(timeLabel)
        
        bubbleView.addSubview(messageImageView)
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        bubbleView.addSubview(playButton)
        //x,y,w,h
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bubbleView.addSubview(activityIndicatorView)
        //x,y,w,h
        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //x,y,w,h
//        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true // set true if need avatar
//        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        profileImageView.widthAnchor.constraint(equalToConstant: 0).isActive = true// set true if need avatar 32
//        profileImageView.heightAnchor.constraint(equalToConstant: 0).isActive = true// set true if need avatar 32
//      
    
//      statusTextView.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5).isActive = true
//      statusTextView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 4).isActive = true
//      statusTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//      statusTextView.widthAnchor.constraint(equalToConstant: 100).isActive = true

      
        //x,y,w,h
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        //bubbleViewLeftAnchor?.active = false
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
      
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
      
      
        timelabelLeftAnchor = timeLabel.leftAnchor.constraint(equalTo: self.rightAnchor, constant: 9)
        timelabelLeftAnchor?.isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor, constant: 0).isActive = true
         
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
