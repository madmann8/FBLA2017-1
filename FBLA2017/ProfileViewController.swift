//
//  ProfileViewController.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/15/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation

class ProfileViewController: UIViewController {

    @IBOutlet weak var sellingContainerView: UIView!
    @IBOutlet weak var favoritesContainerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    var geoCoder:CLGeocoder!


    @IBAction func sellingOrFavoritesToggle(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex==0{
            sellingContainerView.isHidden=false
            favoritesContainerView.isHidden=true
        }
        else {
            sellingContainerView.isHidden=true
            favoritesContainerView.isHidden=false
        }
    }
    
    override func viewDidLoad() {
        setNameLabel()
        setCityLabel()
        geoCoder=CLGeocoder()
    }
    
    func setNameLabel() {
        nameLabel.text=FIRAuth.auth()?.currentUser?.displayName
        
    }
    


}

extension ProfileViewController:CLLocationManagerDelegate{
    func setCityLabel() {
        var locationManager: CLLocationManager!
        locationManager=CLLocationManager()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.delegate=self as! CLLocationManagerDelegate
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.first!
               geoCode(location: location)
    }
    
    func geoCode(location : CLLocation!){
        geoCoder.cancelGeocode()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, error) -> Void in
            guard let placeMarks = data as [CLPlacemark]! else {
                return
            }
            let loc: CLPlacemark = placeMarks[0]
            let addressDict : [NSString:NSObject] = loc.addressDictionary as! [NSString: NSObject]
            let addrList = addressDict["FormattedAddressLines"] as! [String]
            if addrList.count>1{
                let address:String? = addrList[1]
                self.cityLabel.text = address
            }
            else {
                if !addrList.isEmpty{
                    let address:String? = addrList[0]
                    self.cityLabel.text = address
                }
                else {
                    let address="Unknown Location"
                    self.cityLabel.text = address
                }
                
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Maps error: \(error.localizedDescription)")
        let alertController = UIAlertController(title: "Maps Error", message: error.localizedDescription, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
        
        return

    }


}
