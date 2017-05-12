//
//  SelectLocationViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/10/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import NVActivityIndicatorView

protocol SelectLocationProtocol {
    func recieveLocation(latitude: String, longitude: String, addressString: String)

}

class SelectLocationViewController: UIViewController {

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    var geoCoder: CLGeocoder!
    var locationManager: CLLocationManager!
    var previousAddress: String!

    @IBOutlet weak var setLocationButton: UIButton!
    var delgate: SelectLocationProtocol?
    
    var activitiyIndicator:NVActivityIndicatorView? = nil

    override func viewDidLoad() {

        super.viewDidLoad()
        setLocationButton.layer.cornerRadius = setLocationButton.frame.height / 2
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestLocation()
        geoCoder = CLGeocoder()
        self.mapView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activitiyIndicator = ActivityIndicatorLoader.startActivityIndicator(view: self.view)
    }

}

extension SelectLocationViewController:CLLocationManagerDelegate {
    func geoCode(location: CLLocation!) {
//        geoCoder.cancelGeocode()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, _) -> Void in
            guard let placeMarks = data as [CLPlacemark]! else {
                return
            }
            let loc: CLPlacemark = placeMarks[0]
            let addressDict: [NSString:NSObject] = loc.addressDictionary as! [NSString: NSObject]
            let addrList = addressDict["FormattedAddressLines"] as! [String]
            if addrList.count > 1 {
                let address: String? = addrList[1]
                self.address.text = address
                self.previousAddress = address
                self.activitiyIndicator?.stopAnimating()
            } else {
                if !addrList.isEmpty {
                    let address: String? = addrList[0]
                    self.address.text = address
                    self.previousAddress = address
                    self.activitiyIndicator?.stopAnimating()

                } else {
                    let address="Unknown Location"
                    self.address.text = address
                    self.previousAddress = address
                    self.activitiyIndicator?.stopAnimating()

                }

            }
        })

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.first!
        self.mapView.centerCoordinate = location.coordinate
        let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 5, 5)
        self.mapView.setRegion(reg, animated: true)
        geoCode(location: location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension SelectLocationViewController:MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        geoCode(location: location)
    }

    @IBAction func setLocationButtonPressed(_ sender: UIButton) {
//        let location = CLLocation(latitude: mapView.centerCoordinate.latitude., longitude: mapView.centerCoordinate.longitude)
        var latitudeText: String = "\(mapView.centerCoordinate.latitude)"
        var longitudeText: String = "\(mapView.centerCoordinate.longitude)"
        self.delgate?.recieveLocation(latitude: latitudeText, longitude:longitudeText, addressString: self.address.text!)
        dismiss(animated: true, completion: nil)
    }
}
