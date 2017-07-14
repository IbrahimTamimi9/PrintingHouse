//
//  ChatMessageCell.swift
//  Avalon-print
//
//  Created by Roman Mizin on 3/25/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//


import UIKit
import AVFoundation
import FirebaseAuth

class ChatMessageCell: UICollectionViewCell {
    
    var message: Message?
    var chatLogController: ChatLogController?
  
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
  
    static let grayBubbleImage = UIImage(named: "AvalonBubbleIncomingFull")!.resizableImage(withCapInsets: UIEdgeInsetsMake(15, 20, 15, 20)).withRenderingMode(.alwaysOriginal)
    static let blueBubbleImage = UIImage(named: "AvalonBubbleOutgoingFull")!.resizableImage(withCapInsets: UIEdgeInsetsMake(15, 20, 15, 20)).withRenderingMode(.alwaysOriginal)
  
  
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
  
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        tv.isEditable = false
        tv.isScrollEnabled = false
      
        return tv
    }()
  
     let bubbleView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true

        return view
    }()
 
    lazy var messageImageView: UIImageView = {
        let messageImageView = UIImageView()
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.layer.cornerRadius = 15
        messageImageView.layer.masksToBounds = true
        messageImageView.contentMode = .scaleAspectFill
        messageImageView.isUserInteractionEnabled = true
        messageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(handleZoomTap)))
      
        return messageImageView
    }()
  
  
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    var textViewCenterXAnchor: NSLayoutConstraint?
  
  
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        backgroundColor = AvalonPalette.avalonControllerBackground
 
        addSubview(bubbleView)
        bubbleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10)
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)//; bubbleViewRightAnchor?.isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 0); bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
      
        bubbleView.addSubview(textView)
        textView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        textViewCenterXAnchor = textView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor, constant: 0); textViewCenterXAnchor?.isActive = true
        textView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
      
        bubbleView.addSubview(messageImageView)
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
      
        bubbleView.addSubview(playButton)
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bubbleView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
  
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
  
    override func prepareForReuse() {
      super.prepareForReuse()
      playerLayer?.removeFromSuperlayer()
      player?.pause()
      activityIndicatorView.stopAnimating()
    }


    func handlePlay() {
      if let videoUrlString = message?.videoUrl, let url = URL(string: videoUrlString) {
        player = AVPlayer(url: url)
      
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bubbleView.bounds
        bubbleView.layer.addSublayer(playerLayer!)
      
        player?.play()
        activityIndicatorView.startAnimating()
        playButton.isHidden = true
      }
    }
  
  
    func handleZoomTap(_ tapGesture: UITapGestureRecognizer) {
      if message?.videoUrl != nil {
        return
      }
     
      if let imageView = tapGesture.view as? UIImageView {
        //PRO Tip: don't perform a lot of custom logic inside of a view class
        self.chatLogController?.performZoomInForStartingImageView(imageView)
      }
    }
  
}
