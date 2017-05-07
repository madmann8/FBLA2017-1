//
//  Item.swift
//  FBLA2017
//
//  Created by Luke Mann on 4/21/17.
//  Copyright © 2017 Luke Mann. All rights reserved.
//

import UIKit
import Firebase

protocol ItemDelegate {
    func doneLoading(item: Item)

}

class Item {
    var images: [UIImage]?
    var categorey: String?
    var name: String?
    var about: String?
    var latitudeString: String?
    var longitudeString: String?
    var addressString: String?
    var cents: Int? {
        didSet {
            self.dollarString=""
            let num: Double = Double(cents!) / 100.0
            let formatter = NumberFormatter()
            formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
            formatter.numberStyle = .currency
            if let formattedAmount = formatter.string(from: num as NSNumber) {
                self.dollarString = "\(formattedAmount)"
            }

        }
    }
    var condition: Int?
    var keyString: String?
    var coverImagePath: String?
    var userID: String?
    var user: User?
    var uid: String?
    var deleted: Bool = false
    var dollarString: String?
    var hasLiked: Bool = false

    var delegate: ItemDelegate?

    func load(keyString: String) {
        if !deleted {

        self.uid = keyString
        var images=[UIImage]()
        var name: String?=nil
        var about: String?=nil
        var categorey: String?=nil
        var latitudeString: String?=nil
        var longitudeString: String?=nil
        var addressString: String?=nil
        var cents: Int?=nil
        var condition: Int?=nil
        var userID: String?=nil

        let ref = FIRDatabase.database().reference().child(currentGroup).child("coverImagePaths").child(keyString)
        ref.observe(.value, with: {(snapshot) in
            if let value = snapshot.value as? String {
            self.coverImagePath = value
            }
        })

        let ref1 = FIRDatabase.database().reference().child(currentGroup).child("items").child(keyString)
        let user = User()

        ref1.observe(.value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            name = value?["title"] as? String ?? ""
            about = value?["about"] as? String ?? ""
            categorey = value?["category"] as? String ?? ""
            latitudeString = value?["locationLatitude"] as? String ?? ""
            longitudeString = value?["locationLongitude"] as? String ?? ""
            addressString = value?["locationString"] as? String ?? ""
            condition = value?["condition"] as? Int ?? 0
            cents = value?["cents"] as? Int ?? 0
            userID = value?["userID"] as? String ?? ""
            user.setupUser(id: userID!, isLoggedIn: false)

        })
        let storage = FIRStorage.storage()
        ref1.child("imagePaths").observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                var i = 0
                for snapshot in snapshots {
                    if let path = snapshot.value as? String {
                        let imagePath = storage.reference(forURL: path)
                        imagePath.data(withMaxSize: 1 * 6_000 * 6_000) { data, error in
                            if let error = error {
                                // Uh-oh, an error occurred!
                            } else {
                                let image = UIImage(data: data!)
                                images.append(image!)
                                print(i)
                                i += 1
                                if i == snapshots.count {
                                    self.categorey = categorey
                                    self.name = name
                                    self.about = about
                                    self.latitudeString = latitudeString
                                    self.longitudeString = longitudeString
                                    self.addressString = addressString
                                    self.cents = cents
                                    self.condition = condition
                                    self.images = images
                                    self.keyString = keyString
                                    self.user = user

                                    self.delegate?.doneLoading(item: self)

                                }
                            }
                        }

                    }
                }
            }

        })

        }

    }
    }
