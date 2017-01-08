//
//  MainPageController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/1/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//


import UIKit

class InformationPageController: UITableViewController {
    
    var indexOfSelectedCell = Int()
   // var paymentAndDeliveryText = String()
    var valueToPass:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()}
 
    
  //  @IBOutlet var informationTableView: UITableView!
    
    @IBOutlet var informationTableView: UITableView!
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//       
//    }
    

    override func tableView(_ tableView: UITableView,  didSelectRowAt indexPath: IndexPath) {
        
        
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        valueToPass = currentCell.textLabel?.text
       performSegue(withIdentifier: "seguePaymentAndDelivery", sender: self)
  
    }
    
    
    //MARK: HELPER FUNCTIONS
    
    func goToDetailInfo() {
        let destination = storyboard?.instantiateViewController(withIdentifier: "informationDetail") as! informationDetail
        navigationController?.pushViewController(destination, animated: true)
       
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "seguePaymentAndDelivery") {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! informationDetail
            // your new view controller should have property that will store passed value
            viewController.passedValue = valueToPass
            
        }
//        func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//            return false;
//        }
        
//        if segue.identifier == "seguePaymentAndDelivery" {
//            if let IndexPath = tableView.indexPathForSelectedRow {
//                var destVC = segue.destination as! informationDetail   //xz
//                destVC.selectedRowFromInformationPage = "fdfd"
//                //destVC.indexOfSelectedCell
//               // destVC.textViewForLoadingContent.text = "yesss"
           // }
            
       // }
        
        
    }
    
    
    
    
}
