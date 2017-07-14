//
//  CollectionViewCell.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/9/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

class AboutMaterialsCollectionViewCell: UICollectionViewCell {
  
  
  var mainView: UIView = {
    var mainView = UIView()
    mainView.translatesAutoresizingMaskIntoConstraints = false
    mainView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    mainView.backgroundColor = UIColor.white
    mainView.layer.masksToBounds = true
    mainView.layer.cornerRadius = 13
    
    return mainView
  }()
  
  var titleLabel: UILabel = {
    var titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.textAlignment = .center
    titleLabel.textColor = UIColor.white
    titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    titleLabel.layer.shadowRadius = 2
    titleLabel.layer.shadowOffset = CGSize(width: 0, height: 3)
    titleLabel.layer.shadowOpacity = 0.5

    return titleLabel
  }()
  
  
  let image: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = .scaleAspectFill
    image.layer.masksToBounds = true
    
    return image
  }()
  
  let topBlurryView: UIView = {
    let topBlurryView = UIView()
    topBlurryView.translatesAutoresizingMaskIntoConstraints = false
    topBlurryView.layer.masksToBounds = true
    
    return topBlurryView
  }()
  

	override init(frame: CGRect) {
		super.init(frame: frame)
    
		contentView.addSubview(mainView)
    
    mainView.addSubview(image)
	
    mainView.addSubview(topBlurryView)
    
    topBlurryView.addSubview(titleLabel)
    
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = topBlurryView.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    topBlurryView.insertSubview(blurEffectView, at: 0)
    
    
  NSLayoutConstraint.activate([
    
    mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
    mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
    mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
    mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    
   	topBlurryView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
    topBlurryView.topAnchor.constraint(equalTo: mainView.topAnchor),
    topBlurryView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
    topBlurryView.heightAnchor.constraint(equalToConstant: 40),
    
    image.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
    image.topAnchor.constraint(equalTo: mainView.topAnchor),
    image.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
    image.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),

    titleLabel.topAnchor.constraint(equalTo: topBlurryView.topAnchor),
    titleLabel.bottomAnchor.constraint(equalTo: topBlurryView.bottomAnchor),
    titleLabel.leadingAnchor.constraint(equalTo: topBlurryView.leadingAnchor),
    titleLabel.trailingAnchor.constraint(equalTo: topBlurryView.trailingAnchor)
    
    ])
    
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}




