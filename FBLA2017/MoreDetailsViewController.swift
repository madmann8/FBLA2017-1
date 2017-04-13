//
//  MoreDetailsrViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/13/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MoreDetailsViewController: UIViewController {
    var categorey:String?=nil
    var name:String?=nil
    var about:String?=nil
    var latitudeString:String?=nil
    var longitudeString:String?=nil
    var addressString:String?=nil
    var cents:Int?=nil
    var condition:Int?=nil

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var categoryLabel: UILabel!
    
    override func viewDidLoad() {
        if
        let name=name,
        let category = categorey,
        let about=about,
        let latitude=latitudeString,
        let longitude=longitudeString,
        let cents=cents,
            let condition=condition{
            titleLabel.text=name
            costLabel.text=String(cents)
            categoryLabel.text=category
            descriptionLabel.text=about
            ratingLabel.text=String(condition)
        }
        
    }
  

}
