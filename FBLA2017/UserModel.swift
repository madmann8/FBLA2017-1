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
    func imageLoaded(image: UIImage, user: User, index: Int?)

}

protocol ChatImageLoadedDelegate {
    func chatUserImageLoaded()
}

protocol ChatsTableCanReloadDelegate {
    func refreshChats()
}

class User: NSObject {
    
    

    var uid: String!
    var displayName: String!
    var email: String!
    var city: String!
    var profileImage: UIImage!
    var sellingImagesPaths: [String]=[]
    var favoriteImagesPaths: [String]=[]
    var itemChats=[ChatsTableViewCell]()
    var directChats=[ChatsTableViewCell]()
    var cellIndex: Int?
    var itemChar: Bool?
    var hasLoaded = false
    var chatsCount = 0
    var chatsCountIncrementer = 0
    var groupPath: String = "temp"

    var geoCoder: CLGeocoder!
    var locationManager: CLLocationManager!

    var delegate: UserDelegate?
    var chatImageLoadedDelegate: ChatImageLoadedDelegate?
    var chatTableCanReloadDelegate: ChatsTableCanReloadDelegate?
    var hasLoadedDelegate: TableHasLoadedDelegate?

    public func loadGroup() {
        if self.groupPath == "temp" {
            self.groupPath = UserDefaults.standard.string(forKey: "currentUserGroup") ?? "temp"

            currentGroup = groupPath

//            var ref: FIRDatabaseReference!
//            ref = FIRDatabase.database().reference().child(currentGroup)
//            let userID = FIRAuth.auth()?.currentUser?.uid
//            ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//                // Get user value
//                let value = snapshot.value as? NSDictionary
//                self.groupPath = value?["groupPath"] as? String ?? ""
//                currentGroup=self.groupPath
//                
//                // ...
//            }) { (error) in
//                print(error.localizedDescription)
//            }

        } else {
//            FIRDatabase.database().reference().child(currentGroup).child("users").child("groupPath").setValue(self.groupPath)
            UserDefaults.standard.set(self.groupPath, forKey: "currentUserGroup")
            currentGroup = self.groupPath
        }

    }

