//
//  myOrdersTableVC.swift
//  Avalon-Print
//
//  Created by Roman Mizin on 1/30/17.
//  Copyright © 2017 Roman Mizin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

var selectedOrderNumber = String()
var selectedOrderMainInfo = String()

class MyOrdersTableVC: UITableViewController {

  
  var ordersHistoryArray = [String]()
  var orderKeys = [String]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      // Listen for new comments in the Firebase database
     navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
       tableView.backgroundView = UIImageView(image: UIImage(named: "bucketAndPlaceOrderBGv3"))

      
       var commentsRef: FIRDatabaseReference!
      
      commentsRef =  FIRDatabase.database().reference().child("orders")
      
      commentsRef.observe(.childAdded, with: { (snapshot) -> Void in
         let allOrders = snapshot.value as? NSDictionary
      
        
       // let allOrders = snapshot.value as? NSDictionary
       // print(allOrders, "!!!!!!!!!!")
        let userInfo = allOrders?["userInfo"] as? NSDictionary
        let uniqueIDofCustomer = userInfo?["userUniqueID"]  as? String ?? ""
        //var dateOfPlacement = String()
        
        let orderInfo = allOrders?["orderInfo"] as? NSDictionary
        let dateOfPlacement = orderInfo?["dateOfPlacement"]  as? String ?? ""
        let orderStatus = orderInfo?["orderStatus"] as? String ?? ""
        let fullPrice = orderInfo?["fullPrice"]  as? Double ?? 0.0
       // let fullNDSPrice = orderInfo?["fullNDSPrice"]  as? Double ?? 0.0
        
        
        if FIRAuth.auth()?.currentUser?.uid == uniqueIDofCustomer {
          
          let keys = snapshot.key// as Int
          print(keys)
          self.orderKeys.append(keys) //as String

          self.ordersHistoryArray.append("\nДата поступления заказа: \(dateOfPlacement)\n\nСтатус заказа: \(orderStatus)\n\nИтого к оплате: \(fullPrice) грн.")   // comments.append(snapshot)
          
          self.tableView.insertRows(at: [IndexPath(row: self.ordersHistoryArray.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
       
          
        }
        
        
       
      })
      
      
    
      
      /*
       var ref: FIRDatabaseReference!
       ref = FIRDatabase.database().reference()
       
       
       ref.child("GeneralData").observe(.value, with: { (snapshot) in
       
       let generalBlock = snapshot.value as? NSDictionary
       
       let USDBlock = generalBlock?["USD"] as? NSDictionary
       let NDSBlock = generalBlock?["NDS"] as? NSDictionary
       let Overprice1Block = generalBlock?["Overprice1"] as? NSDictionary
       
       JSONVariables.USD = (USDBlock?["Value"] as? String ?? "").doubleValue
       JSONVariables.NDS = Int((NDSBlock?["Value"] as? String ?? "").intValue)
       JSONVariables.OVERPRICE1 = (Overprice1Block?["Value"] as? String ?? "").doubleValue
       
       }) { (error) in
       print(error.localizedDescription)
       }

       */

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150.0
  }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ordersHistoryArray.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.numberOfLines = 1
      cell.detailTextLabel?.numberOfLines = 6
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        // Configure the cell...
      
    
      cell.textLabel?.text = "\(orderKeys[indexPath.row])"
      
      cell.detailTextLabel?.text = ordersHistoryArray[indexPath.row]

        return cell
    }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let cell:UITableViewCell? = tableView.cellForRow(at: indexPath)
    
    if cell?.textLabel?.text == orderKeys[indexPath.row] {
      print("!!!EQUALS")
      selectedOrderNumber = orderKeys[indexPath.row]
      selectedOrderMainInfo = ordersHistoryArray[indexPath.row]
      
    } else {
      print("notEquals")
    }
    print(orderKeys[indexPath.row])
    print((cell?.textLabel?.text)!)
    
    let destination = storyboard?.instantiateViewController(withIdentifier: "MyOrdersDetailTableVC") as! MyOrdersDetailTableVC
    navigationController?.pushViewController(destination, animated: true)
  }
  

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
