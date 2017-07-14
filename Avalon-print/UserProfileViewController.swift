//
//  UserProfileViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/2/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserProfileViewController: UIViewController {
  
  
  let headerView = UserProfileHeaderView()
  
  let userProfileTableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
  
  let userProfileCellId = "userProfileCell"
  
  let scrollView = UIScrollView(frame: UIScreen.main.bounds)
  
  var firstSection = [( icon: UIImage(named: "orders") , title: "Заказы", controller: OrdersViewController() as Any ),
                      ( icon: UIImage(named: "editProfile") , title: "Редактирование профиля", controller: EditProfileViewController() as Any),
                      ( icon: UIImage(named: "onlineSupport") , title: "Онлайн поддержка", controller: MessagesController() as Any )]
  
  
  var secondSection = [/* ( icon: UIImage(named: "language") , title: "Язык", controller: nil), */
                       ( icon: UIImage(named: "storage") , title: "Данные и хранилище", controller: StorageTableViewController()),
                       ( icon: UIImage(named: "Logout") , title: "Выход", controller: nil)]
  
  // ( icon: UIImage(named: "nightMode") , title: "Ночной режим", controller: nil )
  
 
    override func viewDidLoad() {
        super.viewDidLoad()
      
      view.backgroundColor = UIColor.white
      
      self.scrollView.delegate = self
      
      view.addSubview(scrollView)

      scrollView.addSubview(headerView)
      scrollView.addSubview(userProfileTableView)
    
      userProfileTableView.delegate = self
      userProfileTableView.dataSource = self
      
      userProfileTableView.backgroundColor = UIColor.white
      userProfileTableView.isScrollEnabled = false
      userProfileTableView.alpha = 0
      userProfileTableView.separatorStyle = .none
      
      let leftButton = UIBarButtonItem(image: UIImage(named: "ChevronLeft"), style: .plain, target: self, action: #selector(leftBarButtonTapped))
      navigationItem.leftBarButtonItem = leftButton
      
      userProfileTableView.register(UserProfileTableViewCell.self, forCellReuseIdentifier: userProfileCellId)
      userProfileTableView.tableFooterView = UIView(frame: CGRect.zero)
      
      setConstraints()
    }
  
  func leftBarButtonTapped () {
    dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    scrollView.contentSize = CGSize(width: screenSize.width, height: 500)
  }
  
  
  fileprivate func setConstraints() {
    
    headerView.translatesAutoresizingMaskIntoConstraints = false
    headerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
    headerView.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
    headerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    
    userProfileTableView.translatesAutoresizingMaskIntoConstraints = false
    userProfileTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10).isActive = true
    userProfileTableView.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
    userProfileTableView.heightAnchor.constraint(equalToConstant: 400).isActive = true
  }
  
  
 fileprivate func checkInternetConnectionForFutureActivityIndicatorBehavior () {
    
    if  currentReachabilityStatus != .notReachable {
      //connected
      ARSLineProgress.show()
    } else {
      //not connected
      let alertController = UIAlertController(title: "Ошибка подключения к интернету", message: "Пожалуйста, подключитесь к интернету.", preferredStyle: .alert)
      
      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      
      alertController.addAction(defaultAction)
      
      self.present(alertController, animated: true, completion: nil)
      
    }
    
  }
  
  func logoutButtonTapped () {
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
      dismiss(animated: true, completion: nil)
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
  }
  
}

extension UserProfileViewController: UIScrollViewDelegate {}
extension UserProfileViewController: UITableViewDelegate {}


extension UserProfileViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = userProfileTableView.dequeueReusableCell(withIdentifier: userProfileCellId, for: indexPath) as! UserProfileTableViewCell
    
    if indexPath.section == 0 {
      
      cell.icon.image = firstSection[indexPath.row].icon
      cell.title.text = firstSection[indexPath.row].title
    }
    
    if indexPath.section == 1 {
    
      cell.icon.image = secondSection[indexPath.row].icon
      cell.title.text = secondSection[indexPath.row].title
      
      if indexPath.row == secondSection.count - 1 {
        cell.accessoryType = .none
        
      }
    }
    
      
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if indexPath.section == 0 {
      
      let destination = firstSection[indexPath.row].controller//MessagesController()
      
     // if destination != nil {
      self.navigationController?.pushViewController(destination as! UIViewController, animated: true)
     // }
    }
    
    if indexPath.section == 1 {
      
      let destination = secondSection[indexPath.row].controller//MessagesController()
      
    if destination != nil {
        self.navigationController?.pushViewController(destination!  , animated: true)
      }
      
      if indexPath.row == secondSection.count - 1 {
        logoutButtonTapped()
        
      }
    }
    
     userProfileTableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if section == 0 {
      return firstSection.count
    }
    if section == 1 {
      return secondSection.count
    } else {
    
    return 0
    }
  }
  

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    if section == 0 {
      return "Меню"
    }
    if section == 1 {
      return "Настройки"
    }
    return ""
  }
  
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    if section == 0 {
      return 26
    }
    return 0
  }
  
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as! UITableViewHeaderFooterView
     header.textLabel?.backgroundColor = self.view.backgroundColor
  
    if section == 0 {
      
      header.textLabel?.text  = "Меню"
      header.textLabel?.font = UIFont.systemFont(ofSize: 22)
      header.textLabel?.textColor = UIColor.black
    }
    
    if section == 1 {
      
      header.textLabel?.text = "Настройки"
      header.textLabel?.font = UIFont.systemFont(ofSize: 22)
      header.textLabel?.textColor = UIColor.black
    }
  }
  
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if headerView.name.text?.isEmpty == true {
      ARSLineProgress.hide()
      
      UIView.animate(withDuration: 0.1, animations: {
        self.headerView.alpha = 1
        self.userProfileTableView.alpha = 1
      })
      
    } else {
      
      self.headerView.alpha = 0
      self.userProfileTableView.alpha = 0
  
      checkInternetConnectionForFutureActivityIndicatorBehavior()

    }
    
    
    var ref: DatabaseReference!
    ref = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
    
    ref.observeSingleEvent(of: .value, with: { snapshot in
      
      if !snapshot.exists() { return }
      
      let mainUserData = snapshot.value as? NSDictionary
      
      if let userNameSurname = mainUserData?["name"] as? String  {
   
        self.headerView.name.text = userNameSurname
        
        UIView.animate(withDuration: 0.1, animations: {
        
          self.headerView.alpha = 1
          self.userProfileTableView.alpha = 1
      
          ARSLineProgress.hide()
        })
      }
      
      if let userEmail = mainUserData?["email"] as? String  {
        self.headerView.email.text = userEmail
      }
    })
  }

}

