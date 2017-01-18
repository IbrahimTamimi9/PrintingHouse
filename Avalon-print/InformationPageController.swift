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
        super.viewDidLoad()
        
        informationTableView.backgroundView = UIImageView(image: UIImage(named: "contacts"))
         informationTableView.backgroundView?.contentMode = .scaleAspectFill
         informationTableView.backgroundView?.translatesAutoresizingMaskIntoConstraints = false
        
        
        let constraints = [
            NSLayoutConstraint(item:  informationTableView.backgroundView!, attribute: .leading,  relatedBy: .equal, toItem: self.view, attribute: .leading,  multiplier: 1.0, constant: -25.0),
            
            NSLayoutConstraint(item: informationTableView.backgroundView!, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -25.0),
            
            NSLayoutConstraint(item: informationTableView.backgroundView!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top,  multiplier: 1.0, constant: -25.0),
            
            NSLayoutConstraint(item: informationTableView.backgroundView!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -25.0)
        ]
        self.view.addConstraints(constraints)
        
       applyMotionEffect(toView: informationTableView.backgroundView!, magnitude: 25)
        

    }
    
  
    
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