    public  func setupUser(id: String, isLoggedIn: Bool) {
              if id != ""{
        var shouldLoad = true

        if (currentUser.uid) != nil && currentUser.uid == id {
            shouldLoad = false
        }
        if shouldLoad {
        self.geoCoder = CLGeocoder()
        self.locationManager = CLLocationManager()

        uid = id
        if let display = FIRAuth.auth()?.currentUser?.displayName {
            displayName = display
        } else {
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference().child(currentGroup)
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
        email = FIRAuth.auth()?.currentUser?.email
        setCityLabel()
        getProfilePic(isLoggedIn: isLoggedIn)
        if isLoggedIn {
            getChatsCells(keyString: id)
        }

        } else {
             uid = currentUser.uid
             displayName = currentUser.displayName
             email = currentUser.email
             city = currentUser.city
            profileImage = currentUser.profileImage
             sellingImagesPaths = currentUser.sellingImagesPaths
             favoriteImagesPaths = currentUser.favoriteImagesPaths
             itemChats = currentUser.itemChats
             directChats = currentUser.directChats
             cellIndex = currentUser.cellIndex
             itemChar = currentUser.itemChar
             geoCoder = currentUser.geoCoder
             locationManager = currentUser.locationManager
        }

    }
    }
}

//Profile Picture Stuff
extension User {
    func getProfilePic(isLoggedIn: Bool) {
        if (isLoggedIn) {
            if let providerData = FIRAuth.auth()?.currentUser?.providerData {
                for userInfo in providerData {
                    if userInfo.providerID=="password" {

                        var ref: FIRDatabaseReference!
                        ref = FIRDatabase.database().reference().child(currentGroup).child("users").child(uid!)
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
                                self.email = (FIRAuth.auth()?.currentUser?.email)!
                            }

                            let imagePathsSnapshot = snapshot.childSnapshot(forPath: "coverImages")
                            let favoritesPathSnapshot = snapshot.childSnapshot(forPath: "likedCoverImages")
                            if let coverArray = imagePathsSnapshot.value as? NSDictionary {
                                if (coverArray.count) > 0 {
                                    for kv in coverArray {
                                        let s = kv.value as! String
                                        self.sellingImagesPaths.append(s)
                                    }
                                }
                            }
                            if let favoritesArray = imagePathsSnapshot.value as? NSDictionary {
                                if (favoritesArray.count) > 0 {
                                    for kv in favoritesArray {
                                        let s = kv.value as! String
                                        self.favoriteImagesPaths.append(s)
                                    }
                                }
                            }
//                            self.displayName = value?["displayName"] as? String ?? "❌"
                            if self.displayName == "❌"{
                                ref.child("displayName").setValue(FIRAuth.auth()?.currentUser?.displayName)
                                self.displayName = (FIRAuth.auth()?.currentUser?.displayName)!
                            }
                        }

                        )

                    } else {
                        var ref: FIRDatabaseReference!
                        ref = FIRDatabase.database().reference().child(currentGroup).child("users").child(uid!)
                        ref.observeSingleEvent(of: .value, with: { (snapshot) in
                            // Get user value
                            let value = snapshot.value as? NSDictionary
                            var displayName = value?["displayName"] as? String ?? "❌"
                            if displayName == "❌"{
                                ref.child("displayName").setValue(FIRAuth.auth()?.currentUser?.displayName)
                                displayName = (FIRAuth.auth()?.currentUser?.displayName)!
                            }

                            var imageURL: String = FIRAuth.auth()?.currentUser?.photoURL?.absoluteString ?? "❌"
                            if imageURL == "❌"{
                                ref.child("imageURL").setValue("https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg")
                                imageURL="https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg"
                            } else {
                                var imageURL2 = value?["imageURL"] as? String ?? "❌"
                                if imageURL2 == "❌"{
                                    ref.child("imageURL").setValue(imageURL)
                                    self.downloadedFrom(link: imageURL)

                                } else {

                                    self.downloadedFrom(link: imageURL2)

                                }
                            }

                            let imagePathsSnapshot = snapshot.childSnapshot(forPath: "coverImages")
                            let favoritesPathSnapshot = snapshot.childSnapshot(forPath: "likedCoverImages")
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
        } else {

            var ref: FIRDatabaseReference!
            if let uid = uid {
                if uid != ""{
            ref = FIRDatabase.database().reference().child(currentGroup).child("users").child(uid)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.displayName = value?["displayName"] as? String ?? "❌"
                let imageURL = value?["imageURL"] as? String ?? "❌"
                self.downloadedFrom(link: imageURL)
                self.email = value?["email"] as? String ?? "❌"
                let imagePathsSnapshot = snapshot.childSnapshot(forPath: "coverImages")
                let favoritesPathSnapshot = snapshot.childSnapshot(forPath: "likedCoverImages")
                if let coverArray = imagePathsSnapshot.value as? NSDictionary {
                    if (coverArray.count) > 0 {
                        for kv in coverArray {
                            let s = kv.value as! String
                            self.sellingImagesPaths.append(s)
                        }
                    }
                }
                if let favoritesArray = imagePathsSnapshot.value as? NSDictionary {
                    if (favoritesArray.count) > 0 {
                        for kv in favoritesArray {
                            let s = kv.value as! String
                            self.favoriteImagesPaths.append(s)
                        }
                    }
                }

            })

                }
            }

        }
    }
}

//Location Stuff

extension User:CLLocationManagerDelegate {

    func setCityLabel() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.first!
        geoCode(location: location)
    }

    func geoCode(location: CLLocation!) {
        geoCoder.cancelGeocode()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, _) -> Void in
            guard let placeMarks = data as [CLPlacemark]! else {
                return
            }
            let loc: CLPlacemark = placeMarks[0]
            let addressDict: [NSString:NSObject] = loc.addressDictionary as! [NSString: NSObject]
            let addrList = addressDict["FormattedAddressLines"] as! [String]
            if addrList.count > 1 {
                let address: String? = addrList[1]
                self.handleLocation(city: address!, lat: nil, long: nil)
            } else {
                if !addrList.isEmpty {
                    let address: String? = addrList[0]
                    self.handleLocation(city: address!, lat: nil, long: nil)
                } else {
                    let address="Unknown Location"
                    self.handleLocation(city: address, lat: "\(location.coordinate.latitude)", long: "\(location.coordinate.longitude)")
                }

            }
        })

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Maps error: \(error.localizedDescription)")

        return

    }

    func  handleLocation(city: String, lat: String?, long: String?) {
        var ref: FIRDatabaseReference!
        if currentGroup != "" {
        ref = FIRDatabase.database().reference().child(currentGroup).child("users").child(uid!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.city = city
            ref.child("locationString").setValue(self.city)

        })
        }
    }

    func changeProfilePicture(downloadURL: String) {
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference().child(currentGroup).child("users").child(uid!)
        ref.observeSingleEvent(of: .value, with: { (_) in
            ref.child("imageURL").setValue(downloadURL)
        })
    }
}

