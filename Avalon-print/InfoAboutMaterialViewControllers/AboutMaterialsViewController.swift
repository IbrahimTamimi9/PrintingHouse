//
//  ViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/9/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit

struct gottenSignal {
  
  static  var postersSignal = false
  static  var stickersSignal = false
  static var canvasSignal = false
  static var bannersSignal = false
}

typealias ItemInfo = (imageName: String, title: String)

var items: [ItemInfo] = [("citylightPicture", "Citylight"),("lomondPicture", "Lomond"),("photoPPictue", "Photo Paper premium"), ("transparentOracalPicture", "Пленка самокл. прозрачная"), ("whiteStickerPicture", "Пленка самокл. белая"),("onewayvisionPicture", "One Way Vision"), ("item3", "Холсты"),  ("item3", "баннеры1"), ("item3", "баннеры2"), ("item3", "баннеры3"), ("item3", "баннеры4") ]

var currentSelectedMaterialInfoCell = Int()


class ViewController: UIViewController, UIViewControllerPreviewingDelegate {

	let centeredCollectionViewFlowLayout = CenteredCollectionViewFlowLayout()
  
	let collectionView: UICollectionView

	let cellPercentWidth: CGFloat = 0.7
  
	var scrollToEdgeEnabled = false
  
  let background: UIImageView = {
    let background = UIImageView()
    background.contentMode = .scaleToFill
    background.layer.masksToBounds = true
    background.image = UIImage(named: "Background")
   // background.alpha = 0.95
    background.translatesAutoresizingMaskIntoConstraints = false
    return background
  }()
  
  var viewTitle: UILabel = {
    var viewTitle = UILabel()
    viewTitle.translatesAutoresizingMaskIntoConstraints = false
    viewTitle.font =  UIFont.systemFont(ofSize: 34)
    viewTitle.text = NSLocalizedString("AboutMaterialsViewController.viewTitle.text", comment: "") 
    
    return viewTitle
  }()

 
  let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    return stackView
  }()
  
  
	override func viewDidLoad() {
		super.viewDidLoad()
    
		view.backgroundColor = UIColor.white
	
		collectionView.delegate = self
		collectionView.dataSource = self
    
    let leftButton = UIBarButtonItem(image: UIImage(named: "ChevronLeft"), style: .plain, target: self, action: #selector(back(sender:)))
    navigationItem.leftBarButtonItem = leftButton

	  collectionView.register(AboutMaterialsCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: AboutMaterialsCollectionViewCell.self))
    
		centeredCollectionViewFlowLayout.itemSize = CGSize(width: view.bounds.width * cellPercentWidth, height: view.bounds.height * cellPercentWidth * cellPercentWidth)
    
		centeredCollectionViewFlowLayout.minimumLineSpacing = 40
    
		collectionView.showsVerticalScrollIndicator = false
    
		collectionView.showsHorizontalScrollIndicator = false
    
    collectionView.backgroundColor = UIColor.clear
    
    setConstraints()
    
    if traitCollection.forceTouchCapability == .available {
      
      registerForPreviewing(with: self, sourceView: collectionView)
    }
    
	}
  
  
  func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
    
    guard let indexPath = collectionView.indexPathForItem(at: location),
      
    let cell = collectionView.cellForItem(at: indexPath) else { return nil }
    
    previewingContext.sourceRect = cell.frame
    
    return ExpandingMaterialTableViewController()
  }
  

  func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
   presentDetailViewController()
  }

  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    
    collectionView = UICollectionView(centeredCollectionViewFlowLayout: centeredCollectionViewFlowLayout)
    
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


extension ViewController {
  
  fileprivate func setConstraints() {
    
    view.addSubview(stackView)
    stackView.addArrangedSubview(collectionView)
    
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.topAnchor.constraint(equalTo: view.topAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
    
    view.insertSubview(background, at: 0)
    background.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    background.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    background.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    background.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    
    view.addSubview(viewTitle)
    viewTitle.topAnchor.constraint(equalTo:  view.topAnchor, constant: 0).isActive = true
    viewTitle.leadingAnchor.constraint(equalTo:  view.leadingAnchor, constant: 16).isActive = true
    viewTitle.trailingAnchor.constraint(equalTo:  view.trailingAnchor, constant: -16).isActive = true
    
  }
  
  
  fileprivate func presentDetailViewController () {
    
    let controller = ExpandingMaterialTableViewController()
    let navigationController = MainNavigationController(rootViewController: controller)
    navigationController.modalPresentationStyle = .overCurrentContext
    navigationController.modalTransitionStyle = .crossDissolve
    self.present(navigationController, animated: true, completion: nil)
  }
  
  
  func back(sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
}


extension ViewController: UICollectionViewDelegate {
  
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    presentDetailViewController()
    
    
		if scrollToEdgeEnabled,
			let currentCenteredPage = centeredCollectionViewFlowLayout.currentCenteredPage,
			currentCenteredPage != indexPath.row {
			centeredCollectionViewFlowLayout.scrollToPage(index: indexPath.row, animated: true)
		}
	}
  
  func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    fillTableView(indexPath: indexPath)
    currentSelectedMaterialInfoCell = indexPath.row
  }
  
}


extension ViewController: UICollectionViewDataSource {
  
  
  
  
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}

  
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AboutMaterialsCollectionViewCell.self), for: indexPath) as! AboutMaterialsCollectionViewCell
    
		cell.titleLabel.text = items[indexPath.row].title
    
    cell.image.image = UIImage(named: items[indexPath.row].imageName)
    
  
		return cell
	}

  
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		print("Current centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
	}
  

	func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		print("Current centered index: \(String(describing: centeredCollectionViewFlowLayout.currentCenteredPage ?? nil))")
	}
}



