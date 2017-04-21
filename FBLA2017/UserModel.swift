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

protocol UserDelegate {
    func imageLoaded(image: UIImage)
}


class User:NSObject {
    
    var uid: String!
    var displayName: String!
    var email: String!
    var city: String!
    var profileImage: UIImage!
    var sellingImagesPaths:[String]=[]
    var favoriteImagesPaths:[String]=[]
    var itemChats=[ChatsTableViewCell]()
    var directChats=[ChatsTableViewCell]()
    var cellIndex:Int?=nil
    var itemChar:Bool?=nil
    
    var geoCoder:CLGeocoder!
    var locationManager:CLLocationManager!
    
    var delegate:UserDelegate?=nil
    
    public  func setupUser(id:String,isLoggedIn:Bool){
        self.geoCoder=CLGeocoder()
        self.locationManager=CLLocationManager()
        
        uid=id
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
        email=FIRAuth.auth()?.currentUser?.email
        setCityLabel()
        getProfilePic(isLoggedIn: isLoggedIn)
        if isLoggedIn{
            getChatsCells(keyString: id)
        }
        
        
        
        
    }
}

//Profile Picture Stuff
extension User {
    func getProfilePic(isLoggedIn:Bool) {
        if (isLoggedIn){
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
                            
                            self.email = value?["email"] as? String ?? "❌"
                            if self.email == "❌"{
                                ref.child("email").setValue(FIRAuth.auth()?.currentUser?.email)
                                self.email=(FIRAuth.auth()?.currentUser?.email)!
                            }
                            
                            self.displayName = value?["displayName"] as? String ?? "❌"
                            if self.displayName == "❌"{
                                ref.child("displayName").setValue(FIRAuth.auth()?.currentUser?.displayName)
                                self.displayName=(FIRAuth.auth()?.currentUser?.displayName)!
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
                            var imageURL:String = FIRAuth.auth()?.currentUser?.photoURL?.absoluteString ?? "❌"
                            if imageURL == "❌"{
                                ref.child("imageURL").setValue("https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg")
                                imageURL="https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg"
                            }
                            else {
                                var imageURL2 = value?["imageURL"] as? String ?? "❌"
                                if imageURL2 == "❌"{
                                    ref.child("imageURL").setValue(imageURL)
                                    self.downloadedFrom(link: imageURL)
                                    
                                    
                                }
                                else {
                                    
                                    self.downloadedFrom(link: imageURL2)
                                    
                                    
                                }
                            }
                            
                            
                            var displayName = value?["displayName"] as? String ?? "❌"
                            if displayName == "❌"{
                                ref.child("displayName").setValue(FIRAuth.auth()?.currentUser?.displayName)
                                displayName=(FIRAuth.auth()?.currentUser?.displayName)!
                            }
                            
                            let imagePathsSnapshot=snapshot.childSnapshot(forPath: "coverImages")
                            let favoritesPathSnapshot=snapshot.childSnapshot(forPath: "likedCoverImages")
                            for dict in imagePathsSnapshot.children {
                                self.sellingImagesPaths.append((dict as AnyObject).value)
                            }
                            for dict in favoritesPathSnapshot.children {
                                self.favoriteImagesPaths.append((dict as AnyObject).value)
                            }
                        })
                    }
                    
                    
                    
                    
                    
                }
            }
        }
        else {
            
            
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference().child("users").child(uid!)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let imageURL = value?["imageURL"] as? String ?? "❌"
                self.downloadedFrom(link: imageURL)
                self.email = value?["email"] as? String ?? "❌"
                self.displayName = value?["displayName"] as? String ?? "❌"
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
    
    func changeProfilePicture(downloadURL:String){
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference().child("users").child(uid!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            ref.child("imageURL").setValue(downloadURL)
        })
    }
}



extension User:UserDelegate{
    func getChatsCells(keyString:String){
        var i=0
        let ref = FIRDatabase.database().reference().child("users").child(keyString).child("directChats")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {

            for child in snapshot.children{
                let path:String = (child as AnyObject).key
            var date:String=""
            let tempRef=FIRDatabase.database().reference().child("chats").child(path)
            tempRef.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                date = value?["chatLastDate"] as? String ?? ""
                let user1 = value?["user1"] as? String ?? ""
                let user2 = value?["user2"] as? String ?? ""
                let cell=ChatsTableViewCell()
                var tempUser = User()
                tempUser.delegate=cell
                tempUser.cellIndex=i
                
                if user1==currentUser.uid{
                    tempUser.setupUser(id: user2, isLoggedIn: false)
                }
                else {
                    tempUser.setupUser(id: user1, isLoggedIn: false)
                }
                cell.user=tempUser
                cell.isGlobal=false
                cell.chatPath=path
                cell.date=date
                cell.name=tempUser.displayName
                print(date)
                print(cell.date)
                self.directChats.append(cell)
                i+=1

                
            }) { (error) in
                print(error.localizedDescription)
                }
                }}
            

        }) { (error) in
            print(error.localizedDescription)
        }
        

        
        
        
        
        var e=0
        let ref2 = FIRDatabase.database().reference().child("items").child(keyString)
        ref2.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for child in snapshot.children{
                    let path:String = (child as AnyObject).key
                    var date:String=""
                    let tempRef=FIRDatabase.database().reference().child("chats").child(path)
                    tempRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as? NSDictionary
                        date = value?["chatLastDate"] as? String ?? ""
                        let name = value?["title"] as? String ?? ""

                                              let cell=ChatsTableViewCell()
                        cell.isGlobal=true
                        cell.chatPath=path
                        cell.date=date
                        cell.name = name
                        print(cell.date)
                        self.directChats.append(cell)
                        i+=1
                        
                        
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }}
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        

        
        
        
        
    }
    func imageLoaded(image: UIImage, user: User, index:Int?) {
        directChats[index!].img=image
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
                self.delegate?.imageLoaded(image: image,user: self, index: self.cellIndex)
                return
                
            }
            }.resume()
    }
}



