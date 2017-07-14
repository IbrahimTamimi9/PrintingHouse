//
//  MapViewController.swift
//  Avalon-print
//
//  Created by Roman Mizin on 12/2/16.
//  Copyright © 2016 Roman Mizin. All rights reserved.
//

import UIKit
import MapKit

 
class MapViewController: UIViewController {
  
  let map = MKMapView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.title =  NSLocalizedString("MapViewController.title", comment: "")//"Карта"
      
        view.backgroundColor = UIColor.white

        view.addSubview(map)
      
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(50.421741, 30.541826)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = NSLocalizedString("MapViewController.annotation.title", comment: "")//"Авалон-принт"
        annotation.subtitle = NSLocalizedString("MapViewController.annotation.subtitle", comment: "")//"ул. Ивана Кудри 41/22"
        map.addAnnotation(annotation)
        map.showsScale = true
   }
}


