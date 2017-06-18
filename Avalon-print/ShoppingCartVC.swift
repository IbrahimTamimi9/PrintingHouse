//
//  ShoppingCartVC.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/17/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//


import UIKit
import CoreData

let presentRequest:NSFetchRequest<AddedItems> = AddedItems.fetchRequest()

var addedItems = [AddedItems]()

var managedObjextContext:NSManagedObjectContext!

var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

var offset: CGFloat = 70

var totalprice = 0.0

var totalNDSprice = 0.0


class ShoppingCartVC: UIViewController {
  
  var startingFrame: CGRect?
  var blackBackgroundView: UIView?
  var startingImageView: UIImageView?
  
  let modalNavigationBar = ModalNavigationBarView(frame: CGRect(x: 0, y: statusBarSize.height, width: screenSize.width, height: 44))
  let checkoutButtonView = CheckoutButtonView(frame: CGRect(x: 0, y: screenSize.height - 90, width: screenSize.width, height: 90))
  let shoppingCardsTableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
  
  let shoppingCartCellId = "shoppingCartCell"
  
  let background: UIImageView = {
    let background = UIImageView()
    background.image = UIImage(named: "bucketAndPlaceOrderBGv3")
    background.frame = UIScreen.main.bounds
    
    return background
  }()
 

  fileprivate func initializeTableView () {
  
    shoppingCardsTableView.backgroundColor = UIColor.clear
    shoppingCardsTableView.allowsSelection = false
    shoppingCardsTableView.translatesAutoresizingMaskIntoConstraints = false
    shoppingCardsTableView.register(ShoppingCartTableViewCell.self, forCellReuseIdentifier: shoppingCartCellId)
  }
  
  fileprivate func setTableViewConstraints () {
    
    shoppingCardsTableView.topAnchor.constraint(equalTo: modalNavigationBar.bottomAnchor).isActive = true
    shoppingCardsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    shoppingCardsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    shoppingCardsTableView.bottomAnchor.constraint(equalTo: checkoutButtonView.topAnchor).isActive = true
  }
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      shoppingCardsTableView.delegate = self
      shoppingCardsTableView.dataSource = self
      
      self.view.backgroundColor = UIColor.white
      self.view.insertSubview(background, at: 0)
      self.view.addSubview(shoppingCardsTableView)
      self.view.addSubview(modalNavigationBar)
      self.view.addSubview(checkoutButtonView)
      
      initializeTableView()
      setTableViewConstraints()
      totalPriceCalculation()
      animateBottomViewIfNeeded()
  
  }
 
  
  fileprivate func totalPriceCalculation () {
    
    totalprice = 0.0
    totalNDSprice = 0.0
    
    do {
      addedItems = try managedObjextContext.fetch(presentRequest)
    } catch {
      print(error)
    }
    
    
    for item in addedItems {
      totalprice += item.price!.doubleValue
      totalNDSprice += item.ndsPrice!.doubleValue
    }
    
    checkoutButtonView.totalPrice.text = "Сумма: \(totalprice) грн, с НДС: \(totalNDSprice) грн."
    if (addedItems.count == 0) {
      UIView.animate(withDuration: 0.2, animations: { self.checkoutButtonView.totalPrice.alpha = 0.0 })
    }
  }
  
}


extension ShoppingCartVC /* custom Navigation bar functions + onTapped function for checkout button */ {
  
  func leftBarButtonTapped () {
    dismiss(animated: true, completion: nil)
  }
  
  
  func rightBarButtonTapped () {
    
    shoppingCardsTableView.setEditing(!shoppingCardsTableView.isEditing, animated: true)
    
    if  shoppingCardsTableView.isEditing == true {
      let doneImage = UIImage(named: "done")
      modalNavigationBar.rightBarButton.setImage(doneImage, for: .normal)
    } else {
      let editImage = UIImage(named: "edit")
      modalNavigationBar.rightBarButton.setImage(editImage, for: .normal)
    }
  }
  
  
  func checkoutButtonTapped () {
    
    let controller = CheckoutVC()//UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CheckoutFormVC") as! CheckoutFormVC
    let transitionDelegate = DeckTransitioningDelegate()
    controller.transitioningDelegate = transitionDelegate
    controller.modalPresentationStyle = .custom
    present(controller, animated: true, completion: nil)
  }

}


extension ShoppingCartVC /* Animations */ {
  
  //ANIMATIONS
  func viewMoveIn(view: UIView) {
    let animation = CABasicAnimation()
    
    animation.keyPath = "position.y"
    animation.fromValue  = 0
    animation.toValue = 100
    
    animation.duration = 0.4
    animation.isAdditive = true
    animation.fillMode = kCAFillModeForwards
    animation.isRemovedOnCompletion = false
    view.isUserInteractionEnabled = false
    
    view.layer.add(animation, forKey: "fade")
  }
  
  
  func animateBottomViewIfNeeded() {
    
    if addedItems.count == 0 {
      viewMoveIn(view: checkoutButtonView)
    }
  }

  
}


extension ShoppingCartVC: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 360
  }
  
}


extension ShoppingCartVC: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = shoppingCardsTableView.dequeueReusableCell(withIdentifier: shoppingCartCellId, for: indexPath) as! ShoppingCartTableViewCell
    
    let presentItem = addedItems[indexPath.row]
    
  
    if presentItem.layoutImage == nil {
      
      cell.containerView.layout.isUserInteractionEnabled = false
      
      cell.containerView.productionType.text = presentItem.productType
      
      cell.containerView.mainData.text = presentItem.list
      
      cell.containerView.price.text = "Цена: \(String(describing: presentItem.price!)) грн.\nЦена с НДС: \(String(describing: presentItem.ndsPrice!)) грн."
      
      cell.containerView.previewTitle.text = presentItem.layoutLink
      
      cell.containerView.previewTitle.textColor = UIColor.darkGray
      
      
    } else {
      
      let tapOnPreview = UITapGestureRecognizer(target: self, action: #selector(handleZoomTap))
      cell.containerView.layout.addGestureRecognizer(tapOnPreview)
      
      cell.containerView.layout.isUserInteractionEnabled = true
      
      cell.containerView.productionType.text = presentItem.productType
      
      cell.containerView.mainData.text = presentItem.list
      
      cell.containerView.price.text = "Цена: \(String(describing: presentItem.price!)) грн.\nЦена с НДС: \(String(describing: presentItem.ndsPrice!)) грн."
      
      cell.containerView.previewTitle.text = "Нажмите чтобы открыть превью"
      
      cell.containerView.previewTitle.textColor = UIColor(red:0.34, green:0.59, blue:0.96, alpha:1.0)
    }
  
    return cell
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return addedItems.count
  }

  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    let context: NSManagedObjectContext = managedObjextContext
    
    if editingStyle == UITableViewCellEditingStyle.delete {
      shoppingCardsTableView.beginUpdates()
      
      context.delete(addedItems[indexPath.row])
      addedItems.remove(at: indexPath.row)
      
      do {
        try context.save()
      } catch {
        print("error : \(error)")
      }
      
      shoppingCardsTableView.deleteRows(at: [indexPath], with: .fade)
      shoppingCardsTableView.endUpdates()
      
      do {
        try managedObjextContext.save()
      } catch {
        print("error : \(error)")
      }
      
      animateBottomViewIfNeeded()
      totalPriceCalculation()
      updateBadgeValue()
    }
  }
  
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    shoppingCardsTableView.setEditing(editing, animated: animated)
   
  }
}
