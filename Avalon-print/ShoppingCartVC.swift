//
//  ShoppingCartVC.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 6/17/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//


import UIKit
import CoreData



var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

var offset: CGFloat = 70

var totalprice = 0.0

var totalNDSprice = 0.0


class ShoppingCartVC: UIViewController {
  
  var startingFrame: CGRect?
  var blackBackgroundView: UIView?
  var startingImageView: UIImageView?
  
  let checkoutButtonView = CheckoutButtonView()
  
  let shoppingCardsTableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
  
  let shoppingCartCellId = "shoppingCartCell"
  
  
  fileprivate func initializeTableView () {
    
  //  shoppingCardsTableView.separatorColor = UIColor.white
    shoppingCardsTableView.separatorStyle = .none
    shoppingCardsTableView.backgroundColor = UIColor.white
    shoppingCardsTableView.allowsSelection = false
    shoppingCardsTableView.translatesAutoresizingMaskIntoConstraints = false
    shoppingCardsTableView.register(ShoppingCartTableViewCell.self, forCellReuseIdentifier: shoppingCartCellId)
    
    
   

  }
  
  fileprivate func setTableViewConstraints () {
    
   
    shoppingCardsTableView.topAnchor.constraint(equalTo:  self.view.topAnchor).isActive = true
    shoppingCardsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    shoppingCardsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    shoppingCardsTableView.bottomAnchor.constraint(equalTo: checkoutButtonView.topAnchor).isActive = true
  }
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      DispatchQueue.main.async {
        localizeCoreDataIfNeeded()
      }
      
      shoppingCardsTableView.delegate = self
      shoppingCardsTableView.dataSource = self
    
      view.backgroundColor = UIColor.white
      
      view.addSubview(shoppingCardsTableView)
      view.addSubview(checkoutButtonView)
     
     
      initializeTableView()
      setTableViewConstraints()
      totalPriceCalculation()
      animateBottomViewIfNeeded()
      
      
      
      navigationItem.rightBarButtonItem = self.editButtonItem
      
      editButtonItem.title = NSLocalizedString("ShoppingCartVC.editButtonItem.basicTitle", comment: "")//"Изменить"
      
      self.editButtonItem.tintColor = AvalonPalette.avalonBlue
      
      let leftButton = UIBarButtonItem(image: UIImage(named: "ChevronLeft"), style: .plain, target: self, action: #selector(ShoppingCartVC.leftBarButtonTapped))
     //= UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
      navigationItem.leftBarButtonItem = leftButton
      
      checkoutButtonView.frame =  CGRect(x: 0, y: view.bounds.height - navigationController!.navigationBar.bounds.height - UIApplication.shared.statusBarView!.frame.height - 90, width: screenSize.width, height: 90)
  
  }
 
  
  fileprivate func totalPriceCalculation () {
    
    let sumLocalizedLabel = NSLocalizedString("ShoppingCartVC.sumLocalizedLabel", comment: "")
    let ndsSumLocalizedLabel =  NSLocalizedString("ShoppingCartVC.ndsSumLocalizedLabel", comment: "")
    
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
    
    checkoutButtonView.totalPrice.text = "\(sumLocalizedLabel): \(totalprice) \(currencyTypeLocalizedLabel), \(ndsSumLocalizedLabel): \(totalNDSprice) \(currencyTypeLocalizedLabel)."
    if (addedItems.count == 0) {
      UIView.animate(withDuration: 0.2, animations: { self.checkoutButtonView.totalPrice.alpha = 0.0 })
    }
  }
}


extension ShoppingCartVC /* custom Navigation bar functions + onTapped function for checkout button */ {
  
  func leftBarButtonTapped () {
    dismiss(animated: true, completion: nil)
  }

  
  func moreButtonTapped (_ sender: UIButton) {
    
    guard let cell = sender.superview?.superview?.superview as? ShoppingCartTableViewCell else {
        return
    }
    
    let indexPath = shoppingCardsTableView.indexPath(for: cell)
    
    let row = indexPath?.row
    
    let destination = ShoppingCartDetailTableViewController()
    
    destination.selectedShoppingCard = row!
   
    self.navigationController?.pushViewController(destination, animated: true)
  }
  
  
  func checkoutButtonTapped () {
    
    let controller = CheckoutVC()
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
    return 180
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 65
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      guard let cell = cell as? ShoppingCartTableViewCell else { return }
    
    DispatchQueue.main.async {
      let presentItem = addedItems[indexPath.row]
      
      cell.containerView.productionType.text = presentItem.productType
      
      cell.containerView.mainData.text = presentItem.list
      
      cell.containerView.price.text = "\(priceLocalizedLabel): \(String(describing: presentItem.price!)) \(currencyTypeLocalizedLabel).\n\(ndsPriceLocalizedLabel): \(String(describing: presentItem.ndsPrice!)) \(currencyTypeLocalizedLabel)."
    }
    
    
  }
}


extension ShoppingCartVC: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = shoppingCardsTableView.dequeueReusableCell(withIdentifier: shoppingCartCellId, for: indexPath) as! ShoppingCartTableViewCell
    
   // cell.layer.drawsAsynchronously = true
//    DispatchQueue.main.async {
//      let presentItem = addedItems[indexPath.row]
//      
//      cell.containerView.productionType.text = presentItem.productType
//      
//      cell.containerView.mainData.text = presentItem.list
//      
//      cell.containerView.price.text = "Цена: \(String(describing: presentItem.price!)) грн.\nЦена с НДС: \(String(describing: presentItem.ndsPrice!)) грн."
//    }
  
    
    return shoppingCardsTableView.dequeueReusableCell(withIdentifier: shoppingCartCellId, for: indexPath) as! ShoppingCartTableViewCell//cell
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

    
    UIView.animate(withDuration: 0.2, animations: {
       self.shoppingCardsTableView.cellForRow(at: indexPath)?.alpha = 0
    }) { (completion) in
       self.shoppingCardsTableView.deleteRows(at: [indexPath], with: .none)
      
      self.shoppingCardsTableView.endUpdates()
      
      do {
        try managedObjextContext.save()
      } catch {
        print("error : \(error)")
      }
      
      self.animateBottomViewIfNeeded()
      self.totalPriceCalculation()
      updateBadgeValue()
    }
   }
  }
  
  
  func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return NSLocalizedString("ShoppingCartVC.titleForDeleteConfirmationButtonForRowAt", comment: "")//"Удалить"
  }
  
  
   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return NSLocalizedString("ShoppingCartVC.header.textLabel.text", comment: "")//"Корзина"
   }
  
  
   func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as! UITableViewHeaderFooterView
    
    header.textLabel?.text = NSLocalizedString("ShoppingCartVC.header.textLabel.text", comment: "")//"Корзина"
    header.textLabel?.font = UIFont.systemFont(ofSize: 34)
    header.textLabel?.textColor = UIColor.black
    header.textLabel?.backgroundColor = self.view.backgroundColor
    
    }
  
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    
    shoppingCardsTableView.setEditing(editing, animated: animated)
    
    if shoppingCardsTableView.isEditing {
      editButtonItem.title = NSLocalizedString("ShoppingCartVC.editButtonItem.doneTitle", comment: "")//"Готово"
    } else {
      editButtonItem.title = NSLocalizedString("ShoppingCartVC.editButtonItem.basicTitle", comment: "")//"Изменить"
    }
  }
}
