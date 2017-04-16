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
    var sellingImagesPaths:[String]=[]
    var favoriteImagesPaths:[String]=[]
    
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
                if userInfo.providerID=="password"  {
                    
                    var ref: FIRDatabaseReference!
                    ref = FIRDatabase.database().reference().child("users").child(uid!)
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as? NSDictionary
                        var imageURL = value?["imageURL"] as? String ?? "❌"
                        if imageURL == "❌"{
                            ref.child("imageURL").setValue("https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg")
                            imageURL="https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg"
                        }
                        self.downloadedFrom(link: imageURL)
                        
                        //DO THIS
                        
                        //DO THIS
                        
                        
                        var displayName = value?["displayName"] as? String ?? "❌"
                        if displayName == "❌"{
                            ref.child("displayName").setValue(FIRAuth.auth()?.currentUser?.displayName)
                            displayName=(FIRAuth.auth()?.currentUser?.displayName)!
                        }
                        
                        let imagePathsSnapshot=snapshot.childSnapshot(forPath: "coverImages")
                        let favoritesPathSnapshot=snapshot.childSnapshot(forPath: "likedCoverImages")
                        if let coverArray=imagePathsSnapshot.value as? NSDictionary{
                            if (coverArray.count)>0{
                                for kv in coverArray{
                                    let s=kv.value as! String
                                    self.sellingImagesPaths.append(s)
                                }
                            }
                        }
                        if let favoritesArray=imagePathsSnapshot.value as? NSDictionary{
                            if (favoritesArray.count)>0{
                                for kv in favoritesArray{
                                    let s=kv.value as! String
                                    self.favoriteImagesPaths.append(s)
                                }
                            }
                        }
                    }
                    )
                }
                    
                    
                else{
                    var ref: FIRDatabaseReference!
                    ref = FIRDatabase.database().reference().child("users").child(uid!)
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as? NSDictionary
                        var imageURL = FIRAuth.auth()?.currentUser?.photoURL as? String ?? "❌"
                        if imageURL == "❌"{
                            ref.child("imageURL").setValue("https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg")
                            imageURL="https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg"
                        }
                        else {
                            ref.child("imageURL").setValue(imageURL)
                        }
                        self.downloadedFrom(link: imageURL)
                        
                        
                        var displayName = value?["displayName"] as? String ?? "❌"
                        if displayName == "❌"{
                            ref.child("displayName").setValue(FIRAuth.auth()?.currentUser?.displayName)
                            displayName=(FIRAuth.auth()?.currentUser?.displayName)!
                        }
                        
                        let imagePathsSnapshot=snapshot.childSnapshot(forPath: "coverImages")
                        let favoritesPathSnapshot=snapshot.childSnapshot(forPath: "likedCoverImages")
                        if let coverArray=imagePathsSnapshot.value as? NSDictionary{
                            if (coverArray.count)>0{
                                for kv in coverArray{
                                    let s=kv.value as! String
                                    self.sellingImagesPaths.append(s)
                                }
                            }
                        }
                        if let favoritesArray=imagePathsSnapshot.value as? NSDictionary{
                            if (favoritesArray.count)>0{
                                for kv in favoritesArray{
                                    let s=kv.value as! String
                                    self.favoriteImagesPaths.append(s)
                                }
                            }
                        }
                    })
                }
                
                
                
                
                
            }
        }}
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
                self.handleLocation(city: address!)
            }
            else {
                if !addrList.isEmpty{
                    let address:String? = addrList[0]
                    self.handleLocation(city: address!)
                }
                else {
                    let address="Unknown Location"
                    self.handleLocation(city: address)
                }
                
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Maps error: \(error.localizedDescription)")
        
        return
        
    }
    
    func  handleLocation(city:String){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference().child("users").child(uid!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
                self.city=city
                ref.child("locationString").setValue(self.city)
            
                 })
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



