//
//  ExpandingMaterialViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 1/21/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import expanding_collection

struct gottenSignal {
 static  var postersSignal = false
 static  var stickersSignal = false
  static var canvasSignal = false
  static var bannersSignal = false
}

 typealias ItemInfo = (imageName: String, title: String)

var items: [ItemInfo] = [("citylightPicture", "CityLight"),("lomondPicture", "Lomond"),("photoPPictue", "Photo Paper 200g"), ("transparentOracalPicture", "Пленка самокл. прозрачная"), ("whiteStickerPicture", "Пленка самокл. белая"),("onewayvisionPicture", "One Way Vision"), ("item3", "Холсты"),  ("item3", "баннеры1"), ("item3", "баннеры2"), ("item3", "баннеры3"), ("item3", "баннеры4") ]



class ExpandingMaterialViewController: ExpandingViewController {
      
    @IBAction func dismissPage(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
   
    
    
    
   
   
    @IBOutlet weak var backgroundImageViewMain: UIImageView!
   
    fileprivate var cellsIsOpen = [Bool]()
   
    @IBOutlet weak var pageLabel: UILabel!
    
    override func viewDidLoad() {
        itemSize = CGSize(width: 214, height: 264)
        super.viewDidLoad()
    
        
        registerCell()
        fillCellIsOpeenArry()
        addGestureToView(collectionView!)
    }
    
    fileprivate func registerCell() {
        let nib = UINib(nibName: String(describing: MaterialsCollectionViewCell.self), bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: MaterialsCollectionViewCell.self))
    }
    
    fileprivate func fillCellIsOpeenArry() {
        for _ in items {
            cellsIsOpen.append(false)
        }
    }
    
    fileprivate func getViewController() -> ExpandingTableViewController {
        let toViewController = storyboard?.instantiateViewController(withIdentifier: "ExpandingMaterialTableViewController")// as! ExpandingMaterialTableViewController
        
        return toViewController as! ExpandingTableViewController// as! ExpandingTableViewController
    }

    
    fileprivate func addGestureToView(_ toView: UIView) {
        
        
        let gesutereUp = UISwipeGestureRecognizer(target: self, action: #selector(ExpandingMaterialViewController.swipeHandler(_:)))
        gesutereUp.direction = UISwipeGestureRecognizerDirection.up
        
        
        let gesutereDown = UISwipeGestureRecognizer(target: self, action: #selector(ExpandingMaterialViewController.swipeHandler(_:)))
        gesutereDown.direction = UISwipeGestureRecognizerDirection.down
        
        
        toView.addGestureRecognizer(gesutereUp)
        toView.addGestureRecognizer(gesutereDown)
    }
    
    func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell  = collectionView?.cellForItem(at: indexPath) as? MaterialsCollectionViewCell else { return }
        // double swipe Up transition
        if cell.isOpened == true && sender.direction == .up {
            pushToViewController(getViewController())
        }
        
        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
        cellsIsOpen[(indexPath as NSIndexPath).row] = cell.isOpened
        fillTableView(indexPath: indexPath)
     

        }
    
 
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageLabel.text = "\(currentIndex+1)/\(items.count)"
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        guard let cell = cell as? MaterialsCollectionViewCell else { return }
        
        let index = (indexPath as NSIndexPath).row % items.count
        let info = items[index]
        cell.backgroundImageView.image = UIImage(named: info.imageName)
        cell.materialName.numberOfLines = 2
        cell.materialName.text = info.title
        cell.cellIsOpen(cellsIsOpen[index], animated: false)
      
      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MaterialsCollectionViewCell
            , currentIndex == (indexPath as NSIndexPath).row else { return }
        
        if cell.isOpened == false {
            cell.cellIsOpen(true)
        } else {
            pushToViewController(getViewController())
         

            
            
        }
     
    }
  

  
  func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        fillTableView(indexPath: indexPath)
  }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MaterialsCollectionViewCell.self), for: indexPath)
    }
}