//Chat tableview stuff
extension User:UserDelegate {
    func getChatsCells(keyString: String) {
        var doneLoading = false
        var i = 0
        let ref = FIRDatabase.database().reference().child(currentGroup).child("users").child(keyString).child("directChats")
        let ref2 = FIRDatabase.database().reference().child(currentGroup).child("users").child(keyString).child("itemChats")

        var tempCount=0
        
        var hasLoadedFirst=false
        
        ref2.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                self.chatsCount += 1
            }
            if hasLoadedFirst {
                if !snapshot.hasChildren() {
                    self.chatTableCanReloadDelegate?.refreshChats()
                }
            }
            else {
                hasLoadedFirst=true
            }
        })

        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                self.chatsCount += 1
            }
            if hasLoadedFirst {
                if !snapshot.hasChildren() {
                    self.chatTableCanReloadDelegate?.refreshChats()
                }
            }
            else {
                hasLoadedFirst=true
            }
        })

        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {

            for child in snapshot.children {
                let path: String = (child as AnyObject).key
            var date: String=""
            let tempRef = FIRDatabase.database().reference().child(currentGroup).child("chats").child(path)
            tempRef.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                date = value?["chatLastDate"] as? String ?? ""
                let user1 = value?["user1"] as? String ?? ""
                let user2 = value?["user2"] as? String ?? ""
                let cell = ChatsTableViewCell()
                var tempUser = User()
                tempUser.delegate = cell
                tempUser.chatImageLoadedDelegate = self
                tempUser.cellIndex = i

                if user1 == currentUser.uid {
                    tempUser.setupUser(id: user2, isLoggedIn: false)
                } else {
                    tempUser.setupUser(id: user1, isLoggedIn: false)
                }
                cell.user = tempUser
                cell.isGlobal = false
                cell.chatPath = path
                cell.date = date

                cell.name = tempUser.displayName
                self.directChats.append(cell)
                if doneLoading {
                    self.hasLoadedDelegate?.hasLoaded()
                } else {
                    doneLoading = true

                }
//                i+=1

            }) { (error) in
                print(error.localizedDescription)
                }
                }}

        }) { (error) in
            print(error.localizedDescription)
        }

        var e = 0
        ref2.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {

                for child in snapshot.children {
                    let path: String = (child as AnyObject).key
                    let tempRef = FIRDatabase.database().reference().child(currentGroup).child("items").child(path)
                    tempRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as? NSDictionary
                        let date = value?["chatLastDate"] as? String ?? ""
                        let name = value?["title"] as? String ?? ""
                        let imagePath = value?["coverImage"] as? String ?? ""
                        let cell = ChatsTableViewCell()

                        cell.coverImagePath = imagePath
                        cell.isGlobal = true
                        cell.date = date
                        cell.name = name
                        cell.itemPath = path
                        cell.chatImageLoadedDelegate = self

                        self.itemChats.append(cell)
                        if doneLoading {
                            self.hasLoadedDelegate?.hasLoaded()
                        } else {
                            doneLoading = true

                        }
//                        i+=1

                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }}

        }) { (error) in
            print(error.localizedDescription)
        }

    }
    func imageLoaded(image: UIImage, user: User, index: Int?) {
        directChats[index!].img = image
    }

    func doneLoading() {
        //
    }

}

extension User:ChatImageLoadedDelegate {
    func chatUserImageLoaded() {

         chatsCountIncrementer += 1
        if chatsCountIncrementer >= self.chatsCount {
            for cell in directChats {
                cell.name = cell.user?.displayName
            }
           self.chatTableCanReloadDelegate?.refreshChats()

        }

   //
    }
    func resetLoadedCell() {
         self.itemChats=[ChatsTableViewCell]()
        self.directChats=[ChatsTableViewCell]()
        self.chatsCountIncrementer = 0
        self.chatsCount = 0
        getChatsCells(keyString: self.uid)

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
            DispatchQueue.main.sync {

                self.profileImage = image
                self.delegate?.imageLoaded(image: image, user: self, index: self.cellIndex)
                self.chatImageLoadedDelegate?.chatUserImageLoaded()
                return

            }
            }.resume()
    }
}
