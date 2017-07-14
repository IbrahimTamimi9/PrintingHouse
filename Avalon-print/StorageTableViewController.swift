//
//  StorageTableViewController.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 7/4/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import SDWebImage

extension Double {
  
  func round(to places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return Darwin.round(self * divisor) / divisor
  }
  
}

class StorageTableViewController: UITableViewController {

  
//:UInt = 0//SDImageCache.shared().getSize()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
     
      
      self.title = "Данные и хранилище"
      tableView = UITableView(frame: self.tableView.frame, style: .grouped)
      tableView.backgroundColor = UIColor.white
     // tableView.reloadData()
    }
  

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    print("appear")
    tableView.reloadData()
    
  }
  
  
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let identifier = "cell"
      
      let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell(style: .default, reuseIdentifier: identifier)
      
      
      let cachedSize = SDImageCache.shared().getSize()
      
      let cachedSizeInMegabyes = (Double(cachedSize) * 0.000001).round(to: 1)
      
      print(cachedSize, cachedSizeInMegabyes)

      cell.accessoryType = .disclosureIndicator
      
      if cachedSize > 0 {
        
        cell.textLabel?.text = "Очистить кеш"
        cell.isUserInteractionEnabled = true
        cell.textLabel?.textColor = UIColor.black
        
       
        
      } else {
        
       cell.textLabel?.text = "Кеш пуст"
       cell.isUserInteractionEnabled = false
       cell.textLabel?.textColor = UIColor.lightGray
      }
      
      

        // Configure the cell...

        return cell
    }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let oversizeAlert = UIAlertController(title: "", message: "В кеше могут содержатся превью макетов, а также принятые и отправленные изображения в переписках", preferredStyle: UIAlertControllerStyle.actionSheet)
    
    let cachedSize = SDImageCache.shared().getSize()
    
    let cachedSizeInMegabyes = (Double(cachedSize) * 0.000001).round(to: 1)
    
    let okAction = UIAlertAction(title: "Очистить (\(cachedSizeInMegabyes) МБ)", style: .default) { (action) in
      
      
      //func clearCache(sender: UIButton) {
      
      
      SDImageCache.shared().clearDisk(onCompletion: {
        SDImageCache.shared().clearMemory()
        ARSLineProgress.showSuccess()
        tableView.reloadData()
      })
      // }
    }
    
   
    
    
 
      
      //UIAlertAction(title: "Oк", style: UIAlertActionStyle.default, handler: nil)
    
    oversizeAlert.addAction(okAction)
    oversizeAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
     self.present(oversizeAlert, animated: true, completion: nil)
     tableView.deselectRow(at: indexPath, animated: true)
  }
  
//  func rootPresent(viewController : UIViewController) {
//    var rootViewController = UIApplication.shared.keyWindow?.rootViewController
//    
//    /*
//     
//    
//     
//     
//     
//     */
//    if let navigationController = rootViewController as? UINavigationController {
//      
//      rootViewController = navigationController.viewControllers.first
//      
//    }
//    
//    rootViewController?.present(viewController, animated: true, completion: nil)
//  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 65
  }
  
//  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//  
//    return "Данные и хранилище"
//  }
//  
//  
//  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//    let header = view as! UITableViewHeaderFooterView
//    header.textLabel?.backgroundColor = self.view.backgroundColor
//   
//      
//      header.textLabel?.text = "Данные и хранилище"
//      header.textLabel?.font = UIFont.systemFont(ofSize: 34)
//      header.textLabel?.textColor = UIColor.black
//    
//   
//  }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
