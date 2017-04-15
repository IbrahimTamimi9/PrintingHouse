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
    var valueToPass:String!
    @IBOutlet weak var informationTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
          informationTableView.backgroundView = UIImageView(image: UIImage(named: "third"))
          informationTableView.backgroundView?.alpha = 0.4
    }
    
    
    override func tableView(_ tableView: UITableView,  didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        valueToPass = currentCell.textLabel?.text
        performSegue(withIdentifier: "seguePaymentAndDelivery", sender: self)
    }
    
    
    //MARK: HELPER FUNCTIONS
    
    func goToDetailInfo() {
        let destination = storyboard?.instantiateViewController(withIdentifier: "InformationDetail") as! InformationDetail
        navigationController?.pushViewController(destination, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "seguePaymentAndDelivery") {
            let viewController = segue.destination as! InformationDetail
            viewController.passedValue = valueToPass
        }
    }
}
