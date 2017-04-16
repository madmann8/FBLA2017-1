//
//  CurrentUserModel.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/16/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import CoreLocation
import UIKit

class User:NSObject {
    
     var uid: String!
     var displayName: String!
     var email: String!
     var city: String!
     var profileImage: UIImage!
    
    var geoCoder:CLGeocoder!
    var locationManager:CLLocationManager!

    

    public  func setupCurrentUser(){
        self.geoCoder=CLGeocoder()
        self.locationManager=CLLocationManager()

        uid=FIRAuth.auth()?.currentUser?.uid
        if let display=FIRAuth.auth()?.currentUser?.displayName{
            displayName=display
        }
        else{
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            let userID = FIRAuth.auth()?.currentUser?.uid
            ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                self.displayName = value?["displayName"] as? String ?? ""
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        print("DEDE\(self.displayName)")
        email=FIRAuth.auth()?.currentUser?.email
        setCityLabel()
        getProfilePic()
    }
    

    
}

//Profile Picture Stuff
extension User {
    func getProfilePic() {
        if let providerData = FIRAuth.auth()?.currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":

                    print("user is signed in with facebook")
                    downloadedFrom(link: (FIRAuth.auth()?.currentUser?.photoURL?.absoluteString)!)
                case "google.com":
                    print("user is signed in with google")
                    downloadedFrom(link: (FIRAuth.auth()?.currentUser?.photoURL?.absoluteString)!)

                    
                    
                case "password":
                    print("Email sing ed via password")
                    var ref: FIRDatabaseReference!
                    ref = FIRDatabase.database().reference().child("users").child(uid!)
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as? NSDictionary
                        let imageURL = value?["imageURL"] as? String ?? "❌"
                        if imageURL == "❌"{
                            ref.child("imageURL").setValue("https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg")
                        }
                        else {
                            self.downloadedFrom(link: imageURL)
                        }
                        
                        
                        // ...
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                default:
                    print("user is signed in with \(userInfo.providerID)")
                }
            }}
    }

}





//Location Stuff

extension User:CLLocationManagerDelegate{


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
                self.city = address
            }
            else {
                if !addrList.isEmpty{
                    let address:String? = addrList[0]
                    self.city = address
                }
                else {
                    let address="Unknown Location"
                    self.city = address
                }
                
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Maps error: \(error.localizedDescription)")
        
        return
        
    }
    
    
}



extension User {
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = NSURL(string: link) else { return }
        URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.sync() {
                self.profileImage=image
                return
            }
            }.resume()
    }
}



