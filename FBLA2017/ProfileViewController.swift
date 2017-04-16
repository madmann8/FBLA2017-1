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

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var sellingContainerView: UIView!
    @IBOutlet weak var favoritesContainerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    var geoCoder:CLGeocoder!
    var locationManager:CLLocationManager!

    @IBAction func imageButtonPressed(_ sender: UIButton) {
    }

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

        getProfilePic()
        geoCoder=CLGeocoder()
        locationManager=CLLocationManager()
                setNameLabel()
        setCityLabel()
    }
    
    func setNameLabel() {
        nameLabel.text=FIRAuth.auth()?.currentUser?.displayName
        
    }
    


}





extension ProfileViewController:CLLocationManagerDelegate{
    func setCityLabel() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
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


extension ProfileViewController{
    func getProfilePic() {
        if let providerData = FIRAuth.auth()?.currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    

                    print("user is signed in with facebook")
                    profileImageView.downloadedFrom(link: (FIRAuth.auth()?.currentUser?.photoURL?.absoluteString)!)

                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                case "google.com":
                    print("user is signed in with google")
                    profileImageView.downloadedFrom(link: (FIRAuth.auth()?.currentUser?.photoURL?.absoluteString)!)
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                case "passwork":
                    print("Email sing ed via")
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                default:
                    print("user is signed in with \(userInfo.providerID)")
                }
            }}
    }
}

extension UIImageView {
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = NSURL(string: link) else { return }
        contentMode = mode
        URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.sync() {
                self.image = image
            }
            }.resume()
    }
}
