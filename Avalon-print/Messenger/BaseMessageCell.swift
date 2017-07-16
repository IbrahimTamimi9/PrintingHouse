//
//  BaseMessageCell.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/16/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth

class BaseMessageCell: UICollectionViewCell {
  
  static let grayBubbleImage = UIImage(named: "AvalonBubbleIncomingFull")?.resizableImage(withCapInsets: UIEdgeInsetsMake(15, 20, 15, 20))
  
  static let blueBubbleImage = UIImage(named: "AvalonBubbleOutgoingFull")!.resizableImage(withCapInsets: UIEdgeInsetsMake(15, 20, 15, 20))

  let bubbleView: UIImageView = {
    let bubbleView = UIImageView()
    bubbleView.backgroundColor = UIColor.white
    bubbleView.isUserInteractionEnabled = true
    
    return bubbleView
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupViews() {
    
    backgroundColor = AvalonPalette.avalonControllerBackground
    contentView.backgroundColor = AvalonPalette.avalonControllerBackground
    
  }
  
  
  func prepareViewsForReuse() {}
  
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    prepareViewsForReuse()
  }



}
