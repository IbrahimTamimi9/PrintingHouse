//
//  map.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/2/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//

import UIKit
import MapKit


class map: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(50.421741, 30.541826)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Авалон-принт"
        annotation.subtitle = "ул. Ивана Кудри 41/22"
        map.addAnnotation(annotation)
        map.showsScale = true
    
   }
}


