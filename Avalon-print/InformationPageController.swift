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
    
    @IBOutlet var informationTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()}
    
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
            let viewController = segue.destination as! informationDetail
            viewController.passedValue = valueToPass
        }
    }
}
